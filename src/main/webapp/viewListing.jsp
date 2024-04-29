<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.cs336.pkg.*" import="java.io.*,java.util.*,java.sql.*, java.math.BigDecimal" %> 
<html>
<head>
<meta charset="UTF-8">
<title>BuyMe: Listing Details</title>
</head>
<body>
	<div><a href="Listings.jsp">Go Back</a></div>
	 <%
        ApplicationDB db = new ApplicationDB();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int listingId = 0; // Initialize listingId
        boolean isListingOpen = true;

        try {
            con = db.getConnection();
            String username = (String) session.getAttribute("username"); 
            if (username == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String listingIdStr = request.getParameter("listing_id");
            if (listingIdStr != null && !listingIdStr.isEmpty()) {
                listingId = Integer.parseInt(listingIdStr); 
                //out.println("<p>listingId = "+ listingId);
            } else {
                out.println("<p>Error: No listing ID provided in view Listing.</p>");
                return;
            }
			
            //grab if the listing is open/closed
            String query = "SELECT *, open_close FROM listings WHERE listing_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, listingId);
            rs = ps.executeQuery();
			
            //if the listing is open (0) then it is true that is open then we continue with the original display
            if (rs.next()){
            	isListingOpen = (rs.getInt("open_close") == 0);
            	if (isListingOpen) {
       	    %>
       	                <h1>Listing Details</h1>
       	                <p>Make: <%= rs.getString("make") %></p>
       	                <p>Model: <%= rs.getString("model") %></p>
       	                <p>Color: <%= rs.getString("color") %></p>
       	                <p>Year: <%= rs.getInt("year") %></p>
       	                <p>Initial Price: <%= rs.getDouble("initial_price") %></p>
       	               <%--  <p>Minimum Sale Price: <%= rs.getDouble("min_sale") %></p> THIS STAYS HIDDEN!--%>
       	                <p>Closing Date/Time: <%= rs.getTimestamp("date_time").toString() %></p>
       	                <p>Status: <%= rs.getInt("open_close") == 0 ? "Open" : "Closed" %></p>
       	    <%
   	            
            	         
            	    %>
            	           
            		<h1>Interested in the listing?</h1>
					<form method="post" action="verifyInterested.jsp">
					    <input type="hidden" name="listing_id" value="<%= listingId %>" />
					    <table>
					        <tr>
					            <td><input type="submit" value="Keep Me Alerted!"/></td>
					        </tr>
					    </table>
					</form>
            			
            			
            		<h1>Bid History</h1>
            			<%
            			    String bidHistoryQuery = "SELECT p.username, b.bid_id, b.price, b.bid_dt FROM listings l JOIN bidsOn bo ON l.listing_id = bo.listing_id JOIN bids b ON bo.bid_id = b.bid_id JOIN places p ON p.bid_id = b.bid_id WHERE l.listing_id = ?";
            			    ps = con.prepareStatement(bidHistoryQuery);
            			    ps.setInt(1, listingId);
            			    rs = ps.executeQuery();
            			
            			    if (!rs.isBeforeFirst()) {
            			        out.println("<p>No bids have been placed for this listing.</p>");
            			    } else {
            			%>
            			        <table>
            			            <tr>
            			                <th>Username</th>
            			                <th>Bid ID</th>
            			                <th>Price</th>
            			                <th>Date/Time</th>
            			            </tr>
            			<%
            			        while (rs.next()) {
            			%>
            			            <tr>
            			                <td><%= rs.getString("username") %></td>
            			                <td><%= rs.getInt("bid_id") %></td>
            			                <td><%= rs.getBigDecimal("price").toPlainString() %></td>
            			                <td><%= rs.getTimestamp("bid_dt").toString() %></td>
            			            </tr>
            			<%
            			        }
            			%>
            			        </table>
            			<%
            			    }
            			%>
            	          
            	   
            		<h1>Make a normal bid!</h1>
            			<%
            				ps = con.prepareStatement("SELECT listing_id FROM listings WHERE listing_id = ?");
            				ps.setInt(1, listingId);
            				rs = ps.executeQuery();
            				if(rs.next()) {
            			%>
            				<form method="post" action="verifyBid.jsp">
            				    <table>
            				        <tr>
            				            <td>Price:</td>
            				            <td><input type="text" name="price" value="0" maxlength="30" required/></td>
            				            <td>
            				                <input type="hidden" name="listing_id" value="<%= rs.getInt("listing_id") %>" />
            				                <input type="submit" value="Place"/>
            				            </td>
            				        </tr>
            				    </table>
            				</form>
            			<% 
            				}
            				
            			%>
            			
            			
            		<h1>Are you lazy? Make an AUTO-bid!</h1>
            			<%
            				ps = con.prepareStatement("SELECT listing_id FROM listings WHERE listing_id = ?");
            				ps.setInt(1, listingId);
            				rs = ps.executeQuery();
            				if(rs.next()) {           					
            			%>
            			
            			<form method="post" action="verifyAutoBid.jsp">
            				<table>
            					<tr>           						
            						<td>Increments: 
            							<input type="text" name="increments" value="0" maxlength="30" required/></td>
            						<td>Upper Limit: 
            							<input type="text" name="upperLimit" value="0" maxlength="30" required/></td>           										
            						<td>
            						<%-- <%
            						out.println("Debug - Current listing ID: " + listingId);
            						%> --%>
	            						<input type="hidden" name="listing_id" value="<%= rs.getInt("listing_id") %>" />
	            						<input type="submit" value="Place"/>
            						</td>
            					</tr>
            				
            				</table>
            			</form>
            		<%
            		} 
            		%>
        <%
        		//handle closed listing scenario
	         } else {
	    %>			
<!-- 	    			<script>alert('Congratulations, you won the auction!');</script>
	    			<script>alert('The auction has closed. Thank you for participating.');</script> -->
	    			<!-- <h1>WINNER OF THE BID!</h1> -->
	    			<h1>STATUS OF LISTING: COMPLETE</h1>
	   	 			<h1>Listing Details</h1>
       	                <p>Make: <%= rs.getString("make") %></p>
       	                <p>Model: <%= rs.getString("model") %></p>
       	                <p>Color: <%= rs.getString("color") %></p>
       	                <p>Year: <%= rs.getInt("year") %></p>
       	                <p>Initial Price: <%= rs.getDouble("initial_price") %></p>
       	                <%-- <p>Minimum Sale Price: <%= rs.getDouble("min_sale") %></p> THIS STAYS HIDDEN!--%>
       	                <p>Closing Date/Time: <%= rs.getTimestamp("date_time").toString() %></p>
       	                <p>Status: <%= rs.getInt("open_close") == 0 ? "Open" : "Closed" %></p>
	   	<%                
	   	            }
	 
	          	
	   	        } else {
	   	        		out.println("<p>Listing not found.</p>");
	   	        } 
	            	            
	        }finally {
	            // Close ResultSet
	            if (rs != null) {
	                try {
	                    rs.close();
	                } catch (SQLException e) {
	                    out.println("<p>Error closing ResultSet: " + e.getMessage() + "</p>");
	                }
	            }
	            // Close PreparedStatement
	            if (ps != null) {
	                try {
	                    ps.close();
	                } catch (SQLException e) {
	                    out.println("<p>Error closing PreparedStatement: " + e.getMessage() + "</p>");
	                }
	            }
	            // Close Connection
	            if (con != null) {
	                try {
	                    con.close();
	                } catch (SQLException e) {
	                    out.println("<p>Error closing Connection: " + e.getMessage() + "</p>");
	                }
	            }
	        }
	   	%>    			
       
</body>
</html>

			