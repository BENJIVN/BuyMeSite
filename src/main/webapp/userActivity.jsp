<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.math.BigDecimal, com.cs336.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Activity</title>
</head>
<body>
    <h1>User Activity</h1>
    <%
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String searchedUsername = request.getParameter("username");

        try {
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();

            // Check if user exists
            ps = con.prepareStatement("SELECT COUNT(*) AS user_count FROM users WHERE username = ?");
            ps.setString(1, searchedUsername);
            rs = ps.executeQuery();
            rs.next();
            int count = rs.getInt("user_count");
            if (count == 0) {
                out.println("<p>User does not exist.</p>");
            } else {
                // Display Listings
                out.println("<h2>Listings Posted by " + searchedUsername + "</h2>");
                ps = con.prepareStatement("SELECT l.listing_id, l.make, l.model, l.color, l.year, l.initial_price, l.min_sale, l.date_time, l.open_close FROM listings l JOIN posts p ON l.listing_id = p.listing_id WHERE p.username = ?");
                ps.setString(1, searchedUsername);
                rs = ps.executeQuery();
                while (rs.next()) {
                    out.println("<p>" + rs.getString("make") + " " + rs.getString("model") + ", Color: " + rs.getString("color") + ", Year: " + rs.getInt("year") + ", Price: $" + rs.getBigDecimal("initial_price").toPlainString() + "</p>");
                }

                // Display Bids
                out.println("<h2>Bids Placed by " + searchedUsername + "</h2>");
                ps = con.prepareStatement("SELECT b.bid_id, b.price, b.bid_dt FROM bids b JOIN places p ON b.bid_id = p.bid_id WHERE p.username = ?");
                ps.setString(1, searchedUsername);
                rs = ps.executeQuery();
                while (rs.next()) {
                    out.println("<p>Bid ID: " + rs.getInt("bid_id") + ", Price: $" + rs.getBigDecimal("price").toPlainString() + ", Date: " + rs.getTimestamp("bid_dt").toString() + "</p>");
                }
            }
        } catch (SQLException e) {
            out.println("SQL Error: " + e.getMessage());
        } finally {
            rs.close();
            ps.close();
            con.close();
        }
    %>
    <div><a href="Account.jsp">Back to Account Manager</a></div>
</body>
</html>