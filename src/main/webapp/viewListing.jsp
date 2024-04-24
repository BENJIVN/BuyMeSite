<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.cs336.pkg.*" import="java.io.*,java.util.*,java.sql.*" %> 
<html>
<head>
<meta charset="UTF-8">
<title>BuyMe: Listing Details</title>
</head>
<body>
	<%
		//Database connection
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		PreparedStatement pstt = null;
		ResultSet rs = null;
		
		
		String username = (String) session.getAttribute("username"); 
		if (username == null) {
			response.sendRedirect("login.jsp");
		}
		
		try{
			int listingId = Integer.parseInt(request.getParameter("listing_id"));
			
			String query = "SELECT * FROM listings WHERE listing_id = ?";
			pstt = con.prepareStatement(query);
			pstt.setInt(1, listingId);
			rs = pstt.executeQuery();
			
			 if (rs.next()) { 
	 %>
              <h1>Listing Details</h1>
              <p>Make: <%= rs.getString("make") %></p>
              <p>Model: <%= rs.getString("model") %></p>
              <p>Color: <%= rs.getString("color") %></p>
              <p>Year: <%= rs.getInt("year") %></p>
              <p>Initial Price: <%= rs.getDouble("initial_price") %></p>
              <p>Minimum Sale Price: <%= rs.getDouble("min_sale") %></p>
              <p>Closing Date/Time: <%= rs.getTimestamp("date_time").toString() %></p>
              <p>Status: <%= rs.getInt("open_close") == 0 ? "Open" : "Closed" %></p>
	 <%
	          } else {
	             out.println("<p>Listing not found.</p>");
	          }
		}catch (Exception e){
			e.printStackTrace();
		}finally{
			rs.close();
			pstt.close();
			con.close();
			
		}
	%>
	
	<h1>WANNA MAKE A BID?</h1>
	
</body>
</html>