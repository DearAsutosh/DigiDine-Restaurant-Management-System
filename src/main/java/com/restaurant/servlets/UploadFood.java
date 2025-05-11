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

@WebServlet("/UploadFood")
@MultipartConfig(maxFileSize = 16177215) // Max file size: 16MB
public class UploadFood extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/plain");

		try {
			// Get input values
			String foodName = request.getParameter("food_name");
			String description = request.getParameter("description");
			double price = Double.parseDouble(request.getParameter("price"));
			int categoryId = Integer.parseInt(request.getParameter("category_id"));

			// Handle image upload
			InputStream imageStream = null;
			Part filePart = request.getPart("photo");
			if (filePart != null && filePart.getSize() > 0) {
				imageStream = filePart.getInputStream();
			}

			// Insert data into database
			try (Connection con = DBConnection.getConnection()) {
				String query = "INSERT INTO food_items (food_name, description, price, category_id, photo) VALUES (?, ?, ?, ?, ?)";
				PreparedStatement stmt = con.prepareStatement(query);
				stmt.setString(1, foodName);
				stmt.setString(2, description);
				stmt.setDouble(3, price);
				stmt.setInt(4, categoryId);

				if (imageStream != null) {
					stmt.setBlob(5, imageStream);
				} else {
					stmt.setNull(5, java.sql.Types.BLOB);
				}

				int row = stmt.executeUpdate();
				if (row > 0) {
					response.getWriter().write("success"); // Respond with success message
				} else {
					response.getWriter().write("error"); // Respond with error message
				}
			}
		} catch (Exception e) {
			response.getWriter().write("error");
		}
	}
}
