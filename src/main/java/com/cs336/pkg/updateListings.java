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
        	updateAutoBids();
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
        		double currPrice = rs.getDouble("initial_price");
        		double minSale = rs.getDouble("min_sale");
        		Timestamp closeTime = rs.getTimestamp("date_time");
        		Timestamp currentTime = new Timestamp(System.currentTimeMillis());
        		
        		if (!closeTime.after(currentTime)) {
        			ps = connection.prepareStatement("UPDATE listings SET open_close=1 WHERE listing_id=?");
        		
        		
	        		ps.setInt(1, listingId);
	        		ps.executeUpdate();
        		
					if (currPrice >= minSale) {
						
						ps = connection.prepareStatement("INSERT INTO sales (sale_dt, amount)" + "VALUES (?,?)");
						ps.setTimestamp(1, currentTime);
						ps.setDouble(2, currPrice);
						ps.executeUpdate();
						
						ps = connection.prepareStatement("INSERT INTO generate (sale_id, listing_id)" + "VALUES((SELECT MAX(sale_id) FROM sales), ?)");
						ps.setInt(1, listingId);
						ps.executeUpdate();
					}
        		}
        	}
        	
        
        }catch (SQLException e){
        	e.printStackTrace();
        }
    }
	
	private void updateAutoBids() {
		 PreparedStatement ps = null;
	    ResultSet rs = null;
	    PreparedStatement updatePs = null;
	    PreparedStatement insertBidPs = null;
	    ResultSet generatedKeys = null;
	    PreparedStatement insertBidsOnPs = null;
	    PreparedStatement insertPlacesPs = null;
		
		try {
			String query = "SELECT ab.username, ab.listing_id, ab.increment, ab.upper_limit, l.initial_price " +
		                    "FROM auto_bids ab " +
		                    "JOIN listings l ON l.listing_id = ab.listing_id " +
		                    "WHERE l.open_close = 0 AND ab.active = TRUE";
							
			
			ps = connection.prepareStatement(query);
			rs = ps.executeQuery();
			
			while (rs.next()) {
				String username = rs.getString("username");
				int listingId = rs.getInt("listing_id");
				double increment = rs.getDouble("increment");
				double upperLimit = rs.getDouble("upper_limit");
				double currPrice = rs.getDouble("initial_price");
				
				double currBid = currPrice + increment;
				
				//As long as the new bid w/ the addition of the increment is below the upper limit that the user sets it at 
				if (currBid <= upperLimit) {
					
					 updatePs = connection.prepareStatement("UPDATE listings SET initial_price = ? WHERE listing_id = ?");
		                updatePs.setDouble(1, currBid);
		                updatePs.setInt(2, listingId);
		                updatePs.executeUpdate();

		                insertBidPs = connection.prepareStatement("INSERT INTO bids (price, bid_dt) VALUES (?, NOW())", Statement.RETURN_GENERATED_KEYS);
		                insertBidPs.setDouble(1, currBid);
		                insertBidPs.executeUpdate();
		                generatedKeys = insertBidPs.getGeneratedKeys();

		                if (generatedKeys != null && generatedKeys.next()) {
		                    int bidId = generatedKeys.getInt(1);

		                    insertBidsOnPs = connection.prepareStatement("INSERT INTO bidsOn (listing_id, bid_id) VALUES (?, ?)");
		                    insertBidsOnPs.setInt(1, listingId);
		                    insertBidsOnPs.setInt(2, bidId);
		                    insertBidsOnPs.executeUpdate();

		                    insertPlacesPs = connection.prepareStatement("INSERT INTO places (username, bid_id) VALUES (?, ?)");
		                    insertPlacesPs.setString(1, username);
		                    insertPlacesPs.setInt(2, bidId);
		                    insertPlacesPs.executeUpdate();
		                    
		                    insertBidPs.close();
		                    insertBidsOnPs.close();
		                }
		                if (generatedKeys != null) generatedKeys.close();
		                insertBidPs.close();
		                updatePs.close();
		            }
		        }
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
	        try {
	            if (rs != null) rs.close();
	            if (ps != null) ps.close();
	        } catch (SQLException ex) {
	            ex.printStackTrace();
	        }
	    }
	}	
		
	
}
	

        

	





