package com.restaurant.servlets;

import com.restaurant.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/OrderHistoryServlet")
public class OrderHistoryServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String orderType = request.getParameter("orderType");
		if (orderType == null)
			orderType = "online";

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		try (Connection conn = DBConnection.getConnection()) {
			PreparedStatement stmt;
			if ("online".equalsIgnoreCase(orderType)) {
				stmt = conn.prepareStatement(
						"SELECT o.order_id, u.userid, u.name AS customer_name, o.total_price, o.status, o.order_date "
								+ "FROM orders o JOIN users u ON o.user_id = u.userid ORDER BY o.order_date DESC");
			} else {
				stmt = conn.prepareStatement("SELECT o.order_id, 'Guest' AS userid, o.customer_name, "
						+ "(SELECT SUM(fi.price * goi.quantity) FROM guest_order_items goi JOIN food_items fi ON goi.food_item_id = fi.food_id WHERE goi.order_id = o.order_id) AS total_price, "
						+ "'Delivered' AS status, o.order_date " + "FROM guest_orders o ORDER BY o.order_date DESC");
			}

			ResultSet rs = stmt.executeQuery();

			out.println("<table class='table table-bordered table-dark table-hover'>");
			out.println("<thead><tr>");
			out.println(
					"<th>Order ID</th><th>User ID</th><th>Customer Name</th><th>Total Price</th><th>Status</th><th>Order Date</th><th>Ordered Items</th><th>Show Bill</th>");
			out.println("</tr></thead><tbody>");

			boolean found = false;
			while (rs.next()) {
				found = true;
				int orderId = rs.getInt("order_id");
				String userId = rs.getString("userid");
				String customerName = rs.getString("customer_name");
				double totalPrice = rs.getDouble("total_price");
				String status = rs.getString("status");
				Timestamp orderDate = rs.getTimestamp("order_date");

				out.println("<tr>");
				out.println("<td>" + orderId + "</td>");
				out.println("<td>" + userId + "</td>");
				out.println("<td>" + customerName + "</td>");
				out.println("<td>&#8377;" + totalPrice + "</td>");
				out.println("<td>" + status + "</td>");
				out.println("<td>" + orderDate + "</td>");
				out.println("<td><a href='view_order_items.jsp?order_id=" + orderId + "&type=" + orderType
						+ "' class='btn btn-warning btn-sm'>View Items</a></td>");
				out.println("<td><a href='generate-bill.jsp?orderId=" + orderId + "&type=" + orderType
						+ "' class='btn btn-success btn-sm' target='_blank'>Show Bill</a></td>");
				out.println("</tr>");
			}

			if (!found) {
				out.println("<tr><td colspan='8' class='text-center text-muted'>No orders found.</td></tr>");
			}

			out.println("</tbody></table>");

		} catch (Exception e) {
			e.printStackTrace(out);
		}
	}
}
