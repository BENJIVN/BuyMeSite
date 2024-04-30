<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.math.BigDecimal"%>

<%
ApplicationDB db = new ApplicationDB();
Connection con = null;
PreparedStatement ps = null;
ResultSet generatedKeys = null;
ResultSet rs = null;

try {
	con = db.getConnection();
	String username = (String) session.getAttribute("username");

	if (username == null) {
		response.sendRedirect("login.jsp");
		return;
	}

	String listingID = request.getParameter("listing_id");
	if (listingID == null || listingID.isEmpty()) {
		out.println("<p>Error: Listing ID is required for auto bidding.</p>");
		return;
	}

	int listingId = Integer.parseInt(listingID);

	//Cant bid on their own listing
	String queryOwner = "SELECT username FROM posts WHERE listing_id = ?";
	ps = con.prepareStatement(queryOwner);
	ps.setInt(1, listingId);
	rs = ps.executeQuery();

	if (rs.next()) {
		String ownerUsername = rs.getString("username");
		if (ownerUsername.equals(username)) {
	out.println("<p>Error: You cannot bid on your own listing. </p>");
	return;
		}
	}

	//BigDecimal initialPrice = new BigDecimal(request.getParameter("price"));
	BigDecimal increments = new BigDecimal(request.getParameter("increments"));
	BigDecimal upperLimit = new BigDecimal(request.getParameter("upperLimit"));

	/*  //check here
	 if(initialPrice.compareTo(upperLimit) > 0 || increments.compareTo(BigDecimal.ZERO) <= 0){
	 	request.setAttribute("errorMessage", "Invalid auto-bid settings. Please check your values.");
	 	return;
	 } */

	String query = "INSERT INTO auto_bids (username, listing_id, increment, upper_limit, active) VALUES (?, ?, ?, ?, ?)";
	ps = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
	ps.setString(1, username);
	ps.setInt(2, listingId);
	//ps.setBigDecimal(3, initialPrice);
	ps.setBigDecimal(3, increments);
	ps.setBigDecimal(4, upperLimit);
	ps.setBoolean(5, true);
	int affectedRows = ps.executeUpdate();

	if (affectedRows == 0) {
		throw new SQLException("Creating auto-bid failed, no rows affected.");
	}

	generatedKeys = ps.getGeneratedKeys();
	if (generatedKeys.next()) {
		int autoBidId = generatedKeys.getInt(1);
		session.setAttribute("auto_bid_id", autoBidId);
		response.sendRedirect("Listings.jsp");
	} else {
		throw new SQLException("Creating auto-bid failed, no ID obtained.");
	}

} finally {
	if (generatedKeys != null) {
		try {
	generatedKeys.close();
		} catch (SQLException e) {
	e.printStackTrace();
		}
	}
	if (ps != null) {
		try {
	ps.close();
		} catch (SQLException e) {
	e.printStackTrace();
		}
	}
	if (con != null) {
		try {
	con.close();
		} catch (SQLException e) {
	e.printStackTrace();
		}
	}
}
%>