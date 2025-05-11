<%@page import="com.restaurant.entities.Message"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="include_header.jsp"%>
<style>
::placeholder {
	color: rgba(255, 255, 255, 0.5) !important; /* Light gray */
}
</style>



<div class="container p-4 rounded" style="max-width: 500px;">
	<h1 class="text-center display-5">Let's Talk 🤝</h1>
	<p class="text-center text-secondary">Fill out the form in a decent
		manner.</p>
	<hr>

	<form action="ContactServlet" method="post">
		<%
		Message mu = (Message) session.getAttribute("msg");
		if (mu != null) {
		%>
		<div class="alert <%=mu.getCssClass()%>" role="alert">
			<%=mu.getContent()%>
		</div>
		<%
		session.removeAttribute("msg");
		}
		%>
		<%
		if (u != null) {
		%>
		<div class="mb-3">
			<label class="form-label text-warning">Name</label> <input
				type="text" name="name" class="form-control bg-dark text-white"
				value="<%=u.getName()%>" readonly />
		</div>

		<div class="mb-3">
			<label class="form-label text-warning">E-mail</label> <input
				type="email" name="email" class="form-control bg-dark text-white"
				value="<%=u.getEmail()%>" readonly />
		</div>
		<%
		} else {
		%>
		<div class="mb-3">
			<label class="form-label text-warning">Name</label> <input
				type="text" name="name" class="form-control bg-dark text-white"
				placeholder="Enter Your Name">
		</div>

		<div class="mb-3">

			<label class="form-label text-warning">E-mail</label> <input
				type="email" name="email" class="form-control bg-dark text-white"
				placeholder="ex: myname@example.com">
			<p class="text-secondary small">example@example.com</p>
		</div>
		<%
		}
		%>


		<div class="mb-3">
			<label class="form-label text-warning">Message</label>
			<textarea name="comments" rows="2"
				class="form-control bg-dark text-white"
				placeholder="Enter something about you..."></textarea>
		</div>

		<div class="text-center">
			<button type="submit" class="btn btn-warning px-4 py-2">Submit</button>
		</div>
	</form>
</div>

<%@include file="include_footer.jsp"%>