<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit or Delete User</title>
</head>
<body>
    <%
        String username = request.getParameter("username");
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT username, password FROM users WHERE username = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            
            if(rs.next()) {
    %>
                <h2>Edit User: <%= username %></h2>
                <form action="updateUser.jsp" method="post">
                    <input type="hidden" name="originalUsername" value="<%= username %>" />
                    Username: <input type="text" name="username" value="<%= rs.getString("username") %>" /><br>
                    Password: <input type="password" name="password" value="<%= rs.getString("password") %>" /><br>
                    <input type="submit" value="Update User" />
                </form>
                <form action="deleteUser.jsp" method="post">
                    <input type="hidden" name="username" value="<%= username %>" />
                    <input type="submit" value="Delete User" />
                </form>
    <%
            }
        } catch (SQLException e) {
            out.println("Error accessing user details: " + e.getMessage());
        } finally {
           rs.close();
           ps.close();
           con.close();
        }
    %>
    <a href='AllUsers.jsp'>Back to Users List</a>
</body>
</html>