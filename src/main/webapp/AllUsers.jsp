<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.math.BigDecimal, com.cs336.pkg.*" %>
<h2>All Users</h2>
		<div><a href="CustomerRepHome.jsp">Go Back</a></div>
        <table align="center" border="1">
            <tr>
                <th>Username</th>
                <th>Password</th>
                
            </tr>
            <%
	            
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                
                try {
                    ApplicationDB db = new ApplicationDB();
                    con = db.getConnection();
                    String query = "SELECT username, password FROM users";
                    ps = con.prepareStatement(query);
                    rs = ps.executeQuery();
                    while (rs.next()) {
            %>
                        <tr>
                            <td><%= rs.getString("username") %></td>
                            <td><%= rs.getString("password") %></td>                          
                            <td>
		                        <form action="edit_deleteUser.jsp" method="post">
		                            <input type="hidden" name="username" value="<%= rs.getString("username") %>" />
		                            <input type="submit" value="Edit/Delete" />
		                        </form>
                   			</td>
                        </tr>
                        <%
                    }
                } catch (SQLException e) {
                    out.println("Error retrieving users: " + e.getMessage());
                }
            %>
        </table>