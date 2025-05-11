<%@page import="com.restaurant.entities.Message"%>
<%@ page import="com.restaurant.entities.User"%>

<%
User u = (User) session.getAttribute("currentUser");
String currentPage = request.getRequestURI();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Panel - DigiDine</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<style type="text/css">
@import
	url('https://fonts.googleapis.com/css2?family=Signika:wght@300..700&display=swap')
	;

body {
	font-family: "Signika", sans-serif;
	font-optical-sizing: auto;
}
</style>
</head>
<body class="bg-black text-white">

	<nav class="navbar navbar-expand-lg navbar-dark bg-black">
		<div class="container-fluid">
			<a class="navbar-brand text-warning fw-bold" href="#">DigiDine</a>

			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav"
				aria-controls="navbarNav" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav ms-auto mb-2 mb-lg-0">
					<li class="nav-item"><a
						class="nav-link <%=currentPage.endsWith("home.jsp") ? "active bg-warning text-dark fw-bold" : ""%>"
						href="home.jsp">Home</a></li>
					<li class="nav-item"><a
						class="nav-link <%=currentPage.endsWith("generate_orders.jsp") ? "active bg-warning text-dark fw-bold" : ""%>"
						href="generate_orders.jsp">Generate Orders</a></li>
					<li class="nav-item"><a
						class="nav-link <%=currentPage.endsWith("online_order_management.jsp") ? "active bg-warning text-dark fw-bold" : ""%>"
						href="online_order_management.jsp">Online Order Management</a></li>
					<li class="nav-item"><a
						class="nav-link <%=currentPage.endsWith("order_history.jsp") ? "active bg-warning text-dark fw-bold" : ""%>"
						href="order_history.jsp">Order History</a></li>
					<li class="nav-item"><a
						class="nav-link <%=currentPage.endsWith("users.jsp") ? "active bg-warning text-dark fw-bold" : ""%>"
						href="users.jsp">Users</a></li>
					<li class="nav-item"><a
						class="nav-link <%=currentPage.endsWith("products.jsp") ? "active bg-warning text-dark fw-bold" : ""%>"
						href="products.jsp">Products</a></li>
					<li class="nav-item"><a
						class="nav-link <%=currentPage.endsWith("messages.jsp") ? "active bg-warning text-dark fw-bold" : ""%>"
						href="messages.jsp">Messages</a></li>

					<li class="nav-item">
						<!-- Profile Button -->
						<button class="btn btn-warning ms-3 d-flex align-items-center"
							data-bs-toggle="modal" data-bs-target="#profileModal">
							<i class="fa fa-user-circle fa-spin me-1"></i>
							<%=u.getName()%>
							(ADMIN)
						</button>
					</li>

					<li class="nav-item"><a class="nav-link text-danger fw-bold"
						href="../LogoutServlet">Logout <i class="fas fa-sign-out-alt"></i></a>
					</li>
				</ul>


			</div>
		</div>
	</nav>

	<!-- Profile Modal -->
	<div class="modal fade" id="profileModal" tabindex="-1"
		aria-labelledby="profileModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content bg-dark text-white">
				<div class="modal-header">
					<h5 class="modal-title" id="profileModalLabel">My Profile</h5>
					<button type="button" class="btn-close btn-close-white"
						data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">

					<!-- Profile Details -->
					<div id="profile-details">
						<table class="table table-dark table-striped">
							<tr>
								<td>Id:</td>
								<td><%=u != null ? u.getId() : "N/A"%></td>
							</tr>
							<tr>
								<td>Name:</td>
								<td><%=u != null ? u.getName() : "Guest"%></td>
							</tr>
							<tr>
								<td>Email:</td>
								<td><%=u != null ? u.getEmail() : "Not Logged In"%></td>
							</tr>
							<tr>
								<td>Gender:</td>
								<td><%=u != null ? u.getGender() : "N/A"%></td>
							</tr>
							<tr>
								<td>Address:</td>
								<td><%=u != null ? u.getAddress() : "N/A"%></td>
							</tr>
							<tr>
								<td>Registered On:</td>
								<td><%=u != null ? u.getDateTime().toString() : "N/A"%></td>
							</tr>
						</table>
					</div>

					<!-- Profile Edit -->
					<div id="profile-edit" style="display: none;">
						<h5>Edit Profile</h5>
						<form action="../UpdateProfileServlet" method="post">
							<div class="mb-2">
								<label>Name</label> <input type="text" class="form-control"
									name="user_name" value="<%=u != null ? u.getName() : ""%>">
							</div>
							<div class="mb-2">
								<label>Email</label> <input type="email" class="form-control"
									name="user_email" value="<%=u != null ? u.getEmail() : ""%>">
							</div>
							<div class="mb-2">
								<label>Mobile No</label> <input type="number"
									class="form-control" name="user_mobile"
									value="<%=u != null ? u.getMobileNumber() : ""%>">
							</div>
							<div class="mb-2">
								<label>Password</label> <input type="password"
									class="form-control" name="user_password"
									value="<%=u != null ? u.getPassword() : ""%>">
							</div>
							<div class="mb-2">
								<label>Gender</label> <input type="text" class="form-control"
									disabled
									value="<%=u != null ? u.getGender().toUpperCase() : "N/A"%>">
							</div>
							<div class="mb-2">
								<label>Address</label>
								<textarea class="form-control" name="user_address" rows="3"><%=u != null ? u.getAddress() : ""%></textarea>
							</div>
							<button type="submit" class="btn btn-primary">Save</button>
						</form>
					</div>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">Close</button>
					<button type="button" class="btn btn-primary"
						id="edit-profile-button">Edit Profile</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Alerts -->
	<%
	Message m = (Message) session.getAttribute("msg");
	if (m != null) {
	%>
	<div class="alert <%=m.getCssClass()%> text-center fs-5" role="alert">
		<%=m.getContent()%>
	</div>
	<%
	session.removeAttribute("msg");
	}
	%>

	<!-- Scripts -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

	<script>
		$(document).ready(function() {
			let editStatus = false;
			$('#edit-profile-button').click(function() {
				if (!editStatus) {
					$('#profile-details').hide();
					$('#profile-edit').show();
					$(this).text("Back");
				} else {
					$('#profile-details').show();
					$('#profile-edit').hide();
					$(this).text("Edit Profile");
				}
				editStatus = !editStatus;
			});
		});
	</script>