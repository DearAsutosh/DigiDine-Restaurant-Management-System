<%@ page isErrorPage="true"%>
<%
String role = (String) session.getAttribute("role");
String homeLink = (role != null && role.equals("admin")) ? "../ADMIN/home" : "./home";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Error - DigiDine</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	background-color: #121212;
	color: #ffffff;
	display: flex;
	align-items: center;
	justify-content: center;
	height: 100vh;
	margin: 0;
}

.error-container {
	background: #1e1e1e;
	padding: 40px;
	border-radius: 15px;
	box-shadow: 0 0 15px rgba(255, 255, 255, 0.1);
	text-align: center;
	max-width: 500px;
	width: 90%;
}

.error-image {
	width: 100%;
	max-width: 250px;
	margin-bottom: 20px;
	filter: drop-shadow(0px 0px 10px rgba(255, 255, 255, 0.2));
}

.error-title {
	font-size: 28px;
	font-weight: bold;
	color: #ffca2b;
}

.error-text {
	font-size: 16px;
	margin-top: 10px;
	color: #dddddd;
}

.btn-home {
	background: linear-gradient(45deg, #ffca2b, #ff9800);
	color: #000;
	font-weight: bold;
	padding: 10px 20px;
	border-radius: 8px;
	text-decoration: none;
	display: inline-block;
	margin-top: 20px;
	transition: 0.3s ease-in-out;
}

.btn-home:hover {
	background: linear-gradient(45deg, #ff9800, #ffca2b);
	transform: scale(1.05);
}
</style>
</head>
<body>
	<div class="error-container">
		<img src="https://cdn-icons-png.flaticon.com/512/6478/6478111.png"
			alt="Error Image" class="error-image">
		<h1 class="error-title">Oops! Something went wrong</h1>
		<p class="error-text">We encountered an unexpected error.</p>
		<p class="text-warning">
			<%=exception != null ? exception.getMessage() : "Unknown Error"%>
		</p>
		<a href="<%=homeLink%>" class="btn-home">Go Back to Home</a>
	</div>
</body>
</html>
