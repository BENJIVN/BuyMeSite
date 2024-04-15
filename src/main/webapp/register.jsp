<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Account Creation</title>
</head>
<body>
	<h2 style="text-align: center"> Create a new account: </h2>
	<form action="registerAccount.jsp" method="POST">
			<table style="margin: 0px auto;">
		
			<tr>
				<td> USERNAME: <input type="text" name="username" style="width: 70%;"/></td>
			</tr>
			
			<tr>
				<td>PASSWORD: <input type="password" name="password" style="width: 71%;"/></td>
			</tr>
		
			<tr>
				<td><input type="submit" value="Create Account" style="width: 95%;"/><td> <!-- Let's make this longer if possible -->
			</tr>
			
			<tr>
				<td> Already have an account? <a href="login.jsp">Sign in!</a></td>
			</tr>
			
			<% if (request.getParameter("msg") != null) { %>
			<tr>
				<td><%=request.getParameter("msg")%></td>
			</tr>
			<% } %>
		
			</table>
		</form>
</body>
</html>