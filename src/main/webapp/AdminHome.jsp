<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Administrative Home</title>
</head>
<body>
<div class="header">
    <% if ((session.getAttribute("user") == null)) { %>
        <p class="login-message">You are not logged in<br/></p>
        <a href="AdminHome.jsp">Please Login</a>
    <% } else { %>
         <h2 style="text-align: center">DASHBOARD</h2>
        <table style="margin: 0px auto;">
        
        </table>
       
        <br><br>
        
        <table align="center">
            <tr>
                <td><a href="CreateSalesReport.jsp">Create Sales Report</a>
                <td>
               </tr>
        </table>
    <% } %>
</div>
</body>
</html>