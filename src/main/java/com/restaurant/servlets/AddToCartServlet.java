package com.restaurant.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.restaurant.entities.User;
import com.restaurant.util.DBConnection;


@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
   
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");
        
        if (user == null) {
            response.getWriter().write("0"); // User not logged in
            return;
        }

        int foodId = Integer.parseInt(request.getParameter("food_id"));
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();

            // Check if item is already in cart
            pstmt = conn.prepareStatement("SELECT quantity FROM cart WHERE user_id = ? AND food_id = ?");
            pstmt.setInt(1, user.getId());
            pstmt.setInt(2, foodId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // If exists, update quantity
                int newQuantity = rs.getInt("quantity") + 1;
                pstmt = conn.prepareStatement("UPDATE cart SET quantity = ? WHERE user_id = ? AND food_id = ?");
                pstmt.setInt(1, newQuantity);
                pstmt.setInt(2, user.getId());
                pstmt.setInt(3, foodId);
                pstmt.executeUpdate();
            } else {
                // If not, insert new item
                pstmt = conn.prepareStatement("INSERT INTO cart (user_id, food_id, quantity) VALUES (?, ?, 1)");
                pstmt.setInt(1, user.getId());
                pstmt.setInt(2, foodId);
                pstmt.executeUpdate();
            }

            // Fetch updated cart count
            pstmt = conn.prepareStatement("SELECT SUM(quantity) FROM cart WHERE user_id = ?");
            pstmt.setInt(1, user.getId());
            rs = pstmt.executeQuery();
            int cartCount = rs.next() ? rs.getInt(1) : 0;

            response.getWriter().write(String.valueOf(cartCount)); // Send updated count

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }
}
