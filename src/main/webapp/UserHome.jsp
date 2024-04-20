<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> BUYME- HOME </title>
</head>
<body>
<div class="header">
    <% if ((session.getAttribute("user") == null)) { %>
        <p class="login-message">You are not logged in<br/></p>
        <a href="login.jsp">Please Login</a>
    <% } else { %>
    	 <h2 style="text-align: center">HOME: Cars</h2>
    	<table style="margin: 0px auto;">
		<tr>
			<td><a href="Listings.jsp">Car Listings</a></td>
		</tr>
		</table>
       
        <br><br>
        <table align="center">
    		<tr>
    			<td><a href="QuestionBoard.jsp">Question Board</a>
    			<td>|</td>
				<td><a href="Account.jsp">Account</a></td>
				<td>|</td>
				<td><a href="logout.jsp">Logout</a></td>
   			</tr>
    	</table>
    <% } %>
</div>
</body>
</html>