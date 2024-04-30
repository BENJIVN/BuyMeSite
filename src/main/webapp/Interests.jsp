<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"
	import="com.cs336.pkg.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Interests</title>
</head>
<body>

	<%
	//Database connection
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();

	String username = (String) session.getAttribute("username");
	if (username == null) {
		response.sendRedirect("login.jsp");
	}

	String query = "SELECT l.listing_id " + "FROM interests i " + "JOIN listings l ON i.listing_id = l.listing_id "
			+ "JOIN users u ON i.username = u.username " + "WHERE u.username = ?";

	PreparedStatement ps = con.prepareStatement(query);
	ps.setString(1, username);
	ResultSet rs = ps.executeQuery();
	%>

	<div style="text-align: center">
		<h1>Your Interests</h1>
		<a href="Account.jsp">Go Back</a> <br>
		<table class="center">
			<tr>
				<%
				while (rs.next()) {
				%>
			</tr>
			<tr>
				<td><a
					href='viewListing.jsp?listing_id=<%=rs.getString("listing_id")%>'>View
						Listing <%=rs.getString("listing_id")%></a></td>
				<td>
					<form action="deleteInterest.jsp" method="post">
						<input type="hidden" name="listing_id"
							value='<%=rs.getString("listing_id")%>' /> <input
							type="submit" value="Remove" />
					</form>
				</td>
			</tr>
			<%
			}
			rs.close();
			ps.close();
			con.close();
			%>
		</table>
	</div>



</body>
</html>