package com.restaurant.servlets;

import com.restaurant.entities.User;
import com.restaurant.util.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/LoadOrderHistoryServlet")
public class LoadOrderHistoryServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();

		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("currentUser");

		if (user == null) {
			out.println("<p class='text-danger'>You must be logged in to view order history.</p>");
			return;
		}

		try {
			Connection conn = DBConnection.getConnection();

			String sql = "SELECT o.order_id, o.order_date, o.total_price, o.status, "
					+ "oi.food_id, fi.food_name, oi.quantity, oi.price " + "FROM orders o "
					+ "JOIN order_items oi ON o.order_id = oi.order_id "
					+ "JOIN food_items fi ON oi.food_id = fi.food_id " + "WHERE o.user_id = ? "
					+ "ORDER BY o.order_date DESC";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, user.getId());
			ResultSet rs = ps.executeQuery();

			int lastOrderId = -1;
			boolean hasOrders = false;
			double orderTotal = 0.0;
			String lastOrderStatus = "";

			while (rs.next()) {
				hasOrders = true;

				int orderId = rs.getInt("order_id");
				Timestamp orderDate = rs.getTimestamp("order_date");
				String foodName = rs.getString("food_name");
				int quantity = rs.getInt("quantity");
				double itemPrice = rs.getDouble("price");
				String status = rs.getString("status");

				if (orderId != lastOrderId) {
					// Close previous order table
					if (lastOrderId != -1) {
						out.println("</tbody></table>");
						out.println("<p class='fw-bold text-end text-success'>Total: ₹" + orderTotal + "</p>");
						if ("Delivered".equalsIgnoreCase(lastOrderStatus)) { // Show bill for every Delivered order
							out.println("<div class='text-end mb-3'>");
							out.println("<a href='generate-bill.jsp?orderId=" + lastOrderId
									+ "' target='_blank' class='btn btn-warning btn-sm'>View Bill</a>");
							out.println("</div>");
						}
						out.println("<hr>");
					}

					// Reset for new order
					orderTotal = 0;
					lastOrderStatus = status;

					out.println("<div class='mb-3'>");
					out.println("<h5 class='text-info'>Order #" + orderId + " <small class='text-muted'>(" + orderDate
							+ ")</small></h5>");
					out.println("<p>Status: <span class='badge bg-secondary'>" + status + "</span></p>");
					out.println(
							"<table class='table table-striped table-bordered table-dark'><thead><tr><th>Item</th><th>Qty</th><th>Price (₹)</th></tr></thead><tbody>");
					lastOrderId = orderId;
				}

				orderTotal += (quantity * itemPrice);
				out.println("<tr><td>" + foodName + "</td><td>" + quantity + "</td><td>" + itemPrice + "</td></tr>");
			}

			// Close last order block
			if (lastOrderId != -1) {
				out.println("</tbody></table>");
				out.println("<p class='fw-bold text-end text-success'>Total: ₹" + orderTotal + "</p>");
				if ("Delivered".equalsIgnoreCase(lastOrderStatus)) { // Ensure last order gets the bill button
					out.println("<div class='text-end mb-3'>");
					out.println("<a href='generate-bill.jsp?orderId=" + lastOrderId
							+ "' target='_blank' class='btn btn-warning btn-sm'>View Bill</a>");
					out.println("</div>");
				}
				out.println("</div>");
			}

			if (!hasOrders) {
				out.println("<p class='text-center text-muted'>You haven’t placed any orders yet.</p>");
			}

			rs.close();
			ps.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
			out.println("<p class='text-danger'>Something went wrong while loading your order history.</p>");
		}
	}
}
