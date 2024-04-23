<%@ page import="java.io.*,java.util.*,java.sql.*" 
import="com.cs336.pkg.*"
%>

<%
    try {
        //Database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
       
        // Retrieve the username from the session
        String username = (String) session.getAttribute("username");
        
        out.println("username = " + username);
        
        // SQL query using a placeholder for the username
        String deleteSQL = "DELETE FROM users WHERE username = ?";
        
        // Create a PreparedStatement
        PreparedStatement ps = con.prepareStatement(deleteSQL);
        
        // Set the username parameter
        ps.setString(1, username);
        
        // Execute the update
        int rowsAffected = ps.executeUpdate();
        
        // Optionally check rowsAffected to confirm deletion
        if (rowsAffected > 0) {
            response.sendRedirect("login.jsp");
        } else {
            out.print("No user found with the specified username.");
        }
        
        // Close the PreparedStatement and Connection
        ps.close();
        con.close();
    } catch (Exception ex) {
        out.print("Deletion failed: " + ex.getMessage());
    }
%>
 
