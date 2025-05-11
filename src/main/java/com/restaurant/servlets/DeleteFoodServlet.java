package com.restaurant.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.restaurant.util.DBConnection;

@WebServlet("/DeleteFoodServlet")
public class DeleteFoodServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int foodId = Integer.parseInt(request.getParameter("food_id"));

		try (Connection con = DBConnection.getConnection()) {
			String query = "DELETE FROM food_items WHERE food_id=?";
			PreparedStatement stmt = con.prepareStatement(query);
			stmt.setInt(1, foodId);
			int rows = stmt.executeUpdate();

			if (rows > 0) {
				request.getSession().setAttribute("message", "Food item deleted successfully!");
			} else {
				request.getSession().setAttribute("message", "Failed to delete food item.");
			}
		} catch (Exception e) {
			request.getSession().setAttribute("message", "An error occurred while deleting.");
		}
		response.sendRedirect("ADMIN/delete_food.jsp");
	}
}
