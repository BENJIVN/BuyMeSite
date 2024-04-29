<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.math.BigDecimal" %>

<%
    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement ps = null;
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
        generatedKeys.close();
        ps.close();
        con.close();
    }
%>