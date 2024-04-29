<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.math.BigDecimal" %>

<%
    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    ResultSet generatedKeys = null;
    try {
        con = db.getConnection();
        String username = (String) session.getAttribute("username"); 
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String price = request.getParameter("price");
        String listingID = request.getParameter("listing_id");

        if (listingID == null) {
            out.println("<p>Error: Listing ID is required.</p>");
            return;
        }
	
        int listingId = Integer.parseInt(listingID);
        
        //check if the owner is attempting to bid on their own listing
        String queryOwner = "SELECT username FROM posts WHERE listing_id = ?";
        ps = con.prepareStatement(queryOwner);
        ps.setInt(1, listingId);
        rs = ps.executeQuery();
        
        if(rs.next()){
        	String ownerUsername = rs.getString("username");
        	if(ownerUsername.equals(username)){
        		out.println("<p>Error: You cannot bid on your own listing. </p>");
        		return;
        	}
        }
        
        //We need to check if the bid is higher than the current bid going in or is higher than the current price of the listing.
        BigDecimal bidPrice = new BigDecimal(price);

        String getMaxBid = "SELECT MAX(b.price) AS highest_bid FROM bids b JOIN bidsOn bo ON b.bid_id = bo.bid_id WHERE bo.listing_id = ?";
        ps = con.prepareStatement(getMaxBid);
        ps.setInt(1, listingId);
        rs = ps.executeQuery();
        BigDecimal highestBid = BigDecimal.ZERO;
        if (rs.next() && rs.getBigDecimal("highest_bid") != null) {
            highestBid = rs.getBigDecimal("highest_bid");
        } else {
            
            String getInitialPrice = "SELECT initial_price FROM listings WHERE listing_id = ?";
            ps = con.prepareStatement(getInitialPrice);
            ps.setInt(1, listingId);
            rs = ps.executeQuery();
            if (rs.next()) {
                highestBid = rs.getBigDecimal("initial_price");
            }
        }

        // Compare bid price with the highest bid
        if (bidPrice.compareTo(highestBid) <= 0) {
            out.println("<p>Error: Your bid must be higher than the current highest bid of $" + highestBid + ".</p>");
            return;
        }
		
        //Bids
        String insertBid = "INSERT INTO bids(price, bid_dt) VALUES(?, NOW())";
        ps = con.prepareStatement(insertBid, Statement.RETURN_GENERATED_KEYS);
        ps.setBigDecimal(1, new BigDecimal(price));
        ps.executeUpdate();
        
        generatedKeys = ps.getGeneratedKeys();
        int bidID = 0;
        if (generatedKeys.next()) {
            bidID = generatedKeys.getInt(1);
        }
	
        //Places
        String insertPlace = "INSERT INTO places(username, bid_id) VALUES(?, ?)";
        ps = con.prepareStatement(insertPlace);
        ps.setString(1, username);
        ps.setInt(2, bidID);
        ps.executeUpdate();
        
        //bidsOn
        String insertListingBid = "INSERT INTO bidsOn(listing_id, bid_id) VALUES(?, ?)";
        ps = con.prepareStatement(insertListingBid);
        ps.setInt(1, listingId);
        ps.setInt(2, bidID);
        ps.executeUpdate();

        //Update Listing Price
        String updateListingPrice = "UPDATE listings SET initial_price = ? WHERE listing_id = ? AND initial_price < ?";
        ps = con.prepareStatement(updateListingPrice);
        ps.setBigDecimal(1, new BigDecimal(price));
        ps.setInt(2, listingId);
        ps.setBigDecimal(3, new BigDecimal(price));
        int updateCount = ps.executeUpdate();
        
        
        response.sendRedirect("Listings.jsp");
    } catch (SQLException e) {
        out.println("<p>Error processing request: " + e.getMessage() + "</p>");
    } finally {
        if (generatedKeys != null) {
            try {
                generatedKeys.close();
            } catch (SQLException e) {
                out.println("<p>Error closing generated keys: " + e.getMessage() + "</p>");
            }
        }
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                out.println("<p>Error closing PreparedStatement: " + e.getMessage() + "</p>");
            }
        }
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                out.println("<p>Error closing Connection: " + e.getMessage() + "</p>");
            }
        }
    }
%>