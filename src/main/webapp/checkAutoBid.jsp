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
		
        PreparedStatement ps = con.prepareStatement("INSERT INTO auto_bids (username, listing_id, initial_price, increment, upper_limit, active) VALUES (?, ?, ?, ?, ?, ?)");
        ps.setString(1, username);
        ps.setInt(2, Integer.parseInt(request.getParameter("listing_id")));
        ps.setBigDecimal(3, new BigDecimal(request.getParameter("initial_price")));
        ps.setBigDecimal(4, new BigDecimal(request.getParameter("increments")));
        ps.setBigDecimal(5, new BigDecimal(request.getParameter("upperLimit")));
        ps.setBoolean(6, true); // Assuming auto-bid is active by default
        ps.executeUpdate();
    } catch(SQLException e){
    	
    }
%>