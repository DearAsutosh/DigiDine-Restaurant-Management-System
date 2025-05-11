<%@ page import="java.sql.*, com.restaurant.util.DBConnection"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
String orderIdStr = request.getParameter("orderId");
String guestOrderIdStr = request.getParameter("guest_order_id");

Connection conn = DBConnection.getConnection();

boolean isGuest = (guestOrderIdStr != null);
boolean isRegistered = (orderIdStr != null);
String customerName = "", mobileNumber = "", address = "N/A", orderDate = "";
double grandTotal = 0;
ResultSet itemsRs = null;

if (isRegistered) {
	int orderId = Integer.parseInt(orderIdStr);
	PreparedStatement orderInfoStmt = conn.prepareStatement(
	"SELECT u.name, u.mobileNumber, u.address, o.order_date FROM orders o JOIN users u ON o.user_id = u.userid WHERE o.order_id = ?");
	orderInfoStmt.setInt(1, orderId);
	ResultSet infoRs = orderInfoStmt.executeQuery();
	if (infoRs.next()) {
		customerName = infoRs.getString("name");
		mobileNumber = infoRs.getString("mobileNumber");
		address = infoRs.getString("address");
		orderDate = infoRs.getString("order_date");
	} else {
		out.println("<div class='container mt-5 text-danger'>No such order found for registered user.</div>");
		return;
	}
	PreparedStatement itemStmt = conn.prepareStatement(
	"SELECT f.food_name, oi.quantity, oi.price FROM order_items oi JOIN food_items f ON oi.food_id = f.food_id WHERE oi.order_id = ?");
	itemStmt.setInt(1, orderId);
	itemsRs = itemStmt.executeQuery();

} else if (isGuest) {
	int guestOrderId = Integer.parseInt(guestOrderIdStr);
	PreparedStatement guestStmt = conn.prepareStatement(
	"SELECT customer_name, mobile_number, order_date FROM guest_orders WHERE guest_order_id = ?");
	guestStmt.setInt(1, guestOrderId);
	ResultSet guestRs = guestStmt.executeQuery();
	if (guestRs.next()) {
		customerName = guestRs.getString("customer_name");
		mobileNumber = guestRs.getString("mobile_number");
		orderDate = guestRs.getString("order_date");
		address = "Guest - No Address";
	} else {
		out.println("<div class='container mt-5 text-danger'>No such guest order found.</div>");
		return;
	}
	PreparedStatement guestItemStmt = conn.prepareStatement(
	"SELECT f.food_name, f.price, i.quantity FROM guest_order_items i JOIN food_items f ON i.food_item_id = f.food_id WHERE i.guest_order_id = ?");
	guestItemStmt.setInt(1, guestOrderId);
	itemsRs = guestItemStmt.executeQuery();
} else {
	out.println(
	"<div class='container mt-5 text-danger'>Invalid parameters. Please provide either orderId or guest_order_id.</div>");
	return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Restaurant Bill</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
@import
	url('https://fonts.googleapis.com/css2?family=Signika:wght@300..700&display=swap')
	;
body {
	background-color: #121212;
	color: #f8f9fa;
	font-family: "Signika", sans-serif;
	font-optical-sizing: auto;
}

.card {
	background-color: #1e1e1e;
	border-radius: 12px;
}

.card-header {
	border-bottom: 1px solid #444;
}

.table th {
	background-color: #2a2a2a;
	color: #ffc107 !important;
}

.table td {
	background-color: #1c1c1c;
	color: #f8f9fa !important;
}

.table tfoot td {
	background-color: #333333;
	color: #ffffff !important;
}

.btn-print {
	color: #ffc107;
	border-color: #ffc107;
}

.btn-print:hover {
	background-color: #ffc107;
	color: #1e1e1e;
}

@media print {
	body {
		background-color: white !important;
		color: black !important;
	}
	.card, .table, .table th, .table td {
		background-color: white !important;
		color: black !important;
		border-color: black !important;
	}
	.btn-print {
		display: none;
	}
}
</style>
</head>
<body>
	<div class="container mt-5">
		<div class="card shadow-lg text-light">
			<div class="card-header text-center">
				<h3 class="text-warning">DigiDine 🍽️ <br>MoneyReciept</h3>
				<small class="text-light">Order Date: <%=orderDate%></small>
			</div>
			<div class="card-body">
				<h5 class="mb-3 border-bottom pb-2">Customer Information</h5>
				<div class="row mb-3">
					<div class="col-md-4">
						<strong>Name:</strong>
						<%=customerName%></div>
					<div class="col-md-4">
						<strong>Mobile:</strong>
						<%=mobileNumber%></div>
					<div class="col-md-4">
						<strong>Address:</strong>
						<%=address%></div>
				</div>

				<h5 class="mb-3 border-bottom pb-2">Order Details</h5>
				<div class="table-responsive">
					<table class="table table-striped table-bordered align-middle">
						<thead>
							<tr>
								<th>Item</th>
								<th>Price</th>
								<th>Qty</th>
								<th>Subtotal</th>
							</tr>
						</thead>
						<tbody>
							<%
							while (itemsRs.next()) {
								String item = itemsRs.getString("food_name");
								double price = itemsRs.getDouble("price");
								int qty = itemsRs.getInt("quantity");
								double subtotal = price * qty;
								grandTotal += subtotal;
							%>
							<tr>
								<td><%=item%></td>
								<td>₹ <%=String.format("%.2f", price)%></td>
								<td><%=qty%></td>
								<td>₹ <%=String.format("%.2f", subtotal)%></td>
							</tr>
							<%
							}
							%>
						</tbody>
						<tfoot>
							<tr class="fw-bold">
								<td colspan="3" class="text-end">Total</td>
								<td>₹ <%=String.format("%.2f", grandTotal)%></td>
							</tr>
						</tfoot>
					</table>
				</div>

				<div class="text-center mt-4">
					<button class="btn btn-outline-warning btn-print"
						onclick="window.print()">🖨️ Print Bill</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
