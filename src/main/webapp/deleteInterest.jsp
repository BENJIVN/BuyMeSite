<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"
	import="com.cs336.pkg.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete Interest</title>
</head>
<body>

	<%
	// Database connection
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	PreparedStatement ps = null;

	try {
		String username = (String) session.getAttribute("username");
		if (username == null) {
			response.sendRedirect("login.jsp");
			return; // Stop further execution if not logged in
		}

		String listingId = request.getParameter("listing_id");
		if (listingId != null && !listingId.isEmpty()) {
			// Prepare the delete statement
			String delete = "DELETE FROM interests WHERE username = ? AND listing_id = ?";
			ps = con.prepareStatement(delete);
			ps.setString(1, username);
			ps.setString(2, listingId);
			ps.executeUpdate();
		}

		response.sendRedirect("Interests.jsp");
	} catch (SQLException e) {
		out.println("SQL Error");
	} finally {
		ps.close();
		con.close();
	}
	%>

</body>
</html>
