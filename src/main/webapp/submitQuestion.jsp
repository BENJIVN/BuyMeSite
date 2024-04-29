<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*" %>
<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        ApplicationDB db = new ApplicationDB();
        String username = request.getParameter("username");
        String question = request.getParameter("question");
        con = db.getConnection();

        // Check for duplicate question
        String checkQuery = "SELECT COUNT(*) FROM qa WHERE question = ?";
        ps = con.prepareStatement(checkQuery);
        ps.setString(1, question);
        rs = ps.executeQuery();
        
        int count = 0;
        if (rs.next()) {
            count = rs.getInt(1);
        }
        
        if (count > 0) {
            session.setAttribute("error", "Duplicate question. Please ask a different question.");
            response.sendRedirect("createQuestion.jsp");
        } else {
          
            String insertQuery = "INSERT INTO qa (username, status, question) VALUES (?, 'pending', ?)";
            ps = con.prepareStatement(insertQuery);
            ps.setString(1, username);
            ps.setString(2, question);
            int result = ps.executeUpdate();
            if(result > 0){
                response.sendRedirect("Q&Ahome.jsp");
            } else {
      
                session.setAttribute("error", "There was an error submitting your question. Please try again.");
                response.sendRedirect("createQuestion.jsp");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        ps.close();
        rs.close();
        con.close();
    }
  
%>