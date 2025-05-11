<%@page import="java.sql.*"%>
<%@page import="com.restaurant.util.DBConnection"%>
<%@page import="com.restaurant.entities.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
User u = (User) session.getAttribute("currentUser");
String role = (String) session.getAttribute("role");
if (u == null || !"admin".equals(role)) {
	response.sendRedirect("../login");
	return;
}

// Database queries
int totalUsers = 0, totalOrders = 0, pendingOrders = 0, deliveredOrders = 0;
double totalRevenue = 0;
String categoryNames = "";
String categorySales = "";

try (Connection con = DBConnection.getConnection()) {
	Statement stmt = con.createStatement();
	ResultSet rs;

	rs = stmt.executeQuery("SELECT COUNT(*) FROM users where role='customer'");
	if (rs.next())
		totalUsers = rs.getInt(1);

	rs = stmt.executeQuery("SELECT COUNT(*) FROM orders");
	if (rs.next())
		totalOrders = rs.getInt(1);

	rs = stmt.executeQuery("SELECT COUNT(*) FROM orders WHERE status='Pending'");
	if (rs.next())
		pendingOrders = rs.getInt(1);

	rs = stmt.executeQuery("SELECT COUNT(*) FROM orders WHERE status='Delivered'");
	if (rs.next())
		deliveredOrders = rs.getInt(1);

	rs = stmt.executeQuery("SELECT SUM(total_price) FROM orders WHERE status='Delivered'");
	if (rs.next())
		totalRevenue = rs.getDouble(1);

	// Fetch category-wise sales data
	rs = stmt.executeQuery(
	"SELECT c.category_name, SUM(oi.quantity) FROM order_items oi INNER JOIN food_items f ON oi.food_id = f.food_id INNER JOIN categories c ON f.category_id = c.category_id GROUP BY c.category_name");
	while (rs.next()) {
		categoryNames += "'" + rs.getString(1) + "',";
		categorySales += rs.getInt(2) + ",";
	}
	if (!categoryNames.isEmpty()) {
		categoryNames = categoryNames.substring(0, categoryNames.length() - 1);
		categorySales = categorySales.substring(0, categorySales.length() - 1);
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>

<jsp:include page="include_header.jsp" />

<div class="container mt-5">
	<h2 class="text-light text-center display-4">Admin Dashboard</h2>

	<!-- Cards for Analytics -->
	<div class="row mt-4">
		<div class="col-md-3">
			<div class="card bg-dark text-white shadow-lg">
				<div class="card-body text-center">
					<h5>Total Registered Users</h5>
					<h3><%=totalUsers%></h3>
				</div>
			</div>
		</div>
		<div class="col-md-3">
			<div class="card bg-dark text-white shadow-lg">
				<div class="card-body text-center">
					<h5>Total Online Orders</h5>
					<h3><%=totalOrders%></h3>
				</div>
			</div>
		</div>
		<div class="col-md-3">
			<div class="card bg-dark text-white shadow-lg">
				<div class="card-body text-center">
					<h5>Revenue from Online Orders</h5>
					<h3>
						₹<%=String.format("%.2f", totalRevenue)%></h3>
				</div>
			</div>
		</div>
		<div class="col-md-3">
			<div class="card bg-dark text-white shadow-lg">
				<div class="card-body text-center">
					<h5>Pending Online Orders</h5>
					<h3><%=pendingOrders%></h3>
				</div>
			</div>
		</div>
	</div>

	<!-- Graphs -->
	<div class="row mt-4">
		<div class="col-md-4">
			<canvas id="ordersChart" style="max-height: 250px;"></canvas>
		</div>
		<div class="col-md-4">
			<canvas id="orderStatusChart" style="max-height: 250px;"></canvas>
		</div>
		<div class="col-md-4">
			<canvas id="categorySalesChart" style="max-height: 250px;"></canvas>
		</div>
	</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
	// Orders Comparison Chart
	var ordersCtx = document.getElementById("ordersChart").getContext("2d");
	var ordersChart = new Chart(ordersCtx, {
		type : "line",
		data : {
			labels : [ "Jan", "Feb", "Mar", "Apr", "May", "Jun" ],
			datasets : [ {
				label : "Orders Per Month",
				data : [ 5, 10, 15, 20, 25, 30 ], // Replace with real data
				backgroundColor : "rgba(52, 152, 219, 0.2)",
				borderColor : "#3498db",
				borderWidth : 2,
				fill : true
			} ]
		},
		options : {
			responsive : true,
			maintainAspectRatio : false,
			plugins : {
				legend : {
					display : true
				},
				tooltip : {
					enabled : true
				}
			}
		}
	});

	// Order Status Doughnut Chart
	var statusCtx = document.getElementById("orderStatusChart")
			.getContext("2d");
	var statusChart = new Chart(statusCtx, {
		type : "doughnut",
		data : {
			labels : [ "Pending", "Delivered" ],
			datasets : [ {
				data : [
<%=pendingOrders%>
	,
<%=deliveredOrders%>
	],
				backgroundColor : [ "#e74c3c", "#2ecc71" ],
				borderWidth : 1
			} ]
		},
		options : {
			responsive : true,
			maintainAspectRatio : false,
			plugins : {
				legend : {
					position : "bottom"
				},
				tooltip : {
					enabled : true
				}
			}
		}
	});

	// Category-wise Sales Chart
	var categoryCtx = document.getElementById("categorySalesChart").getContext(
			"2d");
	var categorySalesChart = new Chart(categoryCtx, {
		type : "bar",
		data : {
			labels : [
<%=categoryNames%>
	],
			datasets : [ {
				label : "Sales by Category",
				data : [
<%=categorySales%>
	],
				backgroundColor : [ "#1abc9c", "#f39c12", "#8e44ad", "#e74c3c",
						"#3498db" ],
				borderColor : "#fff",
				borderWidth : 1
			} ]
		},
		options : {
			responsive : true,
			maintainAspectRatio : false,
			plugins : {
				legend : {
					display : true
				},
				tooltip : {
					enabled : true
				}
			},
			scales : {
				y : {
					beginAtZero : true
				}
			}
		}
	});
</script>

<jsp:include page="include_footer.jsp" />
