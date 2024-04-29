<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.math.BigDecimal, com.cs336.pkg.*" %>
<h2>My Listings</h2>
        <div><a href="Account.jsp">Go Back</a></div>
        <table align="center" border="1">
            <tr>
                <th>Make</th>
                <th>Model</th>
                <th>Color</th>
                <th>Year</th>
                <th>Initial Price</th>
                <th>Min Sale Price</th>
                <th>Closing Date/Time</th>
                <th>Open/Closed Status</th>
                <th>Actions</th>
            </tr>
            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                
                try {
                    ApplicationDB db = new ApplicationDB();
                    con = db.getConnection();
                    String username = (String) session.getAttribute("username"); // Retrieve the username from the session
                    if (username == null) {
                        out.println("<p>You are not logged in.</p>");
                    } else {
                    	String query = "SELECT l.listing_id, l.make, l.model, l.color, l.year, l.initial_price, l.min_sale, l.date_time, l.open_close " +
                                "FROM listings l INNER JOIN posts p ON l.listing_id = p.listing_id " +
                                "WHERE p.username = ?";
                        ps = con.prepareStatement(query);
                        ps.setString(1, username); // Set the username parameter in the SQL query
                        rs = ps.executeQuery();
                        while (rs.next()) {
                            BigDecimal initialPrice = rs.getBigDecimal("initial_price");
                            BigDecimal minSale = rs.getBigDecimal("min_sale");
            %>
                            <tr>
                                <td><%= rs.getString("make") %></td>
                                <td><%= rs.getString("model") %></td>
                                <td><%= rs.getString("color") %></td>
                                <td><%= rs.getInt("year") %></td>
                                <td><%= initialPrice != null ? initialPrice.toPlainString() : "N/A" %></td>
                                <td><%= minSale != null ? minSale.toPlainString() : "N/A" %></td>
                                <td><%= rs.getTimestamp("date_time") != null ? rs.getTimestamp("date_time").toString() : "N/A" %></td>
                                <td><%= rs.getInt("open_close") == 0 ? "Open" : "Closed" %></td>
                                <td>
                                    <form action="deleteUserListing.jsp" method="post">
                                        <input type="hidden" name="listing_id" value="<%= rs.getInt("listing_id") %>" />
                                        <input type="submit" value="Delete" />
                                    </form>
                                </td>
                            </tr>
                            <%
                        }
                    }
                } catch (SQLException e) {
                    out.println("Error retrieving listings: " + e.getMessage());
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (ps != null) try { ps.close(); } catch (SQLException e) {}
                    if (con != null) try { con.close(); } catch (SQLException e) {}
                }
            %>
        </table>
