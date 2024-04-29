<%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*" 
import="com.cs336.pkg.*"
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add/Verify Interests</title>
</head>
<body>
    <%
    // Database connection
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    PreparedStatement ps = null;

    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
    } else {
        try {
            String listingId = request.getParameter("listing_id");

            // Insert the interest into the database
            String sqlInsertInterest = "INSERT INTO interests (username, listing_id) VALUES (?, ?)";
            ps = con.prepareStatement(sqlInsertInterest);
            ps.setString(1, username);
            ps.setString(2, listingId);
            ps.executeUpdate();

            // Redirect to interests page or some confirmation page
            response.sendRedirect("Interests.jsp");

        } catch (SQLException e) {
            out.println("SQL Error: " + e.getMessage());
            // Handle exception: log it, wrap it, or present it
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (con != null) try { con.close(); } catch (SQLException e) { /* ignored */ }
        }
    }
    %>
</body>
</html> --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*" 
import="com.cs336.pkg.*"
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add/Verify Interests</title>
</head>
<body>
    <%
    // Database connection
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;

    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
    } else {
        try {
            String listingId = request.getParameter("listing_id");

            // Check if the interest already exists
            String checkQuery = "SELECT 1 FROM interests WHERE username = ? AND listing_id = ?";
            ps = con.prepareStatement(checkQuery);
            ps.setString(1, username);
            ps.setString(2, listingId);
            rs = ps.executeQuery();

            if (!rs.next()) {
                // Insert the interest into the database only if it doesn't already exist
                String sqlInsertInterest = "INSERT INTO interests (username, listing_id) VALUES (?, ?)";
                ps = con.prepareStatement(sqlInsertInterest);
                ps.setString(1, username);
                ps.setString(2, listingId);
                ps.executeUpdate();
            }

            // Redirect to interests page or some confirmation page
            response.sendRedirect("Interests.jsp");

        } catch (SQLException e) {
            out.println("SQL Error: " + e.getMessage());
            // Handle exception: log it, wrap it, or present it
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (con != null) try { con.close(); } catch (SQLException e) { /* ignored */ }
        }
    }
    %>
</body>
</html>
