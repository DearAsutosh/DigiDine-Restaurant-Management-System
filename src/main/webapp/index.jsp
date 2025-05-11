<%@page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@include file="include_header.jsp"%>
<!-- Hero Section -->
<header class="hero">
	<div class="container text-center">
		<h1 class="display-4 mb-4">Your cravings called… Let’s feed them!</h1>
		<%
		if (u == null) {
		%>
		<a href="menu"><button class="btn btn-outline-light btn-lg">Explore
				Menu 😋</button></a> <a href="register"><button
				class="btn btn-outline-light btn-lg">
				<i class="fa fa-user-plus"></i> Start! It's free
			</button></a>
		<%
		} else {
		%>
		<a href="menu"><button
				class="btn btn-outline-light btn-lg rounded">Explore Menu
				😋</button></a>
		<%
		}
		%>
	</div>
</header>


<!-- About Section -->
<section class="section">
	<div class="container">
		<!-- First Row -->
		<div class="row align-items-center">
			<div class="col-md-6">
				<div class=" text-white p-5" style="max-width: 800px;">
					<h6>ABOUT US</h6>
					<h2 class="display-5">We Invite You to Visit Our DigiDine !</h2>
					<p>Where Efficiency served on every plate !</p>
					<button class="btn btn-warning">Read More</button>
				</div>
			</div>
			<div class="col-md-6">
				<img
					src="https://images.ctfassets.net/pdf29us7flmy/R2CvQwSAB5dXyOzRIPQFI/3c0fa14cc647c5f48647330c88022230/GettyImages-143922758_optimized.jpg"
					class="img-fluid" alt="Chef at work">
			</div>
		</div>

		<!-- Second Row -->
		<div class="row align-items-center">
			<div class="col-md-6 ">
				<img
					src="https://www.personneltoday.com/wp-content/uploads/sites/8/2019/04/chef-working-conditions.jpg"
					class="img-fluid" alt="Chef cooking">
			</div>
			<div class="col-md-6 d-flex justify-content-end">
				<div class=" text-white p-5" style="max-width: 800px;">
					<h6>MENU</h6>
					<h2 class="display-5">A feast of flavours awaits !</h2>
					<p>Where you can enjoy authentic food and get a rich and
						diverse culinary experience.</p>
					<button class="btn btn-warning">Read More</button>
				</div>
			</div>
		</div>

		<!-- Third Row -->
		<div class="row  align-items-center">
			<div class="col-md-6">
				<div class=" text-white p-5" style="max-width: 700px;">
					<h6>OUR TEAM</h6>
					<h2 class="display-5">Use the Tips & Recipes of Our Cooks</h2>
					<p>Highlights the special menu, tips for cooking, or shared
						recipes from our expert chefs !!</p>
					<button class="btn btn-warning">Read More</button>
				</div>
			</div>
			<div class="col-md-6">
				<img
					src="https://culinarylabschool.com/wp-content/uploads/2019/08/013119.CulinaryLab.004.jpg"
					class="img-fluid" alt="Barista at work">
			</div>
		</div>
	</div>
</section>



<!-- Features Section -->
<section class="container-float bg-dark text-white py-5">
	<div class="container">
		<div class="row align-items-center">
			<!-- Added align-items-center -->
			<div class="col-md-6 text-md-center text-center">
				<h4 class="fw-bold display-5">Working Hours</h4>
				<button class="btn btn-warning mt-3">Book a Table</button>
			</div>
			<div class="col-md-6">
				<div class="text-white text-center p-4 rounded">
					<p class="mb-2">
						<strong class="text-warning">Sunday to Tuesday</strong><br>09:00
						AM - 10:00 PM
					</p>
					<p class="mb-0">
						<strong class="text-warning">Friday to Saturday</strong><br>09:00
						AM - 10:00 PM
					</p>
				</div>
			</div>
		</div>
	</div>
</section>

<!-- Testimonials -->
<section class="container text-white text-center py-5">
	<h6 class="text-warning">FEATURES</h6>
	<h2 class="display-4">Why people choose us?</h2>
	<p class="text-light pt-3 w-50 mx-auto">Exquisite flavours, quality
		ingredients, chef's expertise, warm hospitality, impeccable service,
		ambiance and comfort, customization, and most importantly, passion for
		food.</p>

	<!-- Bootstrap Carousel -->
	<div id="testimonialCarousel" class="carousel slide mt-5"
		data-bs-ride="carousel">
		<div class="carousel-inner">

			<div class="carousel-item active">
				<div class="card bg-dark text-white p-4 border-0 mx-auto"
					style="max-width: 600px;">
					<div class="position-relative">
						<div
							class="position-absolute top-0 start-50 translate-middle bg-black rounded-circle p-2">
							<i class="fa fa-quote-left text-warning"></i>
						</div>
					</div>
					<p class="mt-4">"Lorem ipsum dolor sit amet consectetur.
						Suspendisse aliquet tellus adipiscing condimentum."</p>
					<div class="text-warning mb-2">★★★★☆</div>
					<strong>John</strong>
					<p class="text-muted">Business Man</p>
				</div>
			</div>

			<div class="carousel-item">
				<div class="card bg-dark text-white p-4 border-0 mx-auto"
					style="max-width: 600px;">
					<div class="position-relative">
						<div
							class="position-absolute top-0 start-50 translate-middle bg-black rounded-circle p-2">
							<i class="fa fa-quote-left text-danger"></i>
						</div>
					</div>
					<p class="mt-4">"Lorem ipsum dolor sit amet consectetur.
						Suspendisse aliquet tellus adipiscing condimentum."</p>
					<div class="text-danger mb-2">★★★☆☆</div>
					<strong>Emily</strong>
					<p class="text-muted">Entrepreneur</p>
				</div>
			</div>

			<div class="carousel-item">
				<div class="card bg-dark text-white p-4 border-0 mx-auto"
					style="max-width: 600px;">
					<div class="position-relative">
						<div
							class="position-absolute top-0 start-50 translate-middle bg-black rounded-circle p-2">
							<i class="fa fa-quote-left text-pink"></i>
						</div>
					</div>
					<p class="mt-4">"Lorem ipsum dolor sit amet consectetur.
						Suspendisse aliquet tellus adipiscing condimentum."</p>
					<div class="text-pink mb-2">★★★★★</div>
					<strong>Michael</strong>
					<p class="text-muted">CEO</p>
				</div>
			</div>

		</div>

		<!-- Carousel Controls -->
		<button class="carousel-control-prev" type="button"
			data-bs-target="#testimonialCarousel" data-bs-slide="prev">
			<span class="carousel-control-prev-icon" aria-hidden="true"></span>
		</button>
		<button class="carousel-control-next" type="button"
			data-bs-target="#testimonialCarousel" data-bs-slide="next">
			<span class="carousel-control-next-icon" aria-hidden="true"></span>
		</button>

		<!-- Pagination Dots -->
		<div class="carousel-indicators">
			<button type="button" data-bs-target="#testimonialCarousel"
				data-bs-slide-to="0" class="active"></button>
			<button type="button" data-bs-target="#testimonialCarousel"
				data-bs-slide-to="1"></button>
			<button type="button" data-bs-target="#testimonialCarousel"
				data-bs-slide-to="2"></button>
		</div>
	</div>
