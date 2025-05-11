package com.restaurant.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.restaurant.entities.User;
import com.restaurant.util.DBConnection;

@WebServlet("/UpdateCartQuantityServlet")
public class UpdateCartQuantityServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("currentUser");

		if (user == null) {
			response.getWriter().write("login");
			return;
		}

		int foodId = Integer.parseInt(request.getParameter("food_id"));
		String action = request.getParameter("action");

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = DBConnection.getConnection();

			// Check if item exists
			String checkQuery = "SELECT quantity FROM cart WHERE user_id = ? AND food_id = ?";
			pstmt = conn.prepareStatement(checkQuery);
			pstmt.setInt(1, user.getId());
			pstmt.setInt(2, foodId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				int currentQty = rs.getInt("quantity");

				if ("increase".equals(action)) {
					currentQty++;
				} else if ("decrease".equals(action)) {
					currentQty--;
				}

				rs.close();
				pstmt.close();

				if (currentQty <= 0) {
					// Remove item from cart
					String deleteQuery = "DELETE FROM cart WHERE user_id = ? AND food_id = ?";
					pstmt = conn.prepareStatement(deleteQuery);
					pstmt.setInt(1, user.getId());
					pstmt.setInt(2, foodId);
					pstmt.executeUpdate();
				} else {
					// Update item quantity
					String updateQuery = "UPDATE cart SET quantity = ? WHERE user_id = ? AND food_id = ?";
					pstmt = conn.prepareStatement(updateQuery);
					pstmt.setInt(1, currentQty);
					pstmt.setInt(2, user.getId());
					pstmt.setInt(3, foodId);
					pstmt.executeUpdate();
				}

				// Fetch and return the new total quantity
				pstmt = conn.prepareStatement("SELECT SUM(quantity) FROM cart WHERE user_id = ?");
				pstmt.setInt(1, user.getId());
				rs = pstmt.executeQuery();

				int totalQty = rs.next() ? rs.getInt(1) : 0;
				response.getWriter().write(String.valueOf(totalQty));
			} else {
				response.getWriter().write("error");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("error");
		} finally {
			try {
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
			}
			try {
				if (pstmt != null)
					pstmt.close();
			} catch (SQLException e) {
			}
			try {
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
			}
		}
	}
}
