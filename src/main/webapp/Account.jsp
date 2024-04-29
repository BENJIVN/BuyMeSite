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
        
		<h2>Alerts</h2>
			 <table align="center">
            <tr>
                <td><a href="Alerts.jsp">View your alerts</a></td>
            </tr>
        </table>
        
        <h2> View Others Activity</h2>
        <form action="checkUser.jsp" method="POST">
         <table align="center">
            <tr>
				<td> Type in username: <input type="text" name="username" style="width: 70%;"/></td>
			</tr>
	
			<tr>
				<td><input type="submit" value="Search" style="width: 95%;"/><td> 
			</tr>
        </table>
        </form>
        
		<h2>Delete Account</h2>
       	<form action = "deleteAccount.jsp" method = "POST">
       		<td><input type ="submit" value = "Delete Account"/><td>
       	</form>
        <a href="logout.jsp">Logout</a>
    </div>
</body>
</html>
