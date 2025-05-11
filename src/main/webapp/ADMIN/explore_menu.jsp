<%@page import="java.sql.*"%>
<%@page import="com.restaurant.util.DBConnection"%>
<%@page import="com.restaurant.entities.User"%>
<%@page import="java.io.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
User u = (User) session.getAttribute("currentUser");
String role = (String) session.getAttribute("role");

if (u == null || !"admin".equals(role)) {
	response.sendRedirect("../login");
	return;
}
%>

<jsp:include page="include_header.jsp" />

<div class="container mt-5">
	<h2 class="text-warning text-center fw-bold mb-4">Explore the Menu</h2>

	<div class="table-responsive">
		<table class="table table-dark table-hover text-center align-middle">
			<thead class="table-warning text-dark">
				<tr>
					<th>Food Id</th>
					<th>Food Photo</th>
					<th>Food Name</th>
					<th>Category</th>
					<th>Description</th>
					<th>Price (₹)</th>
				</tr>
			</thead>
			<tbody>
				<%
				try (Connection conn = DBConnection.getConnection()) {
					String query = "SELECT f.food_id, f.food_name, f.description, c.category_name, f.price, f.photo FROM food_items f JOIN categories c ON f.category_id = c.category_id";
					PreparedStatement pstmt = conn.prepareStatement(query);
					ResultSet rs = pstmt.executeQuery();

					while (rs.next()) {
						int foodId = rs.getInt("food_id");
						String foodName = rs.getString("food_name");
						String description = rs.getString("description");
						String categoryName = rs.getString("category_name");
						double price = rs.getDouble("price");
						Blob photoBlob = rs.getBlob("photo");
				%>
				<tr>
					<td><%=foodId%></td>
					<td>
						<%
						if (photoBlob != null) {
						%> <img src="data:image/png;base64,<%=encodeImage(photoBlob)%>"
						alt="Food Image" class="img-thumbnail border-0"
						style="width: 80px; height: 80px; background: transparent;">
						<%
						} else {
						%> <img src="../assets/no-image.png" alt="No Image"
						class="img-thumbnail border-0"
						style="width: 80px; height: 80px; background: transparent;">
						<%
						}
						%>
					</td>
					<td class="fw-bold"><%=foodName%></td>
					<td class="text-warning"><%=categoryName%></td>
					<td style="max-width: 200px; word-wrap: break-word;"><%=description%></td>
					<td class="fw-bold">₹<%=String.format("%.2f", price)%></td>
				</tr>
				<%
				}
				} catch (Exception e) {
				e.printStackTrace();
				}
				%>
			</tbody>
		</table>
	</div>
</div>

<jsp:include page="include_footer.jsp" />

<%!// Convert BLOB to Base64
	public String encodeImage(Blob blob) {
		try {
			if (blob != null) {
				InputStream inputStream = blob.getBinaryStream();
				ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
				byte[] buffer = new byte[4096];
				int bytesRead;

				while ((bytesRead = inputStream.read(buffer)) != -1) {
					outputStream.write(buffer, 0, bytesRead);
				}

				byte[] imageBytes = outputStream.toByteArray();
				inputStream.close();
				outputStream.close();

				return java.util.Base64.getEncoder().encodeToString(imageBytes);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}%>
