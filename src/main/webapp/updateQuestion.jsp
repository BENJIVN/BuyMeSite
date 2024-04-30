<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*"%>
<%
int question_id = Integer.parseInt(request.getParameter("question_id"));
String question = request.getParameter("question");
Connection con = null;
PreparedStatement ps = null;

try {
	ApplicationDB db = new ApplicationDB();
	con = db.getConnection();
	String query = "UPDATE questions SET question = ? WHERE question_id = ?";
	ps = con.prepareStatement(query);
	ps.setString(1, question);
	ps.setInt(2, question_id);
	ps.executeUpdate();
} catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (ps != null) {
		try {
	ps.close();
		} catch (SQLException e) {
	e.printStackTrace();
		}
	}
	if (con != null) {
		try {
	con.close();
		} catch (SQLException e) {
	e.printStackTrace();
		}
	}
}
response.sendRedirect("Q&Ahome.jsp");
%>
