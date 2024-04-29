<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Account Manager</title>
</head>
<body>
    <div style="text-align: center">
        <h1>Account Manager</h1>
        
        <h2>Return to Homepage</h2>
        <table align="center">
            <tr>
                <td><a href="Home.jsp">Home</a></td>
            </tr>
        </table>
        
        <h2>Bids</h2>
        <table align="center">
            <tr>
                <td><a href="UserBids.jsp">View Your Bids</a></td>
            </tr>
        </table>
        
        <h2>Listings/Auction</h2>
         <table align="center">
            <tr>
                <td><a href="UserListings.jsp">View Your Listings</a></td>
            </tr>
        </table>
        
        <h2>Your Interests</h2>
        <table align="center">
            <tr>
                <td><a href="Interests.jsp">View Your Interests</a></td>
            </tr>
        </table>

		<h2>Delete Account</h2>
       	<form action = "deleteAccount.jsp" method = "POST">
       		<td><input type ="submit" value = "Delete Account"/><td>
       	</form>
        <a href="logout.jsp">Logout</a>
    </div>
</body>
</html>
