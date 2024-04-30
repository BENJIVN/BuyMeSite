<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Delete User</title>
</head>
<body>
	<%
	ApplicationDB db = new ApplicationDB();
	Connection con = null;
	PreparedStatement ps = null;

	try {
		con = db.getConnection();

		String username = request.getParameter("username");
		if (username == null || username.trim().isEmpty()) {
			return;
		}

		String sql = "DELETE FROM users WHERE username = ?";
		ps = con.prepareStatement(sql);
		ps.setString(1, username);
		int count = ps.executeUpdate();

		if (count > 0) {
			session.setAttribute("message", "User deleted successfully.");
		} else {
			session.setAttribute("message", "User not found or could not be deleted.");
		}

	} catch (SQLException e) {
		session.setAttribute("message", "Error processing request: " + e.getMessage());
	} finally {
		ps.close();
		con.close();
	}
	response.sendRedirect("AllUsers.jsp");
	%>
</body>
</html>