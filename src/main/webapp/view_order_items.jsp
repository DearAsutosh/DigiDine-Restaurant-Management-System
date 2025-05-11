<%@page import="com.restaurant.entities.User"%>
<%@page import="com.restaurant.util.DBConnection"%>
<%@ page import="java.sql.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
User u = (User) session.getAttribute("currentUser");
String currentPage = request.getRequestURI(); // Get the current page URI
if (u == null) {
	response.sendRedirect("./login");
	return;
}
%>
<html>
<head>
<title>Ordered Items</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<style>
body {
	background-color: #121212;
	color: #ffffff;
}

.table {
	background-color: #222;
	color: #f8f9fa;
	text-align: center;
}

.table thead {
	background-color: #444;
}

.table tbody tr:hover {
	background-color: #333;
}

.table td, .table th {
	background-color: #222 !important;
	color: #f8f9fa;
	vertical-align: middle;
	text-align: center;
}

.text-warning {
	font-weight: bold;
}

.btn-warning {
	background-color: #ffc107;
	border-color: #ffc107;
	color: #121212;
}

.btn-warning:hover {
	background-color: #e0a800;
	border-color: #d39e00;
}

h3 {
	border-bottom: 2px solid #ffc107;
	padding-bottom: 10px;
	display: inline-block;
	color: #ffc107;
}
</style>
</head>
<body>
	<div class="container mt-4">
		<h3 class="text-center">Ordered Items</h3>
		<table class="table table-hover">
			<thead>
				<tr class="text-warning">
					<th>Food Name</th>
					<th>Quantity</th>
					<th>Price</th>
				</tr>
			</thead>
			<tbody>
				<%
				String orderId = request.getParameter("order_id");
				if (orderId != null) {
					try (Connection conn = DBConnection.getConnection()) {
						String sql = "SELECT f.food_name, oi.quantity, oi.price FROM order_items oi "
						+ "JOIN food_items f ON oi.food_id = f.food_id " + "WHERE oi.order_id = ?";
						PreparedStatement pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, Integer.parseInt(orderId));
						ResultSet rs = pstmt.executeQuery();

						boolean hasData = false;
						while (rs.next()) {
					hasData = true;
				%>
				<tr>
					<td><%=rs.getString("food_name")%></td>
					<td><%=rs.getInt("quantity")%></td>
					<td class="text-warning">&#8377;<%=rs.getDouble("price")%></td>
				</tr>
				<%
				}
				if (!hasData) {
				%>
				<tr>
					<td colspan="3" class="text-warning">No items found for this
						order.</td>
				</tr>
				<%
				}
				} catch (Exception e) {
				out.println("<tr><td colspan='3' class='text-danger'>Error loading order items</td></tr>");
				e.printStackTrace();
				}
				} else {
				%>
				<tr>
					<td colspan="3" class="text-danger">Invalid Order ID</td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>
		<div class="text-center">
			<a href="./ADMIN/order_history.jsp" class="btn btn-warning">Back
				to Orders</a>
		</div>
	</div>
</body>
</html>
