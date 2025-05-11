<%@page import="com.restaurant.entities.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
User u = (User) session.getAttribute("currentUser");
String role = (String) session.getAttribute("role");

if (u == null || !"admin".equals(role)) {
	response.sendRedirect("../login");
	return;
}
%>

<jsp:include page="include_header.jsp" />

<div class="container mt-5">
	<h2 class="text-warning text-center fw-bold mb-4">Product
		Management</h2>
	<div class="row g-4">
		<!-- Explore the Menu -->
		<div class="col-md-6 col-lg-3">
			<a href="explore_menu.jsp" class="text-decoration-none">
				<div
					class="card bg-black text-light text-center shadow-lg border rounded-4 p-4">
					<i class="fas fa-utensils fa-3x text-warning"></i>
					<h4 class="mt-3">Explore the Menu</h4>
				</div>
			</a>
		</div>	
		<!-- Add Food Item -->
		<div class="col-md-6 col-lg-3">
			<a href="add_food.jsp" class="text-decoration-none">
				<div
					class="card bg-black text-light text-center shadow-lg border rounded-4 p-4">
					<i class="fas fa-plus-circle fa-3x text-warning"></i>
					<h4 class="mt-3">Add Food Item</h4>
				</div>
			</a>
		</div>

		<!-- Edit Food Item -->
		<div class="col-md-6 col-lg-3">
			<a href="edit_food.jsp" class="text-decoration-none">
				<div
					class="card bg-black text-light text-center shadow-lg border rounded-4 p-4">
					<i class="fas fa-edit fa-3x text-warning"></i>
					<h4 class="mt-3">Edit Food Item</h4>
				</div>
			</a>
		</div>

		<!-- Delete Food Item -->
		<div class="col-md-6 col-lg-3">
			<a href="delete_food.jsp" class="text-decoration-none">
				<div
					class="card bg-black text-light text-center shadow-lg border rounded-4 p-4">
					<i class="fas fa-trash-alt fa-3x text-danger"></i>
					<h4 class="mt-3">Delete Food Item</h4>
				</div>
			</a>
		</div>
	</div>
</div>

<jsp:include page="include_footer.jsp" />
