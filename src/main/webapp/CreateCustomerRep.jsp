<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ page import="java.io.*,java.util.*,java.sql.*" 
import="com.cs336.pkg.*"
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create Customer Rep</title>
</head>
<body>
	<%
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		String username = request.getParameter("repusername");
		String password = request.getParameter("reppassword");
		
		String insert = "INSERT INTO customer_rep VALUES(?, ?)";
		PreparedStatement ps = con.prepareStatement(insert);
		ps.setString(1, username);
		ps.setString(2, password);
		ps.executeUpdate();
		
		insert = "INSERT INTO admin_rep VALUES('admin', ?)";
		ps = con.prepareStatement(insert);
		ps.setString(1, username);
		ps.executeUpdate();
		
		response.sendRedirect("login.jsp");
		
		stmt.close();
		ps.close();
		con.close();
	%>
<%-- <jsp:forward page="login.jsp"> --%>
</body>
</html>