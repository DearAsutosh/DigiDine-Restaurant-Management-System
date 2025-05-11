<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Order History</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<%@ include file="include_header.jsp"%>
</head>
<body class="bg-dark text-light">

	<div class="container py-5">
		<h2 class="mb-4 text-warning">Order History</h2>

		<div class="btn-group mb-3">
			<button id="onlineOrderBtn" class="btn btn-outline-warning">Online
				Order History</button>
			<button id="offlineOrderBtn" class="btn btn-outline-info">Offline
				Order History</button>
		</div>

		<!-- AJAX content goes here -->
		<div id="orderHistoryContainer" class="mt-4"></div>
	</div>

	<script>
		$(document)
				.ready(
						function() {
							loadOrders("online"); // Default load online orders

							$("#onlineOrderBtn").click(function() {
								loadOrders("online");
							});

							$("#offlineOrderBtn").click(function() {
								loadOrders("offline");
							});

							function loadOrders(type) {
								$
										.ajax({
											url : "orderHistoryData.jsp",
											type : "GET",
											data : {
												type : type
											},
											success : function(data) {
												$("#orderHistoryContainer")
														.html(data);
											},
											error : function() {
												$("#orderHistoryContainer")
														.html(
																"<div class='text-danger text-center'>Failed to load order history.</div>");
											}
										});
							}
						});
	</script>
</body>
</html>
