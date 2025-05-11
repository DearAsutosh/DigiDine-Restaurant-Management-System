<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.restaurant.util.DBConnection"%>
<%@page import="java.sql.Connection"%>
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
<style>
/* Ensure placeholders are white */
::placeholder {
	color: white !important;
	opacity: 1 !important;
}
</style>
<jsp:include page="include_header.jsp" />

<div class="container mt-5">
	<div class="card bg-black text-light shadow-lg border-0 rounded-4">
		<div class="card-header bg-warning text-dark text-center fw-bold fs-4">
			Add Food Item</div>
		<div class="card-body p-4">
			<form id="foodForm" enctype="multipart/form-data">
				<div class="mb-3">
					<label class="form-label text-warning fw-bold">Food Name</label> <input
						type="text"
						class="form-control bg-black text-light border border-light placeholder-white"
						name="food_name" required placeholder="Enter food name">
				</div>

				<div class="mb-3">
					<label class="form-label text-warning fw-bold">Category</label> <select
						class="form-select bg-black text-light border border-light"
						name="category_id" required>
						<option value="">Select Category</option>
						<%
						try (Connection conn = DBConnection.getConnection()) {
							String query = "SELECT category_id, category_name FROM categories";
							PreparedStatement pstmt = conn.prepareStatement(query);
							ResultSet rs = pstmt.executeQuery();
							while (rs.next()) {
								int id = rs.getInt("category_id");
								String name = rs.getString("category_name");
						%>
						<option value="<%=id%>"><%=name%></option>
						<%
						}
						} catch (Exception e) {
						out.println("<option value=''>Error loading categories</option>");
						}
						%>
					</select>
				</div>

				<div class="mb-3">
					<label class="form-label text-warning fw-bold">Price (₹)</label> <input
						type="number" step="0.01"
						class="form-control bg-black text-light border border-light placeholder-white"
						name="price" required placeholder="Enter price">
				</div>
				<!-- Description -->
				<div class="mb-3">
					<label class="form-label text-warning fw-bold">Description</label>
					<textarea
						class="form-control bg-black text-light border border-light placeholder-white"
						name="description" rows="3" placeholder="Enter food description"></textarea>
				</div>
				<div class="mb-3">
					<label class="form-label text-warning fw-bold">Upload Image</label>
					<input type="file"
						class="form-control bg-black text-light border border-light"
						name="photo" accept="image/*">
				</div>

				<div class="text-center">
					<button type="submit"
						class="btn btn-warning text-dark fw-semibold px-4">Submit</button>
				</div>
			</form>
		</div>
	</div>
</div>

<!-- SweetAlert & jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    $(document).ready(function () {
        $("#foodForm").submit(function (e) {
            e.preventDefault(); // Prevent default form submission

            var formData = new FormData(this); // Create FormData object

            $.ajax({
                type: "POST",
                url: "../UploadFood",
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    if (response.trim() === "success") {
                        Swal.fire({
                            title: "Success!",
                            text: "Item added successfully",
                            icon: "success",
                            confirmButtonColor: "#ffc107",
                            confirmButtonText: "OK"
                        }).then(() => {
                            $("#foodForm")[0].reset(); // Reset form fields
                        });
                    } else {
                        Swal.fire({
                            title: "Error!",
                            text: "Failed to add item",
                            icon: "error",
                            confirmButtonColor: "#dc3545",
                        });
                    }
                },
                error: function () {
                    Swal.fire({
                        title: "Error!",
                        text: "Something went wrong!",
                        icon: "error",
                        confirmButtonColor: "#dc3545",
                    });
                }
            });
        });
    });
</script>

<jsp:include page="include_footer.jsp" />
