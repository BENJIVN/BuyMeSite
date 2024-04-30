<%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*"%>
<%@ page import="java.sql.Timestamp, java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create Sales Report</title>
</head>
<body>
	<%
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();

	String startDate = request.getParameter("startdate");
	String endDate = request.getParameter("enddate");

	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
	SimpleDateFormat printDate = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss");

	Timestamp date1 = new Timestamp(format.parse(startDate).getTime());
	Timestamp date2 = new Timestamp(format.parse(endDate).getTime());

	// Total Earnings Query
	String totalEarningsQuery = "SELECT SUM(initial_price) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1";
	PreparedStatement psTotalEarnings = con.prepareStatement(totalEarningsQuery);
	psTotalEarnings.setTimestamp(1, date1);
	psTotalEarnings.setTimestamp(2, date2);
	ResultSet rsTotalEarnings = psTotalEarnings.executeQuery();
	String totalEarnings = "0.00";
	if (rsTotalEarnings.next()) {
		totalEarnings = rsTotalEarnings.getString(1);
	}

	// Display Report Header
	%>
	<h1>Sales Report</h1>
	<h2>
		From:
		<%=printDate.format(format.parse(startDate))%></h2>
	<h2>
		To:
		<%=printDate.format(format.parse(endDate))%></h2>
	<h2>
		Total Earnings: $<%=totalEarnings%></h2>

	<%
	// Earnings Per Make, Model, Color, Year
	String earningsPerItemQuery = "SELECT make, model, color, year, SUM(initial_price) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1 GROUP BY make, model, color, year ORDER BY make, model, color, year";
	PreparedStatement psEarningsPerAttribute = con.prepareStatement(earningsPerItemQuery);
	psEarningsPerAttribute.setTimestamp(1, date1);
	psEarningsPerAttribute.setTimestamp(2, date2);
	ResultSet rsEarningsPerAttribute = psEarningsPerAttribute.executeQuery();
	%>
	<h2>Earnings Per Item</h2>
	<table>
		<tr>
			<th>Make</th>
			<th>Model</th>
			<th>Color</th>
			<th>Year</th>
			<th>Earnings</th>
		</tr>
		<%
		while (rsEarningsPerAttribute.next()) {
		%>
		<tr>
			<td><%=rsEarningsPerAttribute.getString(1)%></td>
			<td><%=rsEarningsPerAttribute.getString(2)%></td>
			<td><%=rsEarningsPerAttribute.getString(3)%></td>
			<td><%=rsEarningsPerAttribute.getString(4)%></td>
			<td>$<%=rsEarningsPerAttribute.getString(5)%></td>
		</tr>
		<%
		}
		%>
	</table>

	<h2>Earnings Per Item Type</h2>
	<%
	// Earnings Per Make
	String earningsPerMakeQuery = "SELECT make, SUM(initial_price) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1 GROUP BY make ORDER BY make";
	PreparedStatement psEarningsPerMake = con.prepareStatement(earningsPerMakeQuery);
	psEarningsPerMake.setTimestamp(1, date1);
	psEarningsPerMake.setTimestamp(2, date2);
	ResultSet rsEarningsPerMake = psEarningsPerMake.executeQuery();
	%>
	<h3>Earnings Per Make</h3>
	<table>
		<tr>
			<th>Make</th>
			<th>Earnings</th>
		</tr>
		<%
		while (rsEarningsPerMake.next()) {
		%>
		<tr>
			<td><%=rsEarningsPerMake.getString(1)%></td>
			<td>$<%=rsEarningsPerMake.getString(2)%></td>
		</tr>
		<%
		}
		%>

		<%
		// Earnings Per Model
		String earningsPerModelQuery = "SELECT model, SUM(initial_price) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1 GROUP BY model ORDER BY model";
		PreparedStatement psEarningsPerModel = con.prepareStatement(earningsPerModelQuery);
		psEarningsPerModel.setTimestamp(1, date1);
		psEarningsPerModel.setTimestamp(2, date2);
		ResultSet rsEarningsPerModel = psEarningsPerModel.executeQuery();
		%>
		<h3>Earnings Per Model</h3>
		<table>
			<tr>
				<th>Model</th>
				<th>Earnings</th>
			</tr>
			<%
			while (rsEarningsPerModel.next()) {
			%>
			<tr>
				<td><%=rsEarningsPerModel.getString(1)%></td>
				<td>$<%=rsEarningsPerModel.getString(2)%></td>
			</tr>
			<%
			}
			%>

			<%
			// Earnings Per Color
			String earningsPerColorQuery = "SELECT color, SUM(initial_price) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1 GROUP BY color ORDER BY color";
			PreparedStatement psEarningsPerColor = con.prepareStatement(earningsPerColorQuery);
			psEarningsPerColor.setTimestamp(1, date1);
			psEarningsPerColor.setTimestamp(2, date2);
			ResultSet rsEarningsPerColor = psEarningsPerColor.executeQuery();
			%>
			<h3>Earnings Per Color</h3>
			<table>
				<tr>
					<th>Color</th>
					<th>Earnings</th>
				</tr>
				<%
				while (rsEarningsPerColor.next()) {
				%>
				<tr>
					<td><%=rsEarningsPerColor.getString(1)%></td>
					<td>$<%=rsEarningsPerColor.getString(2)%></td>
				</tr>
				<%
				}
				%>
			</table>

			<%
			// Earnings Per Year
			String earningsPerYearQuery = "SELECT year, SUM(initial_price) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1 GROUP BY year ORDER BY year";
			PreparedStatement psEarningsPerYear = con.prepareStatement(earningsPerYearQuery);
			psEarningsPerYear.setTimestamp(1, date1);
			psEarningsPerYear.setTimestamp(2, date2);
			ResultSet rsEarningsPerYear = psEarningsPerYear.executeQuery();
			%>
			<h3>Earnings Per Year</h3>
			<table>
				<tr>
					<th>Year</th>
					<th>Earnings</th>
				</tr>
				<%
				while (rsEarningsPerYear.next()) {
				%>
				<tr>
					<td><%=rsEarningsPerYear.getString(1)%></td>
					<td>$<%=rsEarningsPerYear.getString(2)%></td>
				</tr>
				<%
				}
				%>
			</table>

			<%
			// Best Selling Items Query
			String bestSellingItemsQuery = "SELECT make, model, SUM(initial_price), COUNT(*) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1 GROUP BY make, model ORDER BY SUM(initial_price) DESC";
			PreparedStatement psBestSellingItems = con.prepareStatement(bestSellingItemsQuery);
			psBestSellingItems.setTimestamp(1, date1);
			psBestSellingItems.setTimestamp(2, date2);
			ResultSet rsBestSellingItems = psBestSellingItems.executeQuery();
			%>
			<h2>Best Selling Items</h2>
			<table>
				<tr>
					<th>Make</th>
					<th>Model</th>
					<th>Total Earnings</th>
					<th>Units Sold</th>
				</tr>
				<%
				while (rsBestSellingItems.next()) {
				%>
				<tr>
					<td><%=rsBestSellingItems.getString(1)%></td>
					<td><%=rsBestSellingItems.getString(2)%></td>
					<td>$<%=rsBestSellingItems.getString(3)%></td>
					<td><%=rsBestSellingItems.getString(4)%></td>
				</tr>
				<%
				}
				rsBestSellingItems.close();
				%>
			</table>

			<%
			// Best Buyers Query
			String bestBuyersQuery = "SELECT p.username, SUM(b.price) AS total_spent, COUNT(*) AS num_items_bought FROM places p JOIN bids b ON p.bid_id = b.bid_id JOIN listings l ON b.bid_id = l.listing_id WHERE l.date_time >= ? AND l.date_time <= ? AND l.open_close = 1 GROUP BY p.username ORDER BY SUM(b.price) DESC";
			PreparedStatement psBestBuyers = con.prepareStatement(bestBuyersQuery);
			psBestBuyers.setTimestamp(1, date1);
			psBestBuyers.setTimestamp(2, date2);
			ResultSet rsBestBuyers = psBestBuyers.executeQuery();
			%>
			<h2>Best Buyers</h2>
			<table>
				<tr>
					<th>Username</th>
					<th>Total Spent (Earning Per End-User)</th>
					<th>Items Bought</th>
				</tr>
				<%
				while (rsBestBuyers.next()) {
				%>
				<tr>
					<td><%=rsBestBuyers.getString(1)%></td>
					<td>$<%=rsBestBuyers.getString(2)%></td>
					<td><%=rsBestBuyers.getString(3)%></td>
				</tr>
				<%
				}
				rsBestBuyers.close();
				%>
			</table>

			<%
			// Clean up and close connections
			psTotalEarnings.close();
			psEarningsPerAttribute.close();
			rsTotalEarnings.close();
			rsEarningsPerMake.close();
			psEarningsPerMake.close();
			rsEarningsPerModel.close();
			psEarningsPerModel.close();
			rsEarningsPerColor.close();
			psEarningsPerColor.close();
			rsEarningsPerYear.close();
			psEarningsPerYear.close();
			con.close();
			psBestSellingItems.close();
			psBestBuyers.close();
			con.close();

			out.println("<a href='AdminHome.jsp'>Back to Admin Homepage</a>");
			%>

		</table>
	</table>
