<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*"%>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
<title>Delete Bid</title>
</head>
<body>
	<%
	ApplicationDB db = new ApplicationDB();
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;

	try {
		con = db.getConnection();

		int bidId = 0;
		String bidIdParam = request.getParameter("bid_id");
		if (bidIdParam != null) {
			bidId = Integer.parseInt(bidIdParam);
		}

		// Retrieve listing_id before deleting the bid
		int listingId = -1;
		String preQuery = "SELECT listing_id FROM bidsOn WHERE bid_id = ?";
		ps = con.prepareStatement(preQuery);
		ps.setInt(1, bidId);
		rs = ps.executeQuery();
		if (rs.next()) {
			listingId = rs.getInt("listing_id");
		}
		rs.close();
		ps.close();

		// Delete the bid
		String sql = "DELETE FROM bids WHERE bid_id = ?";
		ps = con.prepareStatement(sql);
		ps.setInt(1, bidId);
		int count = ps.executeUpdate();

		if (count > 0 && listingId != -1) {
			// Find the next highest bid for the listing
			BigDecimal nextHighestBid = null;
			String nextBidQuery = "SELECT MAX(price) AS next_price FROM bids INNER JOIN bidsOn ON bids.bid_id = bidsOn.bid_id WHERE listing_id = ?";
			ps = con.prepareStatement(nextBidQuery);
			ps.setInt(1, listingId);
			rs = ps.executeQuery();
			if (rs.next()) {
				nextHighestBid = rs.getBigDecimal("next_price");
			}
			rs.close();
			ps.close();

			// Update the listing price
			BigDecimal newPrice = (nextHighestBid != null) ? nextHighestBid : new BigDecimal("DEFAULT_PRICE");
			String updateListingQuery = "UPDATE listings SET initial_price = ? WHERE listing_id = ?";
			ps = con.prepareStatement(updateListingQuery);
			ps.setBigDecimal(1, newPrice);
			ps.setInt(2, listingId);
			ps.executeUpdate();

			out.println("<p>Bid deleted successfully. Listing price updated.</p>");
		} else {
			out.println("<p>Error: Bid not found or could not be deleted.</p>");
		}

	} catch (NumberFormatException e) {
		out.println("<p>Error: Invalid bid ID.</p>");
	} catch (SQLException e) {
		out.println("<p>Error processing request: " + e.getMessage() + "</p>");
	} finally {
		rs.close();
		ps.close();
		con.close();
	}

	out.println("<a href='AllBids.jsp'>Back to Bids</a>");
	%>
</body>
</html>