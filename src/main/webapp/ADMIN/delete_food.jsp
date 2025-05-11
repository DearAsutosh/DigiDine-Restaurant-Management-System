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
%>

<jsp:include page="include_header.jsp" />

<!-- SweetAlert2 CDN -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div class="container mt-5">
	<div class="card bg-black text-light shadow-lg border-0 rounded-4">
		<div class="card-header bg-danger text-light text-center fw-bold fs-4">
			Delete Food Item</div>
		<div class="card-body p-4">
			<form action="../DeleteFoodServlet" method="post"
				onsubmit="confirmDelete(event);">
				<div class="mb-3">
					<label class="form-label text-warning fw-bold">Select Food
						Item</label> <select
						class="form-select bg-black text-light border border-light"
						name="food_id" id="food_id" required>
						<option value="">Select Food Item to Delete...</option>
						<%
						// Load food items from database
						try (Connection con = DBConnection.getConnection()) {
							String query = "SELECT food_id, food_name FROM food_items";
							PreparedStatement stmt = con.prepareStatement(query);
							ResultSet rs = stmt.executeQuery();
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
						class="btn btn-danger text-light fw-semibold px-4">Delete</button>
				</div>
			</form>
		</div>
	</div>
</div>

<script>
function confirmDelete(event) {
    event.preventDefault(); // Stop form from submitting immediately

    Swal.fire({
        title: "Are you sure?",
        text: "This action cannot be undone!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#3085d6",
        confirmButtonText: "Yes, delete it!"
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({
                title: "Deleted!",
                text: "Food item has been deleted.",
                icon: "success",
                timer: 1500, // Auto-close after 1.5 seconds
                showConfirmButton: false
            }).then(() => {
                event.target.submit(); // Submit the form after showing the success alert
            });
        }
    });
}
</script>


<jsp:include page="include_footer.jsp" />
