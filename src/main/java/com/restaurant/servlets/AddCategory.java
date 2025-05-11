package com.restaurant.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.restaurant.util.DBConnection;

@WebServlet("/AddCategory")
public class AddCategory extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public AddCategory() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get category name from form
		String categoryName = request.getParameter("category_name");
		
		if (categoryName == null || categoryName.trim().isEmpty()) {
			response.getWriter().write("Category name cannot be empty.");
			return;
		}

		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = DBConnection.getConnection();
			String sql = "INSERT INTO categories (category_name) VALUES (?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, categoryName);
			
			int rowsInserted = pstmt.executeUpdate();
			if (rowsInserted > 0) {
				response.getWriter().write("Category added successfully.");
			} else {
				response.getWriter().write("Failed to add category.");
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
			response.getWriter().write("Database error: " + e.getMessage());
		} finally {
			try {
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
