<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="include_header.jsp"%>
<style>
::placeholder {
	color: rgba(255, 255, 255, 0.5) !important;
}
</style>

<div class="container p-4 rounded" style="max-width: 700px;">
	<h1 class="text-center display-5 text-warning">Registration Form
		🤝</h1>
	<p class="text-center text-secondary">Fill out the form carefully
		for registration.</p>
	<hr>

	<form id="registrationForm" action="RegisterServlet" method="post">
		<div class="mb-3">
			<label class="form-label text-warning">Customer Name</label> <input
				type="text" name="name" class="form-control bg-dark text-white"
				placeholder="Enter Your Name" required>
		</div>
		<div class="mb-3">
			<label class="form-label text-warning">Address</label> <input
				type="text" name="address" class="form-control bg-dark text-white"
				placeholder="Enter Your Address" required>
		</div>
		<div class="row g-3 mb-3">
			<div class="col-md-6">
				<label class="form-label text-warning">Gender</label> <select
					name="gender" class="form-select bg-dark text-white" required>
					<option value="" selected>Select Gender</option>
					<option value="Male">Male</option>
					<option value="Female">Female</option>
					<option value="Prefer not to say">Prefer not to say</option>
				</select>
			</div>
			<div class="col-md-6">
				<label class="form-label text-warning">E-mail</label> <input
					type="email" name="email" class="form-control bg-dark text-white"
					placeholder="myname@example.com" required>
			</div>
		</div>
		<div class="mb-3">

			<label class="form-label text-warning">Mobile Number</label> <input
				type="tel" name="mobileNumber"
				class="form-control bg-dark text-white"
				placeholder="(+91) 00000-00000" required>

		</div>
		<div class="row g-3 mb-3">
			<div class="col-md-6">
				<label class="form-label text-warning">Enter Password</label> <input
					type="password" name="password" id="password"
					class="form-control bg-dark text-white"
					placeholder="Enter Password" required>
			</div>
			<div class="col-md-6">
				<label class="form-label text-warning">Confirm Password</label> <input
					type="password" name="confirmPassword" id="confirmPassword"
					class="form-control bg-dark text-white"
					placeholder="Confirm Password" required>
			</div>
		</div>

		<div class="text-center my-4">
			<span class="text-light">Existing User? </span> <a href="login.jsp"
				class="text-warning fw-bold text-decoration-none">Log in</a>
		</div>

		<div id="loader" class="container text-center" style="display: none;">
			<span class="fa fa-refresh fa-spin fa-3x"></span>
			<h4>Please wait...</h4>
		</div>

		<div class="text-center">
			<button id="submit-btn" type="submit"
				class="btn btn-warning px-4 py-2">Submit</button>
		</div>
	</form>

	<div id="responseMessage" class="text-center mt-3"></div>
</div>

<%@include file="include_footer.jsp"%>

<script>
$("#registrationForm").on("submit", function (event) {
    event.preventDefault();
    
    let password = $("input[name='password']").val();
    let confirmPassword = $("input[name='confirmPassword']").val();

    if (password !== confirmPassword) {
        Swal.fire({
            icon: 'error',
            title: 'Password Mismatch!',
            text: 'Your passwords do not match. Please try again.'
        });
        return;
    }

    $("#submit-btn").hide();
    $("#loader").show();

    $.ajax({
        url: "RegisterServlet",
        type: "POST",
        data: $("#registrationForm").serialize(),
        success: function (data) {
            $("#submit-btn").show();
            $("#loader").hide();

            if (data.trim() === 'done') {
                Swal.fire({
                    icon: 'success',
                    title: 'Registered Successfully!',
                    text: 'Redirecting you to login page...'
                }).then(() => {
                    window.location = "login.jsp";
                });
            } else if (data.trim() === 'exists') {
                Swal.fire({
                    icon: 'warning',
                    title: 'User Already Exists!',
                    text: 'You already have an account. Please log in.'
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Something went wrong!',
                    text: 'Please try again later.'
                });
            }
        }
    });
});
</script>

