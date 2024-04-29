<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q&A Board</title>
</head>
<body>
	<div style="text-align: center">
   	<h1>Q&A Board</h1>
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
        <h2>Create a Question!</h2>
        <table align="center">
            <tr>
                <td><a href="createQuestion.jsp">Go to create...</a></td>
            </tr>
        </table>
        
	   	 <div style="text-align: center">
		   	<form action="" method="get">
		        <label for="sortby">Sort by:</label>
		        <select name="sortby" onchange="this.form.submit()">
		            <option value="pending">Pending</option>
		            <option value="in_progress">In-Progress</option>
		            <option value="complete">Complete</option>
		        </select>
		   	</form>
		   	
		   	<!--Search here  -->
		   	<form action="" method="get">
	            <label for="search">Search:</label>
	            <input type="text" name="search" id="search" placeholder="Enter keyword">
	            <input type="submit" value="Search">
        	</form>
		   	
		</div>
         <h2>All Questions</h2>
        <table align="center" border="1">
            <tr>
                <th>Question ID</th>
                <th>Username</th>
                <th>Status</th>
                <th>Question</th>
                <th>Answer</th>
            </tr>
            <%	
            	String searchKeyword = request.getParameter("search");
	            String sort = request.getParameter("sortby");
	            List<String> validSortFields = Arrays.asList("all", "pending", "in_progress", "complete");
	            String sortByField = "all"; //default sort field
	            
	            if(sort != null && validSortFields.contains(sort)){
	            	sortByField = sort;
	            }
	            
	            Connection con = null;
	            PreparedStatement ps = null;
	            ResultSet rs = null;
	            
	            try {
	            	 ApplicationDB db = new ApplicationDB();
	                 con = db.getConnection();
	                 String query = "SELECT qa.qa_id, u.username, qa.status, qa.question, qa.answer FROM qa INNER JOIN users u ON qa.username = u.username";
	                 // search condition
	                 if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
	                     query += " WHERE qa.question LIKE ?";
	                     if (!"all".equals(sortByField)) {
	                         query += " AND qa.status = ?";
	                     }
	                 } else if (!"all".equals(sortByField)) {
	                     query += " WHERE qa.status = ?";
	                 }
	                 query += " ORDER BY qa.qa_id";
	                 ps = con.prepareStatement(query);	                 
	                 int paramIndex = 1;
	                 if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
	                     ps.setString(paramIndex++, "%" + searchKeyword.trim() + "%");
	                 }
	                 if (!"all".equals(sortByField)) {
	                     ps.setString(paramIndex, sortByField);
	                 }
	                 rs = ps.executeQuery();
	                while (rs.next()) {
	            %>
                        <tr>
                            <td><%= rs.getInt("qa_id") %></td>
                            <td><%= rs.getString("username") %></td>
                            <td><%= rs.getString("status") %></td>
                            <td><%= rs.getString("question") %></td>
                            <td><%= rs.getString("answer") != null ? rs.getString("answer") : "N/A" %></td>                           
                        </tr>
            <% 
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) { try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }}
                    if (ps != null) { try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }}
                    if (con != null) { try { con.close(); } catch (SQLException e) { e.printStackTrace(); }}
                }
            %>
        </table>
    </div>
</body>
</html>