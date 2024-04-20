<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%> 
  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete Account</title>
</head>
<body>
	<%
	String username = (String) session.getAttribute("username");
	if (username == null) {
	    // Redirect user to login page if username isn't found in session
	    response.sendRedirect("login.jsp");
	    return;
	}
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe","root","336p@sSw0rd");

	String delete = "DELETE FROM users WHERE username = ?";

	PreparedStatement ps = con.prepareStatement(delete);
	ps.setString(1, username);
	int rowsAffected = ps.executeUpdate();

	if (rowsAffected > 0) {
	    request.setAttribute("deleteRet", "Account successfully deleted.");
	} else {
	    request.setAttribute("deleteRet", "No account found with the given username.");
	}

	session.invalidate(); // Invalidate the session after deleting the account
/* 	response.sendRedirect("login.jsp?message=" + URLEncoder.encode(request.getAttribute("deleteRet").toString(), "UTF-8")); */

%>

<jsp:forward page="login.jsp">
<jsp:param name="deleteRet" value="<%= request.getAttribute("deleteRet") %>" />
</jsp:forward>



</body>
</html>