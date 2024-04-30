<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*"%>
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
				<td><a href="CustomerRepHome.jsp">Home</a></td>
				<td>~</td>
				<td><a href="logout.jsp">Logout</a></td>
			</tr>
		</table>

	</div>

	<div style="text-align: center">
		<div style="text-align: center">
			<form action="" method="get">
				<label for="sortby">Sort by:</label> <select name="sortby"
					onchange="this.form.submit()">
					<option value="pending">Pending</option>
					<option value="in_progress">In-Progress</option>
					<option value="complete">Complete</option>
				</select>
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
			String sort = request.getParameter("sortby");
			List<String> validSortFields = Arrays.asList("all", "pending", "in_progress", "complete");
			String sortByField = "all"; //default sort field

			if (sort != null && validSortFields.contains(sort)) {
				sortByField = sort;
			}

			Connection con = null;
			PreparedStatement ps = null;
			ResultSet rs = null;

			try {
				ApplicationDB db = new ApplicationDB();
				con = db.getConnection();
				String query = "SELECT qa.qa_id, u.username, qa.status, qa.question, qa.answer FROM qa INNER JOIN users u ON qa.username = u.username";
				if (!"all".equals(sortByField)) {
					query += " WHERE qa.status = ?";
				}
				query += " ORDER BY qa.qa_id";
				ps = con.prepareStatement(query);
				if (!"all".equals(sortByField)) {
					ps.setString(1, sortByField);
				}
				rs = ps.executeQuery();
				while (rs.next()) {
			%>
			<tr>
				<td><%=rs.getInt("qa_id")%></td>
				<td><%=rs.getString("username")%></td>
				<td><%=rs.getString("status")%></td>
				<td><%=rs.getString("question")%></td>
				<td><%=rs.getString("answer") != null ? rs.getString("answer") : "N/A"%></td>
				<td>
					<%
					if ("pending".equals(rs.getString("status"))) {
					%> <a
					href='replyQuestion.jsp?qa_id=<%=rs.getInt("qa_id")%>'>Reply</a>
					<%
					} else {
					%> N/A <%
					}
					%>
				</td>
			</tr>
			<%
			}
			} catch (SQLException e) {
			e.printStackTrace();
			} finally {
			if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			}
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
			%>
		</table>
	</div>
</body>
</html>