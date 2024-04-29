<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create Question</title>
</head>
<body>
	<div style="text-align: center">
   	<h1>Create a Question</h1>
   	<table align="center">
   		<tr>  
   			<td><a href="Listings.jsp">Listings</a></td>
   			<td>~</td>
   			<td><a href="Home.jsp">Home</a></td>
       		<td>~</td>
			<td><a href="Account.jsp">Account</a></td>
			<td>~</td>
			<td><a href="logout.jsp">Logout</a></td>
  			</tr>
   	</table>
    
   	</div>
    	
	 <div style="text-align: center">
        <h2>Enter Your Question</h2>
        <form action="submitQuestion.jsp" method="post">
            <table align="center">
                <tr>
                    <td>Question:</td>
                    <td><input type="text" name="question" required></td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center">
                        <input type="hidden" name="username" value="<%= session.getAttribute("username") != null ? session.getAttribute("username").toString() : "" %>">
                        <input type="submit" value="Submit Question">
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>