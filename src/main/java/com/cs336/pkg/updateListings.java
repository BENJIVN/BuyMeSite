package com.cs336.pkg;

import java.sql.Timestamp;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class updateListings extends Thread{ //thank you sesh for making 213 my nightmare
	private Connection connection;
	private static final long TIMEOUT_SECONDS = 1;
	
	
	public updateListings(Connection connection) {
		 this.connection = connection;	        
	}
	
	public void run() {
        while (true) {
        	updateListing();
            try {
                Thread.sleep(TIMEOUT_SECONDS * 1000); // Sleep for the timeout period
            } catch (InterruptedException e) {
                e.printStackTrace();
            } 
        }
    }
	
	private void updateListing() {
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    try {
	        String query = "SELECT listing_id, date_time, initial_price, min_sale FROM listings WHERE open_close=0";
	        ps = connection.prepareStatement(query);
	        rs = ps.executeQuery();
	        
	        while(rs.next()) {
	            int listingId = rs.getInt("listing_id");
	            Timestamp closeTime = rs.getTimestamp("date_time");
	            Timestamp currentTime = new Timestamp(System.currentTimeMillis());
	            
	            // Check if listing should be closed based on the closing time
	            if (!closeTime.after(currentTime)) {
	                closeListing(listingId, rs.getDouble("initial_price"), rs.getDouble("min_sale"));
	            } else {
	                // Check and potentially update auto bids if the listing is still active
	                checkAndUpdateAutoBids(listingId);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        closeResources(ps, rs);
	    }
	}

	private void closeListing(int listingId, double currentPrice, double minSale) throws SQLException {
	    PreparedStatement ps = null;
	    try {
	        // Close the listing
	        ps = connection.prepareStatement("UPDATE listings SET open_close=1 WHERE listing_id=?");
	        ps.setInt(1, listingId);
	        ps.executeUpdate();

	        // Check if current price is above the minimum sale price
	        if (currentPrice >= minSale) {
	            registerSale(listingId, currentPrice);
	        }
	    } finally {
	        if (ps != null) ps.close();
	    }
	}

	private void registerSale(int listingId, double salePrice) throws SQLException {
	    PreparedStatement ps = null;
	    try {
	        ps = connection.prepareStatement("INSERT INTO sales (sale_dt, amount) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
	        ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
	        ps.setDouble(2, salePrice);
	        ps.executeUpdate();
	        
	        ResultSet generatedKeys = ps.getGeneratedKeys();
	        if (generatedKeys.next()) {
	            int saleId = generatedKeys.getInt(1);
	            linkSaleToListing(saleId, listingId);
	        }
	    } finally {
	        if (ps != null) ps.close();
	    }
	}

	private void linkSaleToListing(int saleId, int listingId) throws SQLException {
	    PreparedStatement ps = null;
	    try {
	        ps = connection.prepareStatement("INSERT INTO generate (sale_id, listing_id) VALUES (?, ?)");
	        ps.setInt(1, saleId);
	        ps.setInt(2, listingId);
	        ps.executeUpdate();
	    } finally {
	        if (ps != null) ps.close();
	    }
	}

	private void closeResources(PreparedStatement ps, ResultSet rs) {
	    if (rs != null) {
	        try {
	            rs.close();
	        } catch (SQLException e) {
	            System.out.println("Error closing ResultSet: " + e.getMessage());
	        }
	    }
	    if (ps != null) {
	        try {
	            ps.close();
	        } catch (SQLException e) {
	            System.out.println("Error closing PreparedStatement: " + e.getMessage());
	        }
	    }
	}
	
	@SuppressWarnings("unused")
	private void checkAndUpdateAutoBids(int listingId) {
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    PreparedStatement updatePs = null;
	    PreparedStatement insertBidPs = null;
	    ResultSet generatedKeys = null;
	    PreparedStatement insertBidsOnPs = null;
	    PreparedStatement insertPlacesPs = null;

	    try {
	        String query = "SELECT ab.username, ab.listing_id, ab.increment, ab.upper_limit, l.initial_price, " +
	                       "(SELECT MAX(b.price) FROM bids b JOIN bidsOn bo ON b.bid_id = bo.bid_id WHERE bo.listing_id = ab.listing_id) AS max_bid, " +
	                       "(SELECT p.username FROM bids b JOIN bidsOn bo ON b.bid_id = bo.bid_id JOIN places p ON p.bid_id = b.bid_id WHERE bo.listing_id = ab.listing_id ORDER BY b.price DESC LIMIT 1) AS max_bidder " +
	                       "FROM auto_bids ab " +
	                       "JOIN listings l ON l.listing_id = ab.listing_id " +
	                       "WHERE l.listing_id = ? AND l.open_close = 0 AND ab.active = TRUE";

	        ps = connection.prepareStatement(query);
	        ps.setInt(1, listingId);
	        rs = ps.executeQuery();

	        while (rs.next()) {
	            String username = rs.getString("username");
	            double increment = rs.getDouble("increment");
	            double upperLimit = rs.getDouble("upper_limit");
	            double initialPrice = rs.getDouble("initial_price");
	            Double maxBid = rs.getDouble("max_bid");
	            String maxBidder = rs.getString("max_bidder");
	            
	            double newBid;
	            if (maxBid == null) {
	               
	                newBid = initialPrice + increment;
	                
	            } else if (!username.equals(maxBidder)) {
	        
	                newBid = maxBid + increment;
	            } else {
	               
	                continue;
	            }
	            
	       
	            if (newBid <= upperLimit) {
	                // Update the listing's initial price with the new bid
	                updatePs = connection.prepareStatement("UPDATE listings SET initial_price = ? WHERE listing_id = ?");
	                updatePs.setDouble(1, newBid);
	                updatePs.setInt(2, listingId);
	                updatePs.executeUpdate();

	                // Insert the new bid into the bids table
	                insertBidPs = connection.prepareStatement("INSERT INTO bids (price, bid_dt) VALUES (?, NOW())", Statement.RETURN_GENERATED_KEYS);
	                insertBidPs.setDouble(1, newBid);
	                insertBidPs.executeUpdate();
	                generatedKeys = insertBidPs.getGeneratedKeys();

	                if (generatedKeys.next()) {
	                    int bidId = generatedKeys.getInt(1);

	                    // Link the new bid to the listing
	                    insertBidsOnPs = connection.prepareStatement("INSERT INTO bidsOn (listing_id, bid_id) VALUES (?, ?)");
	                    insertBidsOnPs.setInt(1, listingId);
	                    insertBidsOnPs.setInt(2, bidId);
	                    insertBidsOnPs.executeUpdate();

	                    // Record who placed the bid
	                    insertPlacesPs = connection.prepareStatement("INSERT INTO places (username, bid_id) VALUES (?, ?)");
	                    insertPlacesPs.setString(1, username);
	                    insertPlacesPs.setInt(2, bidId);
	                    insertPlacesPs.executeUpdate();
	                }
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (generatedKeys != null) generatedKeys.close();
	            if (insertPlacesPs != null) insertPlacesPs.close();
	            if (insertBidsOnPs != null) insertBidsOnPs.close();
	            if (insertBidPs != null) insertBidPs.close();
	            if (updatePs != null) updatePs.close();
	            if (rs != null) rs.close();
	            if (ps != null) ps.close();
	        } catch (SQLException ex) {
	        	
	        }
	    }
	}
}
        

	





