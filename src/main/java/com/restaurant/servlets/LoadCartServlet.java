package com.restaurant.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.restaurant.util.DBConnection;
import com.restaurant.entities.User;

@WebServlet("/LoadCartServlet")
public class LoadCartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("currentUser");
		PrintWriter out = response.getWriter();

		if (user == null) {
			out.print("<p class='text-danger'>Please log in to view your cart.</p>");
			return;
		}

		Connection conn = DBConnection.getConnection();
		try {
			String query = "SELECT f.food_id, f.food_name, f.price, c.quantity FROM cart c JOIN food_items f ON c.food_id = f.food_id WHERE c.user_id = ?";
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, user.getId());
			ResultSet rs = pstmt.executeQuery();

			double totalPrice = 0;
			out.print("<div class='list-group'>");

			while (rs.next()) {
				int foodId = rs.getInt("food_id");
				String foodName = rs.getString("food_name");
				double price = rs.getDouble("price");
				int quantity = rs.getInt("quantity");
				double itemTotal = price * quantity;
				totalPrice += itemTotal;

				out.print(
						"<div class='list-group-item d-flex justify-content-between align-items-center' id='cart-item-"
								+ foodId + "'>");
				out.print("<div>");
				out.print("<strong>" + foodName + "</strong><br>");
				out.print("&#8377;" + String.format("%.2f", price) + "    X    ");
				out.print("<button class='btn btn-sm btn-outline-danger update-qty' data-id='" + foodId
						+ "' data-action='decrease'>-</button> ");
				out.print("<span id='qty-" + foodId + "'>" + quantity + "</span> ");
				out.print("<button class='btn btn-sm btn-outline-success update-qty' data-id='" + foodId
						+ "' data-action='increase'>+</button>");
				out.print("</div>");
				out.print("<div><strong>&#8377;" + String.format("%.2f", itemTotal) + "</strong></div>");
				out.print("</div>");
			}

			out.print("</div>");
			out.print("<hr><h5 class='text-end'>Total: &#8377;<span id='total-amount'>"
					+ String.format("%.2f", totalPrice) + "</span></h5>");

			rs.close();
			pstmt.close();
		} catch (Exception e) {
			e.printStackTrace();
			out.print("<p class='text-danger'>Error loading cart.</p>");
		}
	}
}
