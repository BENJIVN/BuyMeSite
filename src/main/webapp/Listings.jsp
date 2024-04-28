<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <%@ page import="java.io.*,java.util.*,java.sql.*" 
import="com.cs336.pkg.*"
%> --%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.math.BigDecimal, com.cs336.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Listings</title>
</head>
<body>
	<div style="text-align: center">
   	<h1>CARS</h1>
   	<table align="center">
   		<tr>  
   			<td><a href="Q&Ahome.jsp">Q&A Board</a></td>
   			<td>~</td>
   			<td><a href="Home.jsp">Home</a></td>
       		<td>~</td>
			<td><a href="Account.jsp">Account</a></td>
			<td>~</td>
			<td><a href="logout.jsp">Logout</a></td>
  			</tr>
   	</table>
    
   	</div>
    	
	 <div style="text-align: center">
        <h2>Create a Listing!</h2>
        <table align="center">
            <tr>
                <td><a href="createListings.jsp">Go to create...</a></td>
            </tr>
        </table>
        
	   	 <div style="text-align: center">
		   	<form action="" method="get">
		        <label for="sortby">Sort by:</label>
		        <select name="sortby" onchange="this.form.submit()">
		            <option value="make">Make</option>
		            <option value="model">Model</option>
		            <option value="color">Color</option>
		            <option value="year">Year</option>
		            <option value="initial_price">Initial Price</option>
		            <option value="date_time">Closing Date/Time</option>
		        </select>
		   	</form>
		</div>
         <h2>All Listings</h2>
        <table align="center" border="1">
            <tr>
                <th>Make</th>
                <th>Model</th>
                <th>Color</th>
                <th>Year</th>
                <th>Price</th>
                <th>Closing Date/Time</th>
                <th>Open/Closed Status</th>
            </tr>
            <%
            	String sort = request.getParameter("sortby");
	            List<String> validSortFields = Arrays.asList("make", "model", "color", "year", "initial_price", "min_sale", "date_time");
	            String sortByField = "make"; //maybe we change this default for now 
	            
	            if(sort != null && validSortFields.contains(sort)){
	            	sortByField = sort;
	            } //order by based on validSortFields
	            
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                
                try {
                    ApplicationDB db = new ApplicationDB();
                    con = db.getConnection();
                    String query = "SELECT listing_id, make, model, color, year, initial_price, min_sale, date_time, open_close FROM listings ORDER BY " + sortByField;
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
                            <%-- <td><%= minSale != null ? minSale.toPlainString() : "N/A" %></td> --%>
                            <td><%= rs.getTimestamp("date_time") != null ? rs.getTimestamp("date_time").toString() : "N/A" %></td>
                            <td><%= rs.getInt("open_close") == 0 ? "Open" : "Closed" %></td>
                            <td>
		                        <form action="viewListing.jsp" method="post">
		                            <input type="hidden" name="listing_id" value="<%= rs.getInt("listing_id") %>" />
		                            <input type="submit" value="Details" />
		                        </form>
                   			</td>
                        </tr>
                        <%
                    }
                } catch (SQLException e) {
                    out.println("Error retrieving listings: " + e.getMessage());
                } finally{
                	rs.close();
                	ps.close();
                	con.close();
                }
            %>
        </table>
    </div>
</body>
</html>

