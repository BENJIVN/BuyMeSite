<%@ page import="java.io.*,java.util.*,java.sql.*"
	import="com.cs336.pkg.*"%>

<%
//Database connection
ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();

Statement stmt = con.createStatement();

//seller name
String username = (String) session.getAttribute("username");
if (username == null) {
	response.sendRedirect("login.jsp");
}

stmt.close();
con.close();
%>

<div style="text-align: center">
	<h1>Create a Listing</h1>
	<form method="post" action="verifyListings.jsp">
		<table align="center">
			<!-- <tr>
				<td>Car Name: <input type="text" name="carname" value="" maxlength="30" required/></td>
			</tr> -->

			<tr>
				<td>Make: <input type="text" name="make" value=""
					maxlength="30" required /></td>
			</tr>

			<tr>
				<td>Model: <input type="text" name="model" value=""
					maxlength="30" required /></td>
			</tr>

			<tr>
				<td>Color: <input type="text" name="color" value=""
					maxlength="30" required /></td>
			</tr>

			<tr>
				<td>Year: <input type="text" name="year" value=""
					maxlength="30" required /></td>
			</tr>

			<tr>
				<td>Initial Price: <input type="number" name="initial_price"
					min="0" value="0" step=".01" required></td>
			</tr>

			<!-- should be hidden -->
			<tr>
				<td>Min. Sale Price (will be hidden!): <input type="number"
					name="min_sale" min="0.01" value="0" step=".01" required></td>
			</tr>

			<tr>
				<td>Closing Date/Time: <input type="datetime-local"
					name="date_time" required></td>
			</tr>

			<tr>
				<td><input type="submit" value="Create" /></td>
			</tr>

			<tr>
				<td><a href="Listings.jsp">Go Back</a></td>
			</tr>
			<tr>
				<td><a href="logout.jsp">Log Out</a></td>
			</tr>

		</table>
	</form>
</div>

