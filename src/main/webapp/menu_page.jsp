<%@page import="java.util.Base64"%>
<%@page import="com.restaurant.util.DBConnection"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="include_header.jsp"%>

<style>
.category-carousel {
	overflow-x: auto;
	white-space: nowrap;
}

.category-carousel a {
	display: inline-block;
	margin: 0 5px;
}

.fixed-sidebar {
	position: fixed;
	overflow-y: auto;
}

.main-content {
	margin-left: 25%;
}

@media ( max-width : 768px) {
	.main-content {
		margin-left: 0;
	}
}

body {
	background-color: #121212;
	color: #ffffff;
}

.list-group-item {
	background-color: #000;
	border: none;
	color: #ffffff;
}

.list-group-item:hover {
	background-color: #333333;
	color: #ffffff;
	
}

.btn-outline-secondary {
	color: #ffffff;
	border-color: #ffffff;
}

.btn-outline-secondary:hover {
	background-color: #ffffff;
	color: #000000;
}

.btn-primary {
	background-color: #6200ea;
	border-color: #6200ea;
}

.btn-primary:hover {
	background-color: #3700b3;
	border-color: #3700b3;
}

.text-muted {
	color: #bbbbbb !important;
}
</style>
<div class="container-fluid">
	<div class="row">
		<!-- Sidebar for categories -->
		<div class="col-md-2 border-end d-none d-md-block fixed-sidebar">
			<div class="list-group list-group-flush">
				<%
				Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM categories");
				ResultSet rs = pstmt.executeQuery();

				while (rs.next()) {
					int categoryId = rs.getInt("category_id");
					String categoryName = rs.getString("category_name");
				%>
				<a href="#category_<%=categoryId%>"
					class="list-group-item list-group-item-action"><%=categoryName%></a>
				<%
				}
				rs.close();
				pstmt.close();
				%>
			</div>
		</div>

		<!-- Main Content -->
		<div class="col-md-9 p-4 main-content">
			<%
			pstmt = conn.prepareStatement("SELECT * FROM categories");
			rs = pstmt.executeQuery();

			while (rs.next()) {
				int categoryId = rs.getInt("category_id");
				String categoryName = rs.getString("category_name");
			%>
			<h2 id="category_<%=categoryId%>"
				class="text-warning fw-bold border-bottom border-secondary pb-2 my-4">
				<i class="fas fa-hamburger me-2"></i><%=categoryName%>
			</h2>
	
			<div class="row row-cols-1 row-cols-md-3 g-4">
				<%
				PreparedStatement foodStmt = conn.prepareStatement("SELECT * FROM food_items WHERE category_id = ?");
				foodStmt.setInt(1, categoryId);
				ResultSet foodRs = foodStmt.executeQuery();

				while (foodRs.next()) {
					int foodId = foodRs.getInt("food_id");
					String foodName = foodRs.getString("food_name");
					double price = foodRs.getDouble("price");

					Blob blob = foodRs.getBlob("photo");
					String base64Image = "";
					if (blob != null) {
						byte[] imageData = blob.getBytes(1, (int) blob.length());
						base64Image = Base64.getEncoder().encodeToString(imageData);
					}
				%>
				<div class="col text-center ">
					<img src="data:image/jpeg;base64,<%=base64Image%>"
						alt="<%=foodName%>" class="img-fluid mb-2"
						style="width: 100px; height: 100px;">
					<p><%=foodName%></p>
					<p class="text-muted">
						&#8377;<%=String.format("%.2f", price)%>
					</p>
					<button class="btn btn-primary add-to-cart" data-id="<%=foodId%>"
						data-name="<%=foodName%>" data-price="<%=price%>">
						<i class="fas fa-utensils"></i> Add to Plate
					</button>
				</div>
				<%
				}
				foodRs.close();
				foodStmt.close();
				%>
			</div>
			<%
			}
			rs.close();
			pstmt.close();
			conn.close();
			%>
		</div>
	</div>
</div>







<!-- Bootstrap JS -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- AJAX Script to Add Item to Cart -->
<script>
$(document).ready(function() {
    $("#checkoutButton").click(function() {
        $.ajax({
            url: "PlaceOrderServlet",
            type: "POST",
            success: function(response) {
                if (response.trim() === "login") {
                    Swal.fire({
                        icon: "warning",
                        title: "Not Logged In",
                        text: "Please log in to place an order.",
                        confirmButtonColor: "#3085d6"
                    });
                } else if (response.trim() === "empty") {
                    Swal.fire({
                        icon: "info",
                        title: "Cart is Empty",
                        text: "Add items before placing an order!",
                        confirmButtonColor: "#3085d6"
                    });
                } else if (response.trim() === "success") {
                    Swal.fire({
                        icon: "success",
                        title: "Order Placed!",
                        text: "Your order has been placed successfully.",
                        confirmButtonColor: "#28a745"
                    }).then(() => {
                        $("#cartModalBody").html("<p class='text-center text-success'>Order placed successfully!</p>");
                        $("#cartCount").text("0"); // Reset cart count
                    });
                } else {
                    Swal.fire({
                        icon: "error",
                        title: "Order Failed",
                        text: "Something went wrong. Please try again!",
                        confirmButtonColor: "#d33"
                    });
                }
            },
            error: function() {
                Swal.fire({
                    icon: "error",
                    title: "Server Error",
                    text: "Failed to connect. Please try again later!",
                    confirmButtonColor: "#d33"
                });
            }
        });
    });
});

</script>

</body>
</html>