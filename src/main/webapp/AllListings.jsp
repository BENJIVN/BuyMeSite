<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.math.BigDecimal, com.cs336.pkg.*" %>
<h2>All Listings</h2>
		<div><a href="CustomerRepHome.jsp">Go Back</a></div>
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
            </tr>
            <%
	            
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                
                try {
                    ApplicationDB db = new ApplicationDB();
                    con = db.getConnection();
                    String query = "SELECT listing_id, make, model, color, year, initial_price, min_sale, date_time, open_close FROM listings";
                    ps = con.prepareStatement(query);
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
		                        <form action="deleteListing.jsp" method="post">
		                            <input type="hidden" name="listing_id" value="<%= rs.getInt("listing_id") %>" />
		                            <input type="submit" value="Delete" />
		                        </form>
                   			</td>
                        </tr>
                        <%
                    }
                } catch (SQLException e) {
                    out.println("Error retrieving listings: " + e.getMessage());
                }
            %>
        </table>