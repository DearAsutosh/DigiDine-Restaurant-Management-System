package com.restaurant.servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.restaurant.util.DBConnection;

@WebServlet("/EditFood")
@MultipartConfig(maxFileSize = 16177215) // Max file size: 16MB
public class EditFoodServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {
			// Retrieving Form Data
			int foodId = Integer.parseInt(request.getParameter("food_id"));
			String foodName = request.getParameter("food_name");
			String description = request.getParameter("description");
			double price = Double.parseDouble(request.getParameter("price"));

			// Handling Image Upload
			InputStream imageStream = null;
			Part filePart = request.getPart("photo");
			if (filePart != null && filePart.getSize() > 0) {
				imageStream = filePart.getInputStream();
			}

			// Database Connection
			Connection con = DBConnection.getConnection();
			String query;
			PreparedStatement stmt;

			// If image is provided, update the photo as well
			if (imageStream != null) {
				query = "UPDATE food_items SET food_name=?, description=?, price=?, photo=? WHERE food_id=?";
				stmt = con.prepareStatement(query);
				stmt.setString(1, foodName);
				stmt.setString(2, description);
				stmt.setDouble(3, price);
				stmt.setBlob(4, imageStream);
				stmt.setInt(5, foodId);
			} else {
				// If no new image is uploaded, keep the existing photo
				query = "UPDATE food_items SET food_name=?, description=?, price=? WHERE food_id=?";
				stmt = con.prepareStatement(query);
				stmt.setString(1, foodName);
				stmt.setString(2, description);
				stmt.setDouble(3, price);
				stmt.setInt(4, foodId);
			}

			// Executing Update
			int row = stmt.executeUpdate();
			stmt.close();
			con.close();

			if (row > 0) {
				// Redirect with success message
				response.sendRedirect("./ADMIN/edit_food.jsp?success=true");
			} else {
				// Redirect with failure message
				response.sendRedirect("./ADMIN/edit_food.jsp?error=update_failed");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("edit_food.jsp?error=" + e.getMessage());
		}
	}
}
