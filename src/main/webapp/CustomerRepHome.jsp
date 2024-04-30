<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Representative Home Page</title>
</head>
<body>
	<div class="header">
		<%
		if ((session.getAttribute("username") == null)) {
		%>
		<p class="login-message">
			You are not logged in<br />
		</p>
		<a href="CustomerRepLogin.jsp">Please Login</a>
		<%
		} else {
		%>
		<h2 style="text-align: center">CUSTOMER REP DASHBOARD</h2>
		<table align="center">
			<tr>
				<td><a href="Q&amp;ACRHome.jsp">Q&A Home</a></td>
			</tr>
			<tr>
				<td><a href="AllBids.jsp">View/Delete Bids</a></td>
			</tr>
			<tr>
				<td><a href="AllListings.jsp">View/Delete Listings</a></td>
			</tr>
			<tr>
				<td><a href="AllUsers.jsp">View/Edit Users</a></td>
			</tr>
			<tr>
				<td><a href="logout.jsp">Log Out</a></td>
			</tr>
		</table>
		<%
		}
		%>
	</div>
</body>
</html>