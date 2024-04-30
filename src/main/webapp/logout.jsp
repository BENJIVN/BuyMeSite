<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.math.BigDecimal"%>

<%
session.invalidate();
//session.getAttribute("user"); //this will throw an error
response.sendRedirect("login.jsp");
%>
