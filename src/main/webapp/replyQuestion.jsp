<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*" %>
<%

    String qa_id = request.getParameter("qa_id");
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String question = "";
    String status = "";
    //
    String errorMessage = null;


    try {
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();
        String query = "SELECT question, status FROM qa WHERE qa_id = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, qa_id);
        rs = ps.executeQuery();

        if (rs.next()) {
            question = rs.getString("question");
            status = rs.getString("status");
        } else {
            errorMessage = "Question not found.";
        }
    } catch (SQLException e) {
        errorMessage = "Database error occurred. " + e.getMessage();
        e.printStackTrace();
    } finally {
        rs.close();
        ps.close();
        con.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reply to Question</title>
</head>
<body>
	<!-- A check was needed -->
    <% if (errorMessage != null) { %>
        <p><%= errorMessage %></p>
    <% } else { %>
        <div style="text-align: center">
            <h1>Reply to Question</h1>
            <form action="submitReply.jsp" method="post">
                <table align="center" border="1">
                    <tr>
                        <th>Question ID</th>
                        <th>Question</th>
                        <th>Status</th>
                    </tr>
                    <tr>
                        <td><%= qa_id %></td>
                        <td><%= question %></td>
                        <td><%= status %></td>
                    </tr>
                </table>
                <p>
                    <label for="answer">Answer:</label>
                    <textarea name="answer" id="answer" rows="4" cols="50" required></textarea>
                </p>
                <input type="hidden" name="qa_id" value="<%= qa_id %>">
                <input type="submit" value="Submit Answer">
            </form>
        </div>
    <% } %>
</body>
</html>