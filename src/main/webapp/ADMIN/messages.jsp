<%@page import="java.sql.*"%>
<%@page import="com.restaurant.util.DBConnection"%>
<%@page import="com.restaurant.entities.User"%>
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
    <div class="card bg-black text-light shadow-lg border-0 rounded-4">
        <div class="card-header bg-warning text-dark text-center fw-bold fs-4">
            Customer Messages
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-dark table-hover border border-warning">
                    <thead class="text-warning">
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Message</th>
                            <th>Submitted On</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        try (Connection conn = DBConnection.getConnection()) {
                            String query = "SELECT message_id, name, email, message, submitted_on FROM messages ORDER BY submitted_on DESC";
                            PreparedStatement pstmt = conn.prepareStatement(query);
                            ResultSet rs = pstmt.executeQuery();
                            while (rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getInt("message_id") %></td>
                            <td><%= rs.getString("name") %></td>
                            <td><%= rs.getString("email") %></td>
                            <td><%= rs.getString("message") %></td>
                            <td><%= rs.getTimestamp("submitted_on") %></td>
                        </tr>
                        <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5' class='text-danger'>Error loading messages</td></tr>");
                            e.printStackTrace();
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="include_footer.jsp" />
