<%@page import="com.restaurant.entities.User"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.restaurant.util.DBConnection"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
User u = (User) session.getAttribute("currentUser");
String currentPage = request.getRequestURI(); // Get the current page URI
String role = (String) session.getAttribute("role");
if (u == null || !"admin".equals(role)) {
	response.sendRedirect("../login");
	return;
}
%>
<jsp:include page="include_header.jsp" />
<meta http-equiv="refresh" content="60">
<style>
body {
	background-color: #121212; /* Dark background */
	color: #ffffff; /* Light text */
}

.table {
	background-color: #1e1e1e; /* Darker table background */
	border-radius: 10px; /* Rounded corners */
	overflow: hidden; /* Prevents border overflow */
}

.table th {
	background-color: black; /* Darker header background */
	color: #ffdd57; /* Header text color */
	font-weight: bold; /* Bold header text */
	text-align: center; /* Centered text */
}

.table td {
	background-color: #1e1e1e; /* Ensure cell background matches table */
	color: #ffffff; /* Light text in cells */
	vertical-align: middle; /* Center vertical alignment */
}

.table-striped tbody tr:nth-of-type(odd) {
	background-color: rgba(255, 221, 87, 0.05);
	/* Light stripe for odd rows */
}

.table-hover tbody tr:hover {
	background-color: black; /* Hover effect */
	transition: background-color 0.3s ease; /* Smooth transition */
}

.btn-success {
	background-color: #28a745; /* Success button color */
	border: none; /* No border */
	transition: background-color 0.3s; /* Smooth transition */
}

.btn-success:hover {
	background-color: #218838; /* Darker button on hover */
}

.btn-danger {
	background-color: #dc3545; /* Danger button color */
	border: none; /* No border */
	transition: background-color 0.3s; /* Smooth transition */
}

.btn-danger:hover {
	background-color: #c82333; /* Darker button on hover */
}

/* Add some padding to the table for aesthetics */
.table td, .table th {
	padding: 10px;
	text-align: center; /* Centered text */
}

/* Responsive adjustments */
@media ( max-width : 768px) {
	.table {
		font-size: 14px; /* Smaller font on mobile */
	}
}
</style>

<div class="container-fluid px-4">
	<div id="order-management" class="content-section mt-4">
		<h2 class="h4 text-center">Online Order Management</h2>
		<hr>
		<%
		boolean hasPendingOrders = false;
		try (Connection conn = DBConnection.getConnection()) {
			String sql = "SELECT o.order_id, u.name AS customer_name, u.mobileNumber, o.total_price, o.status "
			+ "FROM orders o JOIN users u ON o.user_id = u.userid "
			+ "WHERE o.status = 'Pending' ORDER BY o.order_date DESC";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();

			if (rs.isBeforeFirst()) { // Check if there are any pending orders
				hasPendingOrders = true;
		%>
		<div class="table-responsive">
			<table class="table table-bordered mt-3 table-striped table-hover">
				<thead>
					<tr>
						<th>Order ID</th>
						<th>Customer Name</th>
						<th>Mobile Number</th>
						<!-- Added Mobile Number Header -->
						<th>Total Price</th>
						<th>Status</th>
						<th>Update Status</th>
					</tr>
				</thead>
				<tbody id="orderManagementTableBody">
					<%
					while (rs.next()) {
						int orderId = rs.getInt("order_id");
						String customerName = rs.getString("customer_name");
						String mobileNumber = rs.getString("mobileNumber"); // Fetch Mobile Number
						double totalPrice = rs.getDouble("total_price");
					%>
					<tr>
						<td><%=orderId%></td>
						<td><%=customerName%></td>
						<td><%=mobileNumber%></td>
						<!-- Added Mobile Number Data -->
						<td>&#8377;<%=String.format("%.2f", totalPrice)%></td>
						<td>Pending</td>
						<td>
							<button class="btn btn-success"
								onclick="updateOrderStatus(<%=orderId%>, 'Delivered')">Delivered</button>
							<button class="btn btn-danger"
								onclick="updateOrderStatus(<%=orderId%>, 'Rejected')">Rejected</button>
						</td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>
		<%
		}
		} catch (Exception e) {
		out.println("<p class='text-danger'>Error loading order data</p>");
		e.printStackTrace();
		}

		if (!hasPendingOrders) {
		%>
		<h5 class="text-center text-danger mt-3">No Pending Orders!</h5>
		<%
		}
		%>
	</div>
</div>

<script type="text/javascript">
function updateOrderStatus(orderId, status) {
    Swal.fire({
        title: "Are you sure?",
        text: "Do you want to update the order status to " + status + "?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Yes, update it!",
        cancelButtonText: "Cancel"
    }).then((result) => {
        if (result.isConfirmed) {
            fetch('../UpdateOrderStatusServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'order_id=' + orderId + '&status=' + status
            })
            .then(response => response.text())
            .then(data => {
                Swal.fire("Updated!", "Order status has been updated.", "success")
                    .then(() => location.reload());
            })
            .catch(error => Swal.fire("Error!", "Failed to update order status.", "error"));
        }
    });
}
</script>

<jsp:include page="include_footer.jsp" />
