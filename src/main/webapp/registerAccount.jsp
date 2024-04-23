<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*" 
import="com.cs336.pkg.*"
%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Account Registration</title>
</head>
<body>
	

<%

//Database connection
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	
	//Create the sql statement 
	
	Statement stmt = con.createStatement();

String username = request.getParameter("username");
String password = request.getParameter("password");
String insert = "INSERT INTO users(username, password)" + "VALUES(?, ?)";

PreparedStatement ps = con.prepareStatement(insert);
ps.setString(1, username);
ps.setString(2, password);
ps.executeUpdate();

%>

<jsp:forward page="login.jsp">
<jsp:param name="registerRet" value="Account successfully created."/> 
</jsp:forward>


</body>
</html>