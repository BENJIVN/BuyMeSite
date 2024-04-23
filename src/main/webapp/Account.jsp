<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Profile</title>
</head>
<body>
    <div style="text-align: center">
        <h1>Account Options</h1>
       <!--  <button onclick="confirmDeletion()">Delete Account</button> -->
       	<form action = "deleteAccount.jsp" method = "POST">
       	<table>
       		<td><input type ="submit" value = "Delete Account"/><td>
       	</table>
       	</form>
        <a href="logout.jsp">Logout</a>
    </div>
</body>
</html>
