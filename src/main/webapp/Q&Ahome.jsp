<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q&A Home Page</title>
</head>
<body>
<div class="header">
    <% if ((session.getAttribute("user") == null)) { %>
        <p class="login-message">You are not logged in<br/></p>
        <a href="Q&Ahome.jsp">Please Login</a>
    <% } else { %>
         <h2 style="text-align: center">Questions & Answers</h2>
        <table style="margin: 0px auto;">
        <tr>
            <td><a href="CreateQuestion.jsp">Create Question</a></td>
        </tr>
        </table>
       
        <br><br>
        <table align="center">
            <tr>
                <td><a href="Q&Ahome.jsp">Question Board</a>
                <td>
               </tr>
        </table>
    <% } %>
</div>
</body>
</html>