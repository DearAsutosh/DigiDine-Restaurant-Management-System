<%@page import="com.restaurant.entities.Message"%>
<%@page import="com.restaurant.entities.User"%>
<%@page import="java.sql.*"%>
<%@page import="com.restaurant.util.DBConnection"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
User u = (User) session.getAttribute("currentUser");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>DigiDine</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="style.css">
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-black">
		<div class="container py-2">
			<a class="navbar-brand text-warning font-bold" href="#">DigiDine</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav ms-auto">
					<li class="nav-item"><a class="nav-link" href="home">Home</a></li>
					<li class="nav-item"><a class="nav-link" href="menu">Menu</a></li>
					<li class="nav-item"><a class="nav-link" href="about">About</a></li>
					<li class="nav-item"><a class="nav-link" href="contact">Contact</a></li>

					<%
					if (u != null) {
					%>
					<%
					int cartCount = 0;
					try {
						Connection conn = DBConnection.getConnection();
						PreparedStatement pstmt = conn.prepareStatement("SELECT SUM(quantity) FROM cart WHERE user_id = ?");
						pstmt.setInt(1, u.getId());
						ResultSet rs = pstmt.executeQuery();
						if (rs.next()) {
							cartCount = rs.getInt(1); // Fetch cart count from database
						}
						rs.close();
						pstmt.close();
						conn.close();
					} catch (Exception e) {
						e.printStackTrace();
					}
					%>
					<li class="nav-item px-2"><a class="btn btn-outline-info"
						href="#" data-bs-toggle="modal"
						data-bs-target="#orderHistoryModal"> <i class="fas fa-receipt"></i>
							Order History
					</a></li>

					<li class="nav-item px-2"><a
						class="btn btn-outline-light position-relative" href="#"
						data-bs-toggle="modal" data-bs-target="#cartModal"> <i
							class="fas fa-shopping-cart"></i> Cart <span
							class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
							id="cartCount"> <%=cartCount%>
						</span>
					</a></li>

					<li class="nav-item px-2">
						<div class="btn btn-warning" data-bs-toggle="modal"
							data-bs-target="#profileModal">
							Hi,
							<%=u.getName()%>
						</div>
					</li>
					<li class="nav-item px-2"><a class="btn btn-danger"
						href="LogoutServlet">Logout</a></li>
					<%
					} else {
					%>
					<li class="nav-item px-2"><a class="btn btn-warning"
						href="login">Login!</a></li>
					<%
					}
					%>
				</ul>
			</div>
		</div>
	</nav>


	<!-- Order History Modal -->
	<div class="modal fade" id="orderHistoryModal" tabindex="-1"
		aria-labelledby="orderHistoryModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content bg-dark text-white">
				<div class="modal-header">
					<h5 class="modal-title" id="orderHistoryModalLabel">Your Order
						History</h5>
					<button type="button" class="btn-close text-light"
						data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body" id="orderHistoryContent">
					<p class="text-center text-muted">Loading your orders...</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>


	<!-- Cart Modal -->
	<div class="modal fade" id="cartModal" tabindex="-1"
		aria-labelledby="cartModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content bg-dark text-white">
				<div class="modal-header">
					<h5 class="modal-title" id="cartModalLabel">Your Cart</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body" id="cartModalBody">
					<p class='text-center text-muted'>Loading cart items...</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">Close</button>
					<button id="checkoutBtn" class="btn btn-success">Proceed
						to Checkout</button>
				</div>
			</div>
		</div>
	</div>


	<!-- Profile Modal -->
	<div class="modal fade" id="profileModal" tabindex="-1"
		aria-labelledby="profileModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content bg-dark text-white">
				<div class="modal-header">
					<h1 class="modal-title fs-5" id="profileModalLabel">My Profile</h1>
					<button type="button" class="btn-close text-light"
						data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body bg-dark">
					<div id="profile-details">
						<!-- Profile Details Table -->
						<table class="table table-dark table-borderless">
							<tbody>
								<tr>
									<td class="text-info">Id :</td>
									<td class="text-light"><%=(u != null) ? u.getId() : "N/A"%></td>
								</tr>
								<tr>
									<td class="text-info">Name :</td>
									<td class="text-light"><%=(u != null) ? u.getName() : "Guest"%></td>
								</tr>
								<tr>
									<td class="text-info">Email :</td>
									<td class="text-light"><%=(u != null) ? u.getEmail() : "Not Logged In"%></td>
								</tr>
								<tr>
									<td class="text-info">Gender :</td>
									<td class="text-light"><%=(u != null) ? u.getGender() : "N/A"%></td>
								</tr>
								<tr>
									<td class="text-info">Address :</td>
									<td class="text-light"><%=(u != null) ? u.getAddress() : "N/A"%></td>
								</tr>
								<tr>
									<td class="text-info">Registered on :</td>
									<td class="text-light"><%=(u != null) ? u.getDateTime().toString() : "N/A"%></td>
								</tr>
							</tbody>
						</table>
					</div>



					<!--============== profile edit ==============-->
					<div id="profile-edit" style="display: none;">
						<h3 class="mt-2">Please Edit Carefully !</h3>
						<form action="UpdateProfileServlet" method="post">
							<!-- Profile Edit Table -->
							<table class="table table-dark table-bordered">
								<tr>
									<td class="text-info">Id :</td>
									<td class="text-light"><%=(u != null) ? u.getId() : "N/A"%></td>
								</tr>
								<tr>
									<td class="text-info">Name :</td>
									<td><input
										class="form-control bg-dark text-light border-secondary"
										type="text" name="user_name"
										value="<%=(u != null) ? u.getName() : ""%>"></td>
								</tr>
								<tr>
									<td class="text-info">Email :</td>
									<td><input
										class="form-control bg-dark text-light border-secondary"
										type="email" name="user_email"
										value="<%=(u != null) ? u.getEmail() : ""%>"></td>
								</tr>
								<tr>
									<td class="text-info">Mobile No:</td>
									<td><input
										class="form-control bg-dark text-light border-secondary"
										type="number" name="user_mobile"
										value="<%=(u != null) ? u.getMobileNumber() : "N/A"%>"></td>
								</tr>
								<tr>
									<td class="text-info">Password :</td>
									<td><input
										class="form-control bg-dark text-light border-secondary"
										type="password" name="user_password"
										value="<%=(u != null) ? u.getPassword() : ""%>"></td>
								</tr>
								<tr>
									<td class="text-info">Gender :</td>
									<td class="text-light"><%=(u != null) ? u.getGender().toUpperCase() : "N/A"%></td>
								</tr>
								<tr>
									<td class="text-info">Address :</td>
									<td><textarea rows="3"
											class="form-control bg-dark text-light border-secondary"
											name="user_address"><%=(u != null) ? u.getAddress() : ""%></textarea></td>
								</tr>
							</table>

							<div class="container">
								<button type="submit" class="btn btn-primary">Save</button>
							</div>
						</form>
					</div>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">Close</button>
					<button type="button" class="btn btn-primary"
						id="edit-profile-button">Edit Profile</button>
					<button type="button" class="btn btn-success" id="saveProfileBtn"
						style="display: none;">Save Changes</button>
				</div>
			</div>
		</div>
	</div>


	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
        $(document).ready(function () {
        	
        	
        	// Load Order History on Modal Open
        	$('#orderHistoryModal').on('show.bs.modal', function () {
        	    $.ajax({
        	        url: 'LoadOrderHistoryServlet',
        	        type: 'GET',
        	        success: function (response) {
        	            $('#orderHistoryContent').html(response);
        	        },
        	        error: function () {
        	            $('#orderHistoryContent').html('<p class="text-danger">Failed to load order history.</p>');
        	        }
        	    });
        	});

            $("#checkoutBtn").click(function () {
                $.ajax({
                    url: "PlaceOrderServlet",
                    type: "POST",
                    success: function (response) {
                        if (response.trim() === "empty") {
                            Swal.fire("Oops!", "Your cart is empty!", "warning");
                        } else if (response.trim() === "success") {
                            Swal.fire({
                                icon: "success",
                                title: "Success!",
                                text: "Your order has been placed.",
                                footer: "Please contact Admin to Confirm the Order.🙂"
                            }).then(() => {
                                location.reload(); // Reload page to update cart
                            });
                        } else {
                            Swal.fire("Error!", "Failed to place order. Try again!", "error");
                        }
                    },
                    error: function () {
                        Swal.fire("Error!", "Something went wrong.", "error");
                    }
                });
            });

            $(".add-to-cart").click(function () {
                var foodId = $(this).data("id");

                $.ajax({
                    url: "AddToCartServlet",
                    type: "POST",
                    data: {
                        food_id: foodId
                    },
                    success: function (response) {
                        if (response.trim() === "login") {
                            Swal.fire({
                                icon: "warning",
                                title: "Not Logged In",
                                text: "Please log in to add items to your cart!",
                                confirmButtonColor: "#3085d6"
                            });
                        } else {
                            // Update cart count dynamically
                            $("#cartCount").text(response.trim());

                            // Small SweetAlert notification
                            Swal.fire({
                                toast: true,
                                position: "top-end",
                                icon: "success",
                                title: "Added to Cart",
                                showConfirmButton: false,
                                timer: 2000,
                                customClass: {
                                    popup: 'small-toast' // Apply custom styling
                                }
                            });

                            // Load updated cart items in modal
                            loadCartItems();
                        }
                    },
                    error: function () {
                        Swal.fire({
                            icon: "error",
                            title: "Failed to Add",
                            text: "Something went wrong, please try again!",
                            confirmButtonColor: "#d33"
                        });
                    }
                });
            });

            // Function to Load Cart Items in Modal
            function loadCartItems() {
                $.ajax({
                    url: "LoadCartServlet",
                    type: "GET",
                    success: function (response) {
                        $("#cartModalBody").html(response); // Update modal with cart items
                    },
                    error: function () {
                        $("#cartModalBody").html("<p class='text-danger'>Failed to load cart items.</p>");
                    }
                });
            }

            // Load cart when modal is opened
            $("#cartModal").on("show.bs.modal", function () {
                loadCartItems();
            });
        });
    </script>


	<script>
        $(document).ready(() => {
            let editStatus = false;
            $('#edit-profile-button').click(() => {
                if (editStatus === false) {
                    $('#profile-details').hide();
                    $('#profile-edit').show();
                    editStatus = true;
                    $('#edit-profile-button').text("Back");
                } else {
                    $('#profile-details').show();
                    $('#profile-edit').hide();
                    editStatus = false;
                    $('#edit-profile-button').text("Edit");
                }
            }
            )
        });
    </script>
	<script type="text/javascript">// Update Quantity (+/-) inside Cart Modal
	$(document).on("click", ".update-qty", function () {
	    const foodId = $(this).data("id");
	    const action = $(this).data("action");

	    $.ajax({
	        url: "UpdateCartQuantityServlet",
	        type: "POST",
	        data: { food_id: foodId, action: action },
	        success: function (response) {
	            if (response.trim() === "login") {
	                Swal.fire("Please login to update cart.");
	            } else if (response.trim() === "error") {
	                Swal.fire("Error!", "Could not update cart.", "error");
	            } else {
	                // Update cart count
	                $("#cartCount").text(response.trim());

	                // Reload just the quantity or remove the item
	                let qtySpan = $("#qty-" + foodId);
	                let currentQty = parseInt(qtySpan.text());

	                if (action === "increase") {
	                    qtySpan.text(currentQty + 1);
	                } else if (action === "decrease") {
	                    if (currentQty - 1 <= 0) {
	                        $("#cart-item-" + foodId).remove(); // Remove from UI
	                    } else {
	                        qtySpan.text(currentQty - 1);
	                    }
	                }

	                // Refresh total price only
	                loadCartTotalOnly();
	            }
	        },
	        error: function () {
	            Swal.fire("Error!", "Something went wrong.", "error");
	        }
	    });
	});

	function loadCartTotalOnly() {
	    $.ajax({
	        url: "LoadCartServlet",
	        type: "GET",
	        success: function (response) {
	            // Extract the total price from the response
	            const match = response.match(/id='total-amount'[^>]*>(.*?)<\/span>/);
	            if (match && match[1]) {
	                $("#total-amount").text(match[1]);
	            }
	        }
	    });
	}

</script>

	<%
	Message m = (Message) session.getAttribute("msg");
	if (m != null) {
	%>
	<div class="alert <%=m.getCssClass()%> text-center fs-4" role="alert">
		<%=m.getContent()%>
	</div>
	<%
	session.removeAttribute("msg");
	}
	%>