<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.cs336.pkg.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Delete Listing</title>
</head>
<body>
	<%
	ApplicationDB db = new ApplicationDB();
	Connection con = null;
	PreparedStatement ps = null;

	try {
		con = db.getConnection();
		int listingId = Integer.parseInt(request.getParameter("listing_id"));

		// Delete the referencing rows in interests
		String queryInterests = "DELETE FROM interests WHERE listing_id = ?";
		ps = con.prepareStatement(queryInterests);
		ps.setInt(1, listingId);
		ps.executeUpdate();
		ps.close();

		// Delete the referencing rows in auto_bids
		String queryAutoBids = "DELETE FROM auto_bids WHERE listing_id = ?";
		ps = con.prepareStatement(queryAutoBids);
		ps.setInt(1, listingId);
		ps.executeUpdate();
		ps.close();

		// Delete bids associated with the listing through bidsOn
		ps = con.prepareStatement("SELECT bid_id FROM bidsOn WHERE listing_id = ?");
		ps.setInt(1, listingId);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			PreparedStatement ps2 = con.prepareStatement("DELETE FROM bids WHERE bid_id = ?");
			ps2.setInt(1, rs.getInt("bid_id"));
			ps2.executeUpdate();
			ps2.close();
		}
		rs.close();
		ps.close();

		// Finally, delete the listing
		String sql = "DELETE FROM listings WHERE listing_id = ?";
		ps = con.prepareStatement(sql);
		ps.setInt(1, listingId);
		int count = ps.executeUpdate();
		ps.close();

		if (count > 0) {
			out.println("<p>Listing deleted successfully.</p>");
		} else {
			out.println("<p>Error: Listing not found or could not be deleted.</p>");
		}

	} catch (SQLException e) {
		out.println("<p>Error processing request: " + e.getMessage() + "</p>");
	} finally {
		if (ps != null) ps.close();
		if (con != null) con.close();
	}

	out.println("<a href='AllListings.jsp'>Back to Listings</a>");
	%>
</body>
</html>
