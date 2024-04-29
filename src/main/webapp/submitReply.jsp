<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*" %>
<%
    Connection con = null;
    PreparedStatement ps = null;

    String qa_id = request.getParameter("qa_id");
    String answer = request.getParameter("answer");

    try {
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();
    	
        //set to complete now 
        String updateQuery = "UPDATE qa SET answer = ?, status = 'complete' WHERE qa_id = ?";
        ps = con.prepareStatement(updateQuery);
        ps.setString(1, answer);
        ps.setString(2, qa_id);
        
        int result = ps.executeUpdate();
        if (result > 0) {
            response.sendRedirect("Q&ACRHome.jsp"); 
        } else {
            
        }
    } catch (SQLException e) {
        e.printStackTrace();

    } finally {
        ps.close();
        con.close();
    }
  %>