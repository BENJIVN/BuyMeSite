<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.*" import="java.io.*,java.util.*,java.sql.*, java.math.BigDecimal" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> BUYME- HOME </title>
</head>
<body>
<div class="header">
	<% 
    	//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		String username = (String) session.getAttribute("username");
    %>

    <% if ((session.getAttribute("username") == null)) { %>
        <p class="login-message">You are not logged in<br/></p>
        <a href="login.jsp">Please Login</a>
    <% } else { %>
    	<h1 style="text-align: center">WELCOME <%= username%> </h1>
         <h2 style="text-align: center">DASHBOARD</h2>
        <table style="margin: 0px auto;">
        <tr>
            <td><a href="Listings.jsp">Cars</a></td>
        </tr>
        </table>
       
        <br><br>
        <table align="center">
            <tr>
                <td><a href="Q&Ahome.jsp">Question Board</a>
                <td>|</td>
                <td><a href="Account.jsp">Account</a></td>
                <td>|</td>
                <td><a href="logout.jsp">Logout</a></td>
               </tr>
        </table>
        <br>
        <br>
        
        <% 
    	//table that shows which listings the user no longer has the highest bid in
    	PreparedStatement ps = con.prepareStatement(
    			"SELECT l.listing_id, l.initial_price, " +
    		    "(SELECT MAX(b.price) FROM bids b INNER JOIN bidsOn bo ON b.bid_id = bo.bid_id WHERE bo.listing_id = l.listing_id) AS highest_bid, " +
    		    "(SELECT b.price FROM bids b INNER JOIN places p ON b.bid_id = p.bid_id WHERE p.username = ? AND bo.listing_id = l.listing_id ORDER BY b.bid_dt DESC LIMIT 1) AS user_max_bid " +
    		"FROM listings l " +
    		"INNER JOIN bidsOn bo ON l.listing_id = bo.listing_id " +
    		"INNER JOIN places p ON p.username = ? " +
    		"WHERE l.open_close = 0 AND p.username = ? " +
    		"GROUP BY l.listing_id " +
    		"HAVING user_max_bid < highest_bid");

        ps.setString(1, username); // For the first subquery
        ps.setString(2, username); // For the join on places
        ps.setString(3, username); // In the WHERE clause
   		ResultSet bidsLost = ps.executeQuery();
    		
    		//table that shows which automatic bids are no longer valid
  		ps = con.prepareStatement(
  				"SELECT l.listing_id, l.initial_price, MAX(b.price) AS highest_bid, ab.upper_limit " +
  					    "FROM auto_bids ab " +
  					    "INNER JOIN listings l ON ab.listing_id = l.listing_id " +
  					    "INNER JOIN bidsOn bo ON bo.listing_id = l.listing_id " +
  					    "INNER JOIN bids b ON b.bid_id = bo.bid_id " +
  					    "WHERE ab.username = ? AND l.open_close = 0 " +
  					    "GROUP BY l.listing_id, l.initial_price, ab.upper_limit " +
  					    "HAVING MAX(b.price) > ab.upper_limit");
    	ps.setString(1, username);
    	ResultSet autoBidsLost = ps.executeQuery();	
    		
    		//table that shows a user's won auctions
    	ps = con.prepareStatement(
    			"SELECT l.listing_id, l.initial_price, b.price AS winning_bid " +
    					"FROM listings l " +
    					"INNER JOIN bidsOn bo ON l.listing_id = bo.listing_id " +
    					"INNER JOIN bids b ON bo.bid_id = b.bid_id " +
    					"INNER JOIN places p ON p.bid_id = b.bid_id " +
    					"WHERE l.open_close = 1 AND b.price = ( " +
    					    "SELECT MAX(b2.price) " +
    					    "FROM bids b2 " +
    					    "INNER JOIN bidsOn bo2 ON b2.bid_id = bo2.bid_id " +
    					    "WHERE bo2.listing_id = l.listing_id " +
    					") AND p.username = (?) " +
    					"GROUP BY l.listing_id, l.initial_price, b.price");
    	ps.setString(1, username);
    	ResultSet auctionsWon = ps.executeQuery();
    		
    		//table that shows listings of a user's interests up for auction
    	ps = con.prepareStatement(
    			"SELECT l.listing_id, l.make, l.model " +
    			"FROM listings l " +
    			"INNER JOIN interests i ON l.listing_id = i.listing_id " +
    			"WHERE i.username = (?) AND l.open_close = 0");
        ps.setString(1, username);
        ResultSet interests = ps.executeQuery();
      %>

    	<table align="center" border="1">
    		<tr><td><b>Alerts</b></td></tr>
   			<% while(bidsLost.next()) { %>
            	<tr>
            		<td>
            			<span style="color:red">Alert! </span>Your bid on '<%= bidsLost.getString(1) %>' is no longer the highest bid!
            			<%-- <p>Your bid: $<%= lostBids.getString(1) %><br>Max bid: $<%= lostBids.getString(2) %></p> --%>
            		</td>
           	</tr>
            <% } %>
            <% while(autoBidsLost.next()) { %>
            	<tr>
            		<td>
            			<span style="color:red">Alert! </span>Your auto bid limit on '<%= autoBidsLost.getString(1) %>' is below the current bid price.
            			<span style="color:red">Alert! </span>Your auto bid upper limit on '<%= autoBidsLost.getString(1) %>' has been reached.
            			<%-- <p>Your limit: $<%= autoBidsLost.getString(3) %><br>Max bid: $<%= autoBidsLost.getString(2) %></p> --%>
            		</td>
           	</tr>
            <% } %>
            <% while(auctionsWon.next()) { %>
            	<tr>
            		<td>
            			<span style="color:green">You won the auction!</span> '<%=auctionsWon.getString(1)%>'
            				with your bid of $<%=auctionsWon.getString(2)%>
            		</td>
           		</tr>
            <% } %>
            <% while(interests.next()) { %>
            	<tr>
            		<td>
            			<span style="color:blue">Availability Alert! </span>Your interest '<%=interests.getString(1)%>' is up for auction!
            		</td>
           	</tr>
            <% } %>
    	</table>
        
        
    <% } %>
</div>

</body>
</html>