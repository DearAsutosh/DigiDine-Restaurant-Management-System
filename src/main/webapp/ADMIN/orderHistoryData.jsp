<%@ page import="java.sql.*"%>
<%@ page import="com.restaurant.util.DBConnection"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
String orderType = request.getParameter("type");
if (orderType == null || (!orderType.equals("online") && !orderType.equals("offline"))) {
	orderType = "online"; // default
}

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
	conn = DBConnection.getConnection();
	String sql = "";

	if ("offline".equals(orderType)) {
		sql = "SELECT go.guest_order_id AS order_id, go.customer_name, go.mobile_number, go.order_date, go.payment_method, "
		+ "(SELECT SUM(goi.quantity * fi.price) FROM guest_order_items goi "
		+ "JOIN food_items fi ON goi.food_item_id = fi.food_id WHERE goi.guest_order_id = go.guest_order_id) AS total_price "
		+ "FROM guest_orders go ORDER BY go.order_date DESC";
	} else {
		sql = "SELECT o.order_id, u.userid, u.name AS customer_name, o.total_price, o.status, o.order_date "
		+ "FROM orders o JOIN users u ON o.user_id = u.userid ORDER BY o.order_date DESC";
	}

	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
%>

<table
	class="table table-bordered table-striped table-hover text-center table-dark">
	<thead>
		<tr>
			<th>#</th>
			<th>Order ID</th>
			<%
			if ("online".equals(orderType)) {
			%>
			<th>User ID</th>
			<%
			} else {
			%>
			<th>Customer Type</th>
			<%
			}
			%>
			<th>Customer Name</th>
			<%
			if ("offline".equals(orderType)) {
			%>
			<th>Mobile</th>
			<th>Payment</th>
			<%
			}
			%>
			<th>Total Price</th>
			<%
			if ("online".equals(orderType)) {
			%>
			<th>Status</th>
			<%
			}
			%>
			<th>Order Date</th>
			<th>Ordered Items</th>
			<th>Show Bill</th>
		</tr>
	</thead>
	<tbody>
		<%
		int count = 1;
		while (rs.next()) {
			int orderId = rs.getInt("order_id");
			String customerName = rs.getString("customer_name");
			double totalPrice = rs.getDouble("total_price");
			String orderDate = rs.getString("order_date");

			String userOrGuest = "online".equals(orderType) ? String.valueOf(rs.getInt("userid")) : "Guest";
		%>
		<tr>
			<td><%=count++%></td>
			<td><%=orderId%></td>
			<td><%=userOrGuest%></td>
			<td><%=customerName%></td>
			<%
			if ("offline".equals(orderType)) {
			%>
			<td><%=rs.getString("mobile_number")%></td>
			<td><%=rs.getString("payment_method")%></td>
			<%
			}
			%>
			<td>₹<%=String.format("%.2f", totalPrice)%></td>
			<%
			if ("online".equals(orderType)) {
			%>
			<td><%=rs.getString("status")%></td>
			<%
			}
			%>
			<td><%=orderDate%></td>
			<td><a
				href="../view_order_items.jsp?order_id=<%=orderId%>&type=<%=orderType%>"
				class="btn btn-warning btn-sm">View Items</a></td>
			<td>
				<%
				if ("online".equals(orderType)) {
				%> <a
				href="../generate-bill.jsp?orderId=<%=orderId%>&type=online"
				class="btn btn-info btn-sm" target="_blank">Show Bill</a> <%
 } else {
 %>
				<a href="../generate-bill.jsp?guest_order_id=<%=orderId%>&type=offline"
				class="btn btn-info btn-sm" target="_blank">Show Bill</a> <%
 }
 %>
			</td>
		</tr>
		<%
		}
		%>
	</tbody>
</table>

<%
} catch (Exception e) {
out.println("<div class='text-danger text-center'>Error loading order history.</div>");
e.printStackTrace();
} finally {
if (rs != null)
	rs.close();
if (pstmt != null)
	pstmt.close();
if (conn != null)
	conn.close();
}
%>
