<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.cs336.pkg.*" import="java.io.*,java.util.*,java.sql.*, java.math.BigDecimal" %> 
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
		}
	%>
	<h1>Interested in the listing?</h1>
		<form method="post" action="verifyInterested.jsp">
			<table>
				<tr>
					<td><input type="submit" value="Keep Me Alerted!"/></td>
				</tr>
				
			
			</table>
		</form>
	<h1>Bid History</h1>
	<%          
                try {
                    String query = "SELECT username, price, bid_dt FROM places ORDER BY bid_dt";
                    pstt = con.prepareStatement(query);
                    rs = pstt.executeQuery();
                    while (rs.next()) {
                        BigDecimal price = rs.getBigDecimal("price");
                       
     %>
                        <tr>
                            <td><%= rs.getString("username") %></td>                           
                            <td><%= price != null ? price.toPlainString() : "N/A" %></td>                          
                            <td><%= rs.getTimestamp("bid_dt") != null ? rs.getTimestamp("bid_dt").toString() : "N/A" %></td>                       
                        </tr>
     <%
                    }
                } catch (SQLException e) {
                    out.println("Error no bids currently: " + e.getMessage());
                }
				rs.close();
				pstt.close();
				con.close();
     %>
	<h1>Make a normal bid!</h1>
		<form method="post" action="verifyBid.jsp">
			<table>
				<tr>
					<td>Price: <input type="text" name="price" value="0" maxlength="30" required/></td>
				</tr>
				<tr>
					<td><input type="submit" value="Place"/></td>
				</tr>
				
			
			</table>
		</form>
	<h1>Are you lazy? Make an AUTO-bid!</h1>
		<form method="post" action="verifyBid.jsp">
			<table>
				<tr>
					<td>Initial Price: <input type="text" name="price" value="0" maxlength="30" required/></td>
				</tr>
				<tr>
					<td>Increments: <input type="text" name="increments" value="0" maxlength="30" required/></td>
				</tr>
				<tr>
					<td>Upper Limit: <input type="text" name="upperLimit" value="0" maxlength="30" required/></td>
				</tr>
				<tr>
					<td><input type="submit" value="Place"/></td>
				</tr>
				
			
			</table>
		</form>
</body>
</html>

			