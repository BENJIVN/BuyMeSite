<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>BuyMe - LOGIN</title>
</head>
<body>
		<h2 style="text-align: center">Input login details:</h2>
		<form action="checkLoginDetails.jsp" method="POST">
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
			
			<tr>
				<td><a href="AdminLogin.jsp">Click here if you're an Administrator!</a></td>
			</tr>
			<tr>
				<td><a href="CustomerRepLogin.jsp">Click here if you're a Customer Representative!</a></td>
			</tr>
				<td><a href ="register.jsp"> Click here if you need an account!</a></td>
			</tr>
			</table>
		</form>
</body>
</html>



