<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.io.*,java.util.*,java.sql.*,java.math.BigDecimal, com.cs336.pkg.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Bids</title>
</head>
<body>
	<h2>Your Bids</h2>
	<div>
		<a href="Account.jsp">Go Back</a>
	</div>
	<table align="center" border="1">
		<tr>
			<th>User</th>
			<th>Bid Id</th>
			<th>Price</th>
			<th>Date/Time</th>
			<th>Actions</th>
		</tr>
		<%
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ApplicationDB db = new ApplicationDB();
			con = db.getConnection();
			String username = (String) session.getAttribute("username"); // Retrieve username from session
			if (username == null) {
				out.println("<p>You are not logged in.</p>");
			} else {
				String query = "SELECT u.username, b.bid_id, b.price, b.bid_dt FROM users u JOIN places p ON u.username = p.username JOIN bids b ON p.bid_id = b.bid_id WHERE u.username = ?";
				ps = con.prepareStatement(query);
				ps.setString(1, username); // Set username in the query
				rs = ps.executeQuery();
				while (rs.next()) {
		%>
		<tr>
			<td><%=rs.getString("username")%></td>
			<td><%=rs.getInt("bid_id")%></td>
			<td><%=rs.getBigDecimal("price").toPlainString()%></td>
			<td><%=rs.getTimestamp("bid_dt").toString()%></td>
			<td>
				<form action="deleteUserBid.jsp" method="post">
					<input type="hidden" name="bid_id"
						value='<%=rs.getInt("bid_id")%>' /> <input type="submit"
						value="Delete" />
				</form>
			</td>
		</tr>
		<%
		}
		}
		} catch (SQLException e) {
		out.println("Error retrieving bids: " + e.getMessage());
		} finally {
		if (rs != null)
		try {
		rs.close();
		} catch (SQLException e) {
		}
		if (ps != null)
		try {
		ps.close();
		} catch (SQLException e) {
		}
		if (con != null)
		try {
		con.close();
		} catch (SQLException e) {
		}
		}
		%>
	</table>
</body>
</html>
