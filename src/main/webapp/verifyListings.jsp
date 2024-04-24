<%@ page import="java.io.*,java.util.*,java.sql.*" 
import="com.cs336.pkg.*"
%>

<%
	//Database connection
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	
	//Statement stmt = con.createStatement();
	
	//seller name
	String username = (String) session.getAttribute("username"); 
	if (username == null) {
		response.sendRedirect("login.jsp");
		return; //stops if user is not logged in 
	}
	
	
	/* /* 1. make, 2. model, 3. color, 4. year, 5. initial price, 
	6. min. sale price, 7. closing date/time */
	
	String make = request.getParameter("make");
	String model = request.getParameter("model");
	String color = request.getParameter("color");
	String year = request.getParameter("year");
	String initialPrice = request.getParameter("initial_price");
	String minSalePrice = request.getParameter("min_sale");
	String closingDateTime = request.getParameter("date_time");
	
	String insert = "INSERT INTO listings(make, model, color, year,initial_price, min_sale, date_time)" 
	+ "VALUES(?, ?, ?, ?, ?, ?, ?)";
	
	PreparedStatement ps = con.prepareStatement(insert);
	ps.setString(1, make);
	ps.setString(2, model);
	ps.setString(3, color);
	ps.setString(4, year);
	ps.setString(5, initialPrice);
	ps.setString(6, minSalePrice);
	ps.setString(7, closingDateTime);
	ps.executeUpdate();
	
	response.sendRedirect("Listings.jsp");
	//insert into listings posts??
	
	//stmt.close();
	ps.close();
	con.close();
%>