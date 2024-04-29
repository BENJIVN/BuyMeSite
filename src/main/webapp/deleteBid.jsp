<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Bid</title>
</head>
<body>
    <%
        ApplicationDB db = new ApplicationDB();
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = db.getConnection();

            int bidId = 0;
            String bidIdParam = request.getParameter("bid_id");
            if (bidIdParam != null) {
                bidId = Integer.parseInt(bidIdParam);
            }

            String sql = "DELETE FROM bids WHERE bid_id = ?"; // This will cascade to auto_bids
            ps = con.prepareStatement(sql);
            ps.setInt(1, bidId);
            int count = ps.executeUpdate();

            if(count > 0) {
                out.println("<p>Bid deleted successfully.</p>");
            } else {
                out.println("<p>Error: Bid not found or could not be deleted.</p>");
            }

        } catch (NumberFormatException e) {
            out.println("<p>Error: Invalid bid ID.</p>");
        } catch (SQLException e) {
            out.println("<p>Error processing request: " + e.getMessage() + "</p>");
        } finally {
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    out.println("<p>Error closing PreparedStatement: " + e.getMessage() + "</p>");
                }
            }
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    out.println("<p>Error closing Connection: " + e.getMessage() + "</p>");
                }
            }
        }

        
        out.println("<a href='AllBids.jsp'>Back to Bids</a>");
    %>
</body>
</html>