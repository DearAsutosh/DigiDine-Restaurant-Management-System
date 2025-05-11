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
<div id="users"
	class="content-section mt-4 container-fluid text-center ">
	<h2 class="h4 text-warning">Users Section</h2>
	<hr>
	<div class="table-responsive">
		<table
			class="table table-dark table-hover table-bordered mt-3 text-center align-middle">
			<thead class="thead-dark">
				<tr>
					<th>ID</th>
					<th>Name</th>
					<th>Gender</th>
					<th>Address</th>
					<th>Contact No.</th>
					<th>Email Id</th>
					<th>Registered on</th>
				</tr>
			</thead>
			<tbody id="usersTableBody">
				<%
				try (Connection conn = DBConnection.getConnection()) {
					String sql = "SELECT * FROM users where role='customer'";
					PreparedStatement statement = conn.prepareStatement(sql);
					ResultSet resultset = statement.executeQuery();
					while (resultset.next()) {
						int id = resultset.getInt("userid");
						String username = resultset.getString("name");
						String address = resultset.getString("address");
						String gender = resultset.getString("gender");
						String contact = resultset.getString("mobileNumber");
						String email = resultset.getString("email");
						String hiredate = resultset.getString("registered_on");
				%>
				<tr>
					<td><%=id%></td>
					<td><%=username%></td>
					<td><%=gender%></td>
					<td><%=address%></td>
					<td><%=contact%></td>
					<td><%=email%></td>
					<td><%=hiredate%></td>
				</tr>
				<%
				}
				} catch (Exception e) {
				out.println("<tr><td colspan='7' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
				}
				%>
			</tbody>
		</table>
	</div>
</div>
<jsp:include page="include_footer.jsp" />
