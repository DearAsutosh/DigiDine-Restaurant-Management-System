package com.restaurant.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.restaurant.util.DBConnection;

@WebServlet("/GenerateOrderServlet")
public class GenerateOrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/plain");
		PrintWriter out = response.getWriter();

		// Retrieve parameters
		String customerName = request.getParameter("customer_name");
		String mobileNumber = request.getParameter("mobile_number");
		String paymentMethod = request.getParameter("payment_method");
		String[] foodItemIds = request.getParameterValues("food_item_id");
		String[] quantities = request.getParameterValues("quantity");

		// Log incoming parameters
		logIncomingParameters(customerName, mobileNumber, paymentMethod, foodItemIds, quantities);

		// Check for missing parameters
		if (isAnyParameterMissing(customerName, mobileNumber, paymentMethod, foodItemIds, quantities)) {
			out.print("error: Missing parameters");
			return;
		}

		try (Connection conn = DBConnection.getConnection()) {
			conn.setAutoCommit(false); // Start transaction

			int orderId = insertGuestOrder(conn, customerName, mobileNumber, paymentMethod);

			// Insert items into guest_order_items
			insertOrderItems(conn, orderId, foodItemIds, quantities);

			conn.commit(); // Commit transaction
			out.print("success:" + orderId); // Return success with orderId

		} catch (SQLException e) {
			handleSQLException(e, out);
		} catch (Exception e) {
			e.printStackTrace();
			out.print("error: " + e.getMessage());
		}
	}

	private void logIncomingParameters(String customerName, String mobileNumber, String paymentMethod,
			String[] foodItemIds, String[] quantities) {
		System.out.println("Received parameters:");
		System.out.println("Customer Name: " + customerName);
		System.out.println("Mobile Number: " + mobileNumber);
		System.out.println("Payment Method: " + paymentMethod);
		System.out.println("Food Item IDs: " + (foodItemIds != null ? String.join(", ", foodItemIds) : "None"));
		System.out.println("Quantities: " + (quantities != null ? String.join(", ", quantities) : "None"));
	}

	private boolean isAnyParameterMissing(String customerName, String mobileNumber, String paymentMethod,
			String[] foodItemIds, String[] quantities) {
		return customerName == null || mobileNumber == null || paymentMethod == null || foodItemIds == null
				|| quantities == null;
	}

	private int insertGuestOrder(Connection conn, String customerName, String mobileNumber, String paymentMethod)
			throws SQLException {
		String orderSQL = "INSERT INTO guest_orders (customer_name, mobile_number, payment_method) VALUES (?, ?, ?)";
		try (PreparedStatement orderStmt = conn.prepareStatement(orderSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
			orderStmt.setString(1, customerName);
			orderStmt.setString(2, mobileNumber);
			orderStmt.setString(3, paymentMethod);
			int orderResult = orderStmt.executeUpdate();
			System.out.println("Order insertion result: " + orderResult);

			// Get the last inserted order_id
			ResultSet rs = orderStmt.getGeneratedKeys();
			if (rs.next()) {
				int orderId = rs.getInt(1);
				System.out.println("Generated Order ID: " + orderId);
				return orderId;
			} else {
				throw new SQLException("Failed to retrieve generated order ID.");
			}
		}
	}

	private void insertOrderItems(Connection conn, int orderId, String[] foodItemIds, String[] quantities)
			throws SQLException {
		String orderDetailsSQL = "INSERT INTO guest_order_items (guest_order_id, food_item_id, quantity) VALUES (?, ?, ?)";
		try (PreparedStatement orderDetailsStmt = conn.prepareStatement(orderDetailsSQL)) {
			for (int i = 0; i < foodItemIds.length; i++) {
				orderDetailsStmt.setInt(1, orderId);
				orderDetailsStmt.setInt(2, Integer.parseInt(foodItemIds[i]));
				orderDetailsStmt.setInt(3, Integer.parseInt(quantities[i]));
				orderDetailsStmt.addBatch(); // Add to batch
				System.out.println("Added item to batch: ID=" + foodItemIds[i] + ", Quantity=" + quantities[i]);
			}

			orderDetailsStmt.executeBatch(); // Execute batch insert
		}
	}

	private void handleSQLException(SQLException e, PrintWriter out) {
		try {
			out.print("error: SQL error - " + e.getMessage());
		} finally {
			e.printStackTrace(); // Log the stack trace
		}
	}
}
