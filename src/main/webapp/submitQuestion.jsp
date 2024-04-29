<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*" %>
<%
    String username = request.getParameter("username");
    String question = request.getParameter("question");
    Connection con = null;
    PreparedStatement ps = null;
    
    try {
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();
        String query = "INSERT INTO questions (username, status, question) VALUES (?, 'pending', ?)";
        ps = con.prepareStatement(query);
        ps.setString(1, username);
        ps.setString(2, question);
        ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (ps != null) { try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }}
        if (con != null) { try { con.close(); } catch (SQLException e) { e.printStackTrace(); }}
    }
    response.sendRedirect("Q&Ahome.jsp");
%>