</body>
</html>

 --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*"%>
<%@ page import="java.sql.Timestamp, java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create Sales Report</title>
</head>
<body>
	<%
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();

	String startDate = request.getParameter("startdate");
	String endDate = request.getParameter("enddate");

	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
	SimpleDateFormat printDate = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss");

	Timestamp date1 = new Timestamp(format.parse(startDate).getTime());
	Timestamp date2 = new Timestamp(format.parse(endDate).getTime());

	// Total Earnings Query
	String totalEarningsQuery = "SELECT SUM(initial_price) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1";
	PreparedStatement psTotalEarnings = con.prepareStatement(totalEarningsQuery);
	psTotalEarnings.setTimestamp(1, date1);
	psTotalEarnings.setTimestamp(2, date2);
	ResultSet rsTotalEarnings = psTotalEarnings.executeQuery();
	String totalEarnings = "0.00";
	if (rsTotalEarnings.next()) {
		totalEarnings = rsTotalEarnings.getString(1);
	}

	// Display Report Header
	%>
	<h1>Sales Report</h1>
	<h2>
		From:
		<%=printDate.format(format.parse(startDate))%></h2>
	<h2>
		To:
		<%=printDate.format(format.parse(endDate))%></h2>
	<h2>
		Total Earnings: $<%=totalEarnings%></h2>

	<h2>Earnings Per Item</h2>
	<table>
		<tr>
			<th>Make</th>
			<th>Model</th>
			<th>Color</th>
			<th>Year</th>
			<th>Earnings</th>
		</tr>
		<%
		// Earnings Per Item
		String earningsPerItemQuery = "SELECT make, model, color, year, SUM(initial_price) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1 GROUP BY make, model, color, year ORDER BY make, model, color, year";
		PreparedStatement psEarningsPerItem = con.prepareStatement(earningsPerItemQuery);
		psEarningsPerItem.setTimestamp(1, date1);
		psEarningsPerItem.setTimestamp(2, date2);
		ResultSet rsEarningsPerItem = psEarningsPerItem.executeQuery();
		while (rsEarningsPerItem.next()) {
		%>
		<tr>
			<td><%=rsEarningsPerItem.getString(1)%></td>
			<td><%=rsEarningsPerItem.getString(2)%></td>
			<td><%=rsEarningsPerItem.getString(3)%></td>
			<td><%=rsEarningsPerItem.getString(4)%></td>
			<td>$<%=rsEarningsPerItem.getString(5)%></td>
		</tr>
		<%
		}
		%>
	</table>

	<h2>Earnings Per Item Type</h2>
	<h3>Earnings Per Make</h3>
	<table>
		<tr>
			<th>Make</th>
			<th>Earnings</th>
		</tr>
		<%
		// Earnings Per Make
		String earningsPerMakeQuery = "SELECT make, SUM(initial_price) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1 GROUP BY make ORDER BY make";
		PreparedStatement psEarningsPerMake = con.prepareStatement(earningsPerMakeQuery);
		psEarningsPerMake.setTimestamp(1, date1);
		psEarningsPerMake.setTimestamp(2, date2);
		ResultSet rsEarningsPerMake = psEarningsPerMake.executeQuery();
		while (rsEarningsPerMake.next()) {
		%>
		<tr>
			<td><%=rsEarningsPerMake.getString(1)%></td>
			<td>$<%=rsEarningsPerMake.getString(2)%></td>
		</tr>
		<%
		}
		%>
	</table>

	<h3>Earnings Per Model</h3>
	<table>
		<tr>
			<th>Model</th>
			<th>Earnings</th>
		</tr>
		<%
		// Earnings Per Model
		String earningsPerModelQuery = "SELECT model, SUM(initial_price) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1 GROUP BY model ORDER BY model";
		PreparedStatement psEarningsPerModel = con.prepareStatement(earningsPerModelQuery);
		psEarningsPerModel.setTimestamp(1, date1);
		psEarningsPerModel.setTimestamp(2, date2);
		ResultSet rsEarningsPerModel = psEarningsPerModel.executeQuery();
		while (rsEarningsPerModel.next()) {
		%>
		<tr>
			<td><%=rsEarningsPerModel.getString(1)%></td>
			<td>$<%=rsEarningsPerModel.getString(2)%></td>
		</tr>
		<%
		}
		%>
	</table>

	<h3>Earnings Per Color</h3>
	<table>
		<tr>
			<th>Color</th>
			<th>Earnings</th>
		</tr>
		<%
		// Earnings Per Color
		String earningsPerColorQuery = "SELECT color, SUM(initial_price) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1 GROUP BY color ORDER BY color";
		PreparedStatement psEarningsPerColor = con.prepareStatement(earningsPerColorQuery);
		psEarningsPerColor.setTimestamp(1, date1);
		psEarningsPerColor.setTimestamp(2, date2);
		ResultSet rsEarningsPerColor = psEarningsPerColor.executeQuery();
		while (rsEarningsPerColor.next()) {
		%>
		<tr>
			<td><%=rsEarningsPerColor.getString(1)%></td>
			<td>$<%=rsEarningsPerColor.getString(2)%></td>
		</tr>
		<%
		}
		%>
	</table>

	<h3>Earnings Per Year</h3>
	<table>
		<tr>
			<th>Year</th>
			<th>Earnings</th>
		</tr>
		<%
		// Earnings Per Year
		String earningsPerYearQuery = "SELECT year, SUM(initial_price) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1 GROUP BY year ORDER BY year";
		PreparedStatement psEarningsPerYear = con.prepareStatement(earningsPerYearQuery);
		psEarningsPerYear.setTimestamp(1, date1);
		psEarningsPerYear.setTimestamp(2, date2);
		ResultSet rsEarningsPerYear = psEarningsPerYear.executeQuery();
		while (rsEarningsPerYear.next()) {
		%>
		<tr>
			<td><%=rsEarningsPerYear.getString(1)%></td>
			<td>$<%=rsEarningsPerYear.getString(2)%></td>
		</tr>
		<%
		}
		%>
	</table>

	<%
	// Best Selling Items Query
	String bestSellingItemsQuery = "SELECT make, model, SUM(initial_price), COUNT(*) FROM listings WHERE date_time >= ? AND date_time <= ? AND open_close = 1 GROUP BY make, model ORDER BY SUM(initial_price) DESC";
	PreparedStatement psBestSellingItems = con.prepareStatement(bestSellingItemsQuery);
	psBestSellingItems.setTimestamp(1, date1);
	psBestSellingItems.setTimestamp(2, date2);
	ResultSet rsBestSellingItems = psBestSellingItems.executeQuery();
	%>
	<h2>Best Selling Items</h2>
	<table>
		<tr>
			<th>Make</th>
			<th>Model</th>
			<th>Total Earnings</th>
			<th>Units Sold</th>
		</tr>
		<%
		while (rsBestSellingItems.next()) {
		%>
		<tr>
			<td><%=rsBestSellingItems.getString(1)%></td>
			<td><%=rsBestSellingItems.getString(2)%></td>
			<td>$<%=rsBestSellingItems.getString(3)%></td>
			<td><%=rsBestSellingItems.getString(4)%></td>
		</tr>
		<%
		}
		rsBestSellingItems.close();
		%>
	</table>

	<%
	// Best Buyers Query
	String bestBuyersQuery = "SELECT p.username, SUM(b.price) AS total_spent, COUNT(*) AS num_items_bought FROM places p JOIN bids b ON p.bid_id = b.bid_id JOIN listings l ON b.bid_id = l.listing_id WHERE l.date_time >= ? AND l.date_time <= ? AND l.open_close = 1 GROUP BY p.username ORDER BY SUM(b.price) DESC";
	PreparedStatement psBestBuyers = con.prepareStatement(bestBuyersQuery);
	psBestBuyers.setTimestamp(1, date1);
	psBestBuyers.setTimestamp(2, date2);
	ResultSet rsBestBuyers = psBestBuyers.executeQuery();
	%>
	<h2>Best Buyers</h2>
	<table>
		<tr>
			<th>Username</th>
			<th>Total Spent (Earning Per End-User)</th>
			<th>Items Bought</th>
		</tr>
		<%
		while (rsBestBuyers.next()) {
		%>
		<tr>
			<td><%=rsBestBuyers.getString(1)%></td>
			<td>$<%=rsBestBuyers.getString(2)%></td>
			<td><%=rsBestBuyers.getString(3)%></td>
		</tr>
		<%
		}
		rsBestBuyers.close();
		%>
	</table>

	<%
	// Clean up and close connections
	psTotalEarnings.close();
	rsTotalEarnings.close();
	rsEarningsPerMake.close();
	psEarningsPerMake.close();
	rsEarningsPerModel.close();
	psEarningsPerModel.close();
	rsEarningsPerColor.close();
	psEarningsPerColor.close();
	rsEarningsPerYear.close();
	psEarningsPerYear.close();
	con.close();
	psBestSellingItems.close();
	psBestBuyers.close();
	con.close();

	out.println("<a href='AdminHome.jsp'>Back to Admin Homepage</a>");
	%>

	<table></table>
	<table></table>
</body>
</html>


