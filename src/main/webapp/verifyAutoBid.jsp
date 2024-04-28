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
        
        String listingID = request.getParameter("listing_id");
        
        if (listingID == null){
        	out.println("<p>Error: Listing ID is required.</p>");
        	return;
        }
        
        int listingId = Integer.parseInt(listingID);
        
        BigDecimal initialPrice = new BigDecimal(request.getParameter("price"));
        BigDecimal increments = new BigDecimal(request.getParameter("increments"));
        BigDecimal upperLimit = new BigDecimal(request.getParameter("upperLimit"));
        
        //check here
        if(initialPrice.compareTo(upperLimit) > 0 || increments.compareTo(BigDecimal.ZERO) <= 0){
        	request.setAttribute("errorMessage", "Invalid auto-bid settings. Please check your values.");
        	return;
        }
        
        String query = "INSERT INTO auto_bids (username, listing_id, initial_price, increment, upper_limit, active) VALUES (?, ?, ?, ?, ?, ?)";
        ps = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, username);
        ps.setInt(2, listingId);
        ps.setBigDecimal(3, initialPrice);
        ps.setBigDecimal(4, increments);
        ps.setBigDecimal(5, upperLimit);
        ps.setBoolean(6, true);
        int affectedRows = ps.executeUpdate();

        if (affectedRows == 0) {
            throw new SQLException("Creating auto-bid failed, no rows affected.");
        }

        generatedKeys = ps.getGeneratedKeys();
        if (generatedKeys.next()) {
            int autoBidId = generatedKeys.getInt(1);
            session.setAttribute("autoBidId", autoBidId);
            response.sendRedirect("autoBidSuccess.jsp");
        } else {
            throw new SQLException("Creating auto-bid failed, no ID obtained.");
        }
        
	} finally{
		generatedKeys.close();
		ps.close();
		con.close();
		
	}
%>