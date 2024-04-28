<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update User</title>
</head>
<body>
    <%
        String originalUsername = request.getParameter("originalUsername");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        ApplicationDB db = new ApplicationDB();
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = db.getConnection();

          
            String sql = "UPDATE users SET username = ?, password = ? WHERE username = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, originalUsername);
            int result = ps.executeUpdate();

            if(result > 0) {
                out.println("<p>User updated successfully.</p>");
            } else {
                out.println("<p>Failed to update user. User may not exist.</p>");
            }
        } catch (SQLException e) {
            out.println("<p>Error updating user: " + e.getMessage() + "</p>");
        } finally {
           ps.close();
           con.close();
        }

        out.println("<a href='AllUsers.jsp'>Back to Users List</a>");
    %>
</body>
</html>