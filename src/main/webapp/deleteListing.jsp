<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Listing</title>
</head>
<body>
    <%
        ApplicationDB db = new ApplicationDB();
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = db.getConnection();

            int listingId = Integer.parseInt(request.getParameter("listing_id"));

            String sql = "DELETE FROM listings WHERE listing_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, listingId);
            int count = ps.executeUpdate();

            if(count > 0) {
                out.println("<p>Listing deleted successfully.</p>");
            } else {
                out.println("<p>Error: Listing not found or could not be deleted.</p>");
            }

        } catch (SQLException e) {
            out.println("<p>Error processing request: " + e.getMessage() + "</p>");
        } finally {
            ps.close();
            con.close();
        }

        
        out.println("<a href='AllListings.jsp'>Back to Listings</a>");
    %>
</body>
</html>
