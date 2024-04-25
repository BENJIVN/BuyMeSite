<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cs336.pkg.*"%>
<%@page import="java.io.*,java.util.*,java.sql.*, java.math.BigDecimal"%>

<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    try {
        //con.setAutoCommit(false); // Disable auto-commit to handle transactions manually
        
        String username = (String) session.getAttribute("username"); 
        if (username == null) {
            response.sendRedirect("login.jsp");
            return; 
        }
        
        String price = request.getParameter("price");
        String listingID = request.getParameter("listing_id");
        
        
        String insertBid = "INSERT INTO bids(price, bid_dt) VALUES(?, NOW())";
        PreparedStatement ps = con.prepareStatement(insertBid, Statement.RETURN_GENERATED_KEYS);
        ps.setBigDecimal(1, new BigDecimal(price));
        ps.executeUpdate();
        
        ResultSet generatedKeys = ps.getGeneratedKeys();
        int bidID = 0;
        if (generatedKeys.next()) {
            bidID = generatedKeys.getInt(1);
        }
        
        String insertPlace = "INSERT INTO places(username, bid_id) VALUES(?, ?)";
        ps = con.prepareStatement(insertPlace);
        ps.setString(1, username);
        ps.setInt(2, bidID);
        ps.executeUpdate();
        
        String insertListingBid = "INSERT INTO listingBids(listing_id, bid_id) VALUES(?, ?)";
        ps = con.prepareStatement(insertListingBid);
        ps.setInt(1, Integer.parseInt(listingID));
        ps.setInt(2, bidID);
        ps.executeUpdate();

        String updateListingPrice = "UPDATE listings SET price = ? WHERE listing_id = ? AND price < ?";
        ps = con.prepareStatement(updateListingPrice);
        ps.setBigDecimal(1, new BigDecimal(price));
        ps.setString(2, listingID);
        ps.setBigDecimal(3, new BigDecimal(price));
        int updateCount = ps.executeUpdate();
     
        //con.commit();
        
        ps.close();
        con.close();
        response.sendRedirect("Listings.jsp");
    } catch (SQLException e) {        
    } finally {
        
    }
%>