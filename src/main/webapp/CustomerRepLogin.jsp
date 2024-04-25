<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Representative Login</title>
</head>
<body>
<h2 style="text-align: center">Input customer representative login details:</h2>
<form action="CheckCustomerRepLogin.jsp" method="POST">
			<table style="margin: 0px auto;">
			<tr>
				<td> USERNAME: <input type="text" name="username" style="width: 70%;"/></td>
			</tr>
			
			<tr>
				<td>PASSWORD: <input type="password" name="password" style="width: 71%;"/></td>
			</tr>
		
			<tr>
				<td><input type="submit" value="Log In" style="width: 95%;"/><td> 
			</tr>
			
			</table>
		</form>
</body>
</html>