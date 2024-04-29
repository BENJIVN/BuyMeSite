<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*" %>
<%
    String question = request.getParameter("question");
    Connection con = null;
    PreparedStatement ps = null;
    
    try {
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();
        String query = "INSERT INTO questions (status, question) VALUES (?, ?)";
        ps = con.prepareStatement(query);
        ps.setString(1, "pending");
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