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
<div class="container mt-5"
	style="max-width: 40%; background-color: #000; padding: 20px; border-radius: 10px; color: #f8f9fa;">
	<h2 class="text-center text-light display-4">Generate Guest Order</h2>
	<form id="orderForm" action="../GenerateOrderServlet" method="post">
		<div class="mb-3">
			<label for="customerName" class="form-label text-light">Customer
				Name:</label> <input type="text"
				class="form-control bg-black text-white border-secondary"
				id="customerName" name="customer_name" required>
		</div>
		<div class="mb-3">
			<label for="mobileNumber" class="form-label text-light">Mobile
				Number:</label> <input type="text"
				class="form-control bg-black text-white border-secondary"
				id="mobileNumber" name="mobile_number" required>
		</div>
		<div class="mb-3">
			<label for="paymentMethod" class="form-label text-light">Payment
				Method:</label> <select
				class="form-control bg-black text-white border-secondary"
				id="paymentMethod" name="payment_method" required>
				<option value="Cash">Cash</option>
				<option value="Online">Online</option>
			</select>
		</div>
		<button type="button" class="btn btn-outline-light w-100"
			data-bs-toggle="modal" data-bs-target="#foodItemModal">Select
			Food Items</button>
		<div class="mt-3 text-end">
			<strong>Total Price:</strong> <span id="totalPrice"
				class="text-warning">Rs.0.00</span>
		</div>
		<button type="submit" class="btn btn-warning text-black w-100 mt-3">Place
			Order</button>
	</form>
</div>

<!-- Modal for Food Items -->
<div class="modal fade" id="foodItemModal" tabindex="-1"
	aria-labelledby="foodItemModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content bg-black border border-light text-white">
			<div class="modal-header border-secondary">
				<h5 class="modal-title" id="foodItemModalLabel">Select Food
					Items</h5>
				<button type="button" class="btn-close btn-close-white"
					data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<div class="row">
					<%
					try (Connection conn = DBConnection.getConnection()) {
						String sql = "SELECT c.category_name, f.food_id, f.food_name, f.price FROM food_items f "
						+ "INNER JOIN categories c ON f.category_id = c.category_id " + "ORDER BY c.category_name, f.food_name";
						PreparedStatement pstmt = conn.prepareStatement(sql);
						ResultSet rs = pstmt.executeQuery();

						String currentCategory = ""; // Store the last printed category

						while (rs.next()) {
							String categoryName = rs.getString("category_name");
							int foodId = rs.getInt("food_id");
							String foodName = rs.getString("food_name");
							double price = rs.getDouble("price");

							// Print category name only when it changes
							if (!categoryName.equals(currentCategory)) {
						if (!currentCategory.isEmpty()) {
							out.println("</div>"); // Close the previous row
						}
						out.println("<h5 class='mt-3 text-warning'>" + categoryName + "</h5>");
						out.println("<div class='row'>"); // Start new row for this category
						currentCategory = categoryName;
							}
					%>
					<div class="col-md-4 mb-3">
						<div class="card bg-dark text-white border-secondary shadow-sm">
							<div class="card-body text-center">
								<h6 class="card-title text-light"><%=foodName%></h6>
								<p class="card-text text-white fw-bold">
									&#8377;<%=String.format("%.2f", price)%>
								</p>
								<div class="d-flex justify-content-center align-items-center">
									<input type="number"
										class="form-control form-control-sm text-center me-2 bg-secondary text-white border-dark"
										id="quantity_<%=foodId%>" value="1" min="1"
										style="width: 60px;">
									<button class="btn btn-sm btn-warning text-dark addItemButton"
										data-food-id="<%=foodId%>" data-food-name="<%=foodName%>"
										data-price="<%=price%>">Add</button>
								</div>
							</div>
						</div>
					</div>
					<%
					}
					out.println("</div>"); // Close the last category row
					} catch (Exception e) {
					out.println("<p class='text-danger'>Error loading food items</p>");
					e.printStackTrace();
					}
					%>
				</div>
			</div>
			<div class="modal-footer border-secondary">
				<button type="button" class="btn btn-outline-light"
					data-bs-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>


<jsp:include page="include_footer.jsp" />

<script>
	let totalPrice = 0; // To keep track of the total price

	$(document)
			.ready(
					function() {
						$(".addItemButton")
								.on(
										"click",
										function() {
											const foodItemId = $(this).data(
													"food-id");
											const price = parseFloat($(this)
													.data("price"));
											const quantity = parseInt($(
													"#quantity_" + foodItemId)
													.val());

											if (foodItemId && !isNaN(price)
													&& quantity > 0) {
												const itemTotal = price
														* quantity; // Calculate total for the current item
												totalPrice += itemTotal; // Update the overall total price

												// Check if the item already exists, and prevent duplicate hidden inputs
												if ($(`input[name='food_item_id'][value='${foodItemId}']`).length === 0) {
													$('<input>').attr({
														type : 'hidden',
														name : 'food_item_id',
														value : foodItemId
													}).appendTo('#orderForm');
													$('<input>').attr({
														type : 'hidden',
														name : 'quantity',
														value : quantity
													}).appendTo('#orderForm');
												}

												// Update the total price display
												$("#totalPrice")
														.text(
																"₹"
																		+ totalPrice
																				.toFixed(2));

												// Reset the specific quantity input
												$("#quantity_" + foodItemId)
														.val(1);

												// Show SweetAlert notification (small toast)
												Swal
														.fire({
															position : "top-end",
															icon : "success",
															title : "Item added successfully!",
															showConfirmButton : false,
															timer : 1200,
															toast : true
														});
											} else {
												Swal
														.fire({
															icon : "error",
															title : "Oops...",
															text : "Please select a valid food item and enter a proper quantity.",
															confirmButtonColor : "#dc3545"
														});
											}
										});

						// Handle form submission
						$("#orderForm")
								.on(
										"submit",
										function(event) {
											event.preventDefault(); // Prevent default form submission

											// Ensure no fields are empty before sending
											if (!$("#customerName").val()
													|| !$("#mobileNumber")
															.val()
													|| !$("#paymentMethod")
															.val()) {
												Swal
														.fire({
															icon : "warning",
															title : "Missing Fields",
															text : "Please fill out all fields before placing the order.",
															confirmButtonColor : "#ffc107"
														});
												return; // Prevent submission if required data is missing
											}

											// AJAX request to place the order
											$
													.ajax({
														url : "../GenerateOrderServlet",
														type : "POST",
														data : $(this)
																.serialize(), // Serialize the form data
																success: function(data) {
																    if (data.trim().startsWith("success:")) {
																        const orderId = data.trim().split(":")[1];

																        Swal.fire({
																            icon: "success",
																            title: "Order Placed!",
																            text: "Guest order submitted successfully.",
																            confirmButtonColor: "#28a745"
																        }).then(() => {
																            window.location.href = "../generate-bill.jsp?guest_order_id=" + orderId;
																        });

																        // Reset form and price
																        $("#orderForm")[0].reset();
																        totalPrice = 0;
																        $("#totalPrice").text("₹0.00");
																        $('#orderForm input[type=hidden]').remove();
																    } else {
																        Swal.fire({
																            icon: "error",
																            title: "Error!",
																            text: "Failed to place order. Please try again.",
																            confirmButtonColor: "#dc3545"
																        });
																    }
																}
,
														error : function(xhr,
																status, error) {
															Swal
																	.fire({
																		icon : "error",
																		title : "Error!",
																		text : "Something went wrong.",
																		confirmButtonColor : "#dc3545"
																	});
														}
													});
										});
					});
</script>
