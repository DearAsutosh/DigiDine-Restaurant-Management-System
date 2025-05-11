<%@page import="com.restaurant.entities.Message"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="include_header.jsp"%>
<style>
::placeholder {
	color: rgba(255, 255, 255, 0.5) !important; /* Light gray */
}
</style>
<div class="container p-4 rounded w-50">
	<%
	if (u == null) {
	%>
	<h1 class="text-center">Login Form🤝</h1>
	<p class="text-center text-secondary">Fill out the form carefully
		for registration.</p>
	<hr>
	<form id="loginForm" action="LoginServlet" method="post">
		<div class="mb-3">
			<label for="email" class="form-label text-warning">E-mail</label> <input type="email" name="email"
				class="form-control bg-dark text-white border-secondary"
				placeholder="ex: myname@example.com" required>
			<p class="text-secondary">example@example.com</p>
		</div>
		<div class="mb-3">
			<label for="password" class="form-label text-warning">Enter
				Your Password :</label> <input type="password" name="password"
				class="form-control bg-dark text-white border-secondary"
				placeholder="Enter your password ..." required>
		</div>
		<div class="text-center my-4">
			<span class="text-light">New User? </span> <a href="register"
				class="text-warning fw-bold text-decoration-none">Sign Up</a>
		</div>
		<div class="text-center">
			<button type="submit" class="btn btn-warning text-black">Submit</button>
		</div>
	</form>
	<%
	} else {
	String role = (String) session.getAttribute("role");
	if ("admin".equals(role)) {
		response.sendRedirect("ADMIN/home.jsp");
	} else {
		response.sendRedirect("profile.jsp");
	}
	return;
	}
	%>
</div>

<%@include file="include_footer.jsp"%>
