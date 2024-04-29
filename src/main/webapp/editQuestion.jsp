<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*" %>
<%
    int question_id = Integer.parseInt(request.getParameter("question_id"));
    String question = null;
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();
        String query = "SELECT question FROM questions WHERE question_id = ?";
        ps = con.prepareStatement(query);
        ps.setInt(1, question_id);
        rs = ps.executeQuery();
        if (rs.next()) {
            question = rs.getString("question");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) { try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }}
        if (ps != null) { try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }}
        if (con != null) { try { con.close(); } catch (SQLException e) { e.printStackTrace(); }}
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Question</title>
</head>
<body>
	<div style="text-align: center">
   	<h1>Edit Question</h1>
   	<table align="center">
   		<tr>  
   			<td><a href="Listings.jsp">Listings</a></td>
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
        <h2>Edit Your Question</h2>
        <form action="updateQuestion.jsp" method="post">
            <table align="center">
                <tr>
                    <td>Question:</td>
                    <td><input type="text" name="question" value="<%= question %>" required></td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center">
                        <input type="hidden" name="question_id" value="<%= question_id %>">
                        <input type="submit" value="Update Question">
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