</section>



<section class="container text-white text-center py-5">
	<div class="row">
		<div class="col-md-3">
			<h2 class="fw-bold">
				1287<span class="text-warning">+</span>
			</h2>
			<p class="text-light">VISITORS DAILY</p>
		</div>
		<div class="col-md-3">
			<h2 class="fw-bold">
				578<span class="text-warning">+</span>
			</h2>
			<p class="text-light">DELIVERIES MONTHLY</p>
		</div>
		<div class="col-md-3">
			<h2 class="fw-bold">
				1440<span class="text-warning">+</span>
			</h2>
			<p class="text-light">POSITIVE FEEDBACK</p>
		</div>
		<div class="col-md-3">
			<h2 class="fw-bold">
				40<span class="text-warning">+</span>
			</h2>
			<p class="text-light">AWARDS AND HONORS</p>
		</div>
	</div>
</section>

<!-- Order Section -->
<section class="section bg-dark text-center">
	<div class="container">
		<h2 class="display-5">Simple Way To Order Your Foods</h2>
		<p>Download our app now</p>
		<button class="btn btn-warning">Google Play</button>
		<button class="btn btn-light">Apple Store</button>
	</div>
</section>



<!-- food-section -->
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Base64"%>
<%@ page import="com.restaurant.util.DBConnection"%>

<section class="container text-white text-center py-5">
	<h6 class="text-warning">MENU</h6>
	<h2 class="display-4 mb-4">Explore Our Foods</h2>
	<p class="mb-5">A menu created for every craving, discover your
		next favorite dish. 100% pure vegetarian with fresh and organic
		ingredients. Foods are rich and aromatic with a perfect balance of
		spice that brings warmth and depth to every bite. ✨</p>

	<div class="row">
		<%
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnection(); // Using your DBConnection class

			String query = "SELECT f.food_id, f.food_name, f.description, f.price, f.photo, COUNT(oi.food_id) AS total_orders "
			+ "FROM order_items oi " + "JOIN food_items f ON oi.food_id = f.food_id " + "GROUP BY f.food_id "
			+ "ORDER BY total_orders DESC " + "LIMIT 3";

			ps = con.prepareStatement(query);
			rs = ps.executeQuery();

			while (rs.next()) {
				String foodName = rs.getString("food_name");
				String description = rs.getString("description");
				double price = rs.getDouble("price");
				double oldPrice = price * 1.1; // Applying a 10% discount for visual effect
				String imageBase64 = "default-image.jpg"; // Default image if no image exists

				if (rs.getBytes("photo") != null) {
			byte[] imageData = rs.getBytes("photo");
			imageBase64 = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(imageData);
				}
		%>

		<!-- Food Card -->
		<div class="col-md-4">
			<div class="card bg-dark text-light border-0">
				<img src="<%=imageBase64%>" class="card-img-top" alt="<%=foodName%>"
					style="height: 200px; object-fit: cover;">
				<div class="card-body">
					<h5 class="fw-bold text-warning"><%=foodName%></h5>
					<p class="text-light"><%=description != null && !description.isEmpty() ? description : "No description available."%></p>
					<h5 class="fw-bold text-info">
						₹<%=String.format("%.2f", price)%>
						<span class="text-danger text-decoration-line-through">₹<%=String.format("%.2f", oldPrice)%></span>
					</h5>
					<a href="menu"
						class="btn btn-warning text-dark fw-bold">Order Now</a>
				</div>
			</div>
		</div>

		<%
		}
		} catch (Exception e) {
		e.printStackTrace();
		} finally {
		if (rs != null)
		try {
			rs.close();
		} catch (SQLException ignored) {
		}
		if (ps != null)
		try {
			ps.close();
		} catch (SQLException ignored) {
		}
		if (con != null)
		try {
			con.close();
		} catch (SQLException ignored) {
		}
		}
		%>
	</div>
</section>
<%@include file="include_footer.jsp"%>