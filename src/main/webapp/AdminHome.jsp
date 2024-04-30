<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"
	import="com.cs336.pkg.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Home</title>
</head>
<body>
	<%
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	Statement stmt = con.createStatement();
	ResultSet resultset = stmt.executeQuery("SELECT rep_username, rep_password FROM customer_rep");
	%>

	<h1>Welcome to the admin homepage!</h1>

	<h1>Current Customer Representatives</h1>
	<table>
		<%
		if (!resultset.next()) {
		%>
		<tr>
			<td>No Customer Reps found!</td>
		</tr>
		<%
		} else {
		// Need to reset after the previous if check
		resultset.beforeFirst();
		while (resultset.next()) {
		%>
		<tr>
			<th>Customer Rep Username:</th>
			<td><%=resultset.getString(1)%></td>
			<th>Customer Rep Password:</th>
			<td><%=resultset.getString(2)%></td>
		</tr>
		<tr style="height: 20px;">
			<td colspan="4"></td>
		</tr>
		<%
		}
		}
		%>
	</table>

	<h1>Add a Customer Representative</h1>
	<form method="post" action="CreateCustomerRep.jsp">
		<table>
			<tr>
				<td>New Customer Rep Username: <input type="text"
					name="repusername" value="" maxlength="30" required /></td>
			</tr>
			<tr>
				<td>New Customer Rep Password: <input type="text"
					name="reppassword" value="" maxlength="30" required /></td>
			</tr>
			<tr>
				<td><input type="submit" value="Create Rep Login"
					style="width: 100%;" /></td>
			</tr>
		</table>
	</form>

	<h1>Create Sales Report</h1>
	<form action="CreateSalesReport.jsp">
		<table>
			<tr>
				<th>Start Date</th>
				<td><input type="datetime-local" required name="startdate"></td>
			</tr>
			<tr>
				<th>End Date</th>
				<td><input type="datetime-local" required name="enddate"></td>
			</tr>
		</table>

		<input type="submit" value="Generate">
	</form>

	<br>
	<br>

	<div>
		<a href="logout.jsp">Logout</a>
	</div>


	<%-- <div class="header">
    <% if ((session.getAttribute("username") == null)) { %>
        <p class="login-message">You are not logged in<br/></p>
        <a href="AdminHome.jsp">Please Login</a>
    <% } else { %>
         <h2 style="text-align: center">DASHBOARD</h2>
        <table style="margin: 0px auto;">
        
        </table>
       
        <br><br>
        
        <table align="center">
            <tr>
                <td><a href="CreateSalesReport.jsp">Create Sales Report</a>
                <td>
              </tr>
        </table>
    <% } %>
</div> --%>
</body>
</html>