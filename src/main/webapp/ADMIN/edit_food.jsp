<%@page import="java.sql.*"%>
<%@page import="java.io.InputStream"%>
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
%>

<jsp:include page="include_header.jsp" />
<!-- SweetAlert2 CDN -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<%-- CHECK IF SUCCESS PARAMETER EXISTS --%>
<%
String success = request.getParameter("success");
String error = request.getParameter("error");
%>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        <%if ("true".equals(success)) {%>
            Swal.fire({
                title: "Success!",
                text: "Food item updated successfully.",
                icon: "success",
                confirmButtonColor: "#ffc107"
            }).then(() => {
                window.location.href = "edit_food.jsp"; // Refresh without query params
            });
        <%} else if (error != null) {%>
            Swal.fire({
                title: "Error!",
                text: "Failed to update food item.",
                icon: "error",
                confirmButtonColor: "#d33"
            });
        <%}%>
    });
</script>
<div class="container mt-5">
	<div class="card bg-black text-light shadow-lg border-0 rounded-4">
		<div class="card-header bg-warning text-dark text-center fw-bold fs-4">
			Edit Food Item</div>
		<div class="card-body p-4">

			<%
			Connection con = DBConnection.getConnection();
			%>

			<!-- 1️⃣ FORM TO SELECT CATEGORY -->
			<form method="post">
				<div class="mb-3">
					<label class="form-label text-warning fw-bold">Select
						Category</label> <select
						class="form-select bg-black text-light border border-light"
						name="category_id" required>
						<option value="">Select Category</option>
						<%
						try {
							String query = "SELECT category_id, category_name FROM categories";
							PreparedStatement ps = con.prepareStatement(query);
							ResultSet rs = ps.executeQuery();
							while (rs.next()) {
						%>
						<option value="<%=rs.getInt("category_id")%>"><%=rs.getString("category_name")%></option>
						<%
						}
						} catch (Exception e) {
						e.printStackTrace();
						}
						%>
					</select>
				</div>

				<div class="text-center">
					<button type="submit"
						class="btn btn-warning text-dark fw-semibold px-4">Select
						Category</button>
				</div>
			</form>

			<%
			int selectedCategory = 0;
			if (request.getParameter("category_id") != null) {
				selectedCategory = Integer.parseInt(request.getParameter("category_id"));
			%>

			<!-- 2️⃣ FORM TO SELECT FOOD ITEM -->
			<form method="post">
				<input type="hidden" name="category_id"
					value="<%=selectedCategory%>">
				<div class="mb-3 mt-4">
					<label class="form-label text-warning fw-bold">Select Food
						Item</label> <select
						class="form-select bg-black text-light border border-light"
						name="food_id" required>
						<option value="">Select Food Item</option>
						<%
						try {
							String foodQuery = "SELECT food_id, food_name FROM food_items WHERE category_id=?";
							PreparedStatement ps = con.prepareStatement(foodQuery);
							ps.setInt(1, selectedCategory);
							ResultSet rs = ps.executeQuery();
							while (rs.next()) {
						%>
						<option value="<%=rs.getInt("food_id")%>"><%=rs.getString("food_name")%></option>
						<%
						}
						} catch (Exception e) {
						e.printStackTrace();
						}
						%>
					</select>
				</div>

				<div class="text-center">
					<button type="submit"
						class="btn btn-warning text-dark fw-semibold px-4">Select
						Food</button>
				</div>
			</form>

			<%
			}

			int selectedFoodId = 0;
			if (request.getParameter("food_id") != null) {
			selectedFoodId = Integer.parseInt(request.getParameter("food_id"));
			try {
				String foodDetailsQuery = "SELECT * FROM food_items WHERE food_id=?";
				PreparedStatement ps = con.prepareStatement(foodDetailsQuery);
				ps.setInt(1, selectedFoodId);
				ResultSet rs = ps.executeQuery();
				if (rs.next()) {
			%>

			<!-- 3️⃣ FORM TO EDIT FOOD DETAILS -->
			<form action="../EditFood" method="post"
				enctype="multipart/form-data">
				<input type="hidden" name="food_id" value="<%=selectedFoodId%>">

				<div class="mb-3">
					<label class="form-label text-warning fw-bold">Food Name</label> <input
						type="text"
						class="form-control bg-black text-light border border-light placeholder-white"
						name="food_name" required value="<%=rs.getString("food_name")%>">
				</div>

				<div class="mb-3">
					<label class="form-label text-warning fw-bold">Description</label>
					<textarea
						class="form-control bg-black text-light border border-light placeholder-white"
						name="description" required><%=rs.getString("description")%></textarea>
				</div>

				<div class="mb-3">
					<label class="form-label text-warning fw-bold">Price (₹)</label> <input
						type="number" step="0.01"
						class="form-control bg-black text-light border border-light placeholder-white"
						name="price" required
						value="<%=String.format("%.2f", rs.getDouble("price"))%>">
				</div>

				<div class="mb-3">
					<label class="form-label text-warning fw-bold">Upload New
						Image</label> <input type="file"
						class="form-control bg-black text-light border border-light"
						name="photo" accept="image/*">
				</div>

				<div class="text-center">
					<button type="submit"
						class="btn btn-warning text-dark fw-semibold px-4">Update</button>
				</div>
			</form>

			<%
			}
			} catch (Exception e) {
			e.printStackTrace();
			}
			}
			%>

		</div>
	</div>
</div>

<jsp:include page="include_footer.jsp" />
