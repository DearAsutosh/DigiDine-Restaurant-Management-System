package com.restaurant.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.restaurant.entities.User;
import com.restaurant.util.DBConnection;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            response.getWriter().write("login"); // Redirect to login
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int orderId = -1;
        double totalPrice = 0;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 🔹 Calculate total price from cart
            String totalQuery = "SELECT SUM(f.price * c.quantity) FROM cart c JOIN food_items f ON c.food_id = f.food_id WHERE c.user_id = ?";
            pstmt = conn.prepareStatement(totalQuery);
            pstmt.setInt(1, user.getId());
            rs = pstmt.executeQuery();

            if (rs.next()) {
                totalPrice = rs.getDouble(1);
            }
            rs.close();
            pstmt.close();

            if (totalPrice <= 0) {
                response.getWriter().write("empty"); // No items in cart
                return;
            }

            // 🔹 Insert into orders table
            String insertOrder = "INSERT INTO orders (user_id, total_price, status) VALUES (?, ?, 'Pending')";
            pstmt = conn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, user.getId());
            pstmt.setDouble(2, totalPrice);
            pstmt.executeUpdate();

            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1); // Get generated order_id
            }
            rs.close();
            pstmt.close();

            // 🔹 Insert into order_items table (Includes user_id)
            String insertItems = "INSERT INTO order_items (order_id, user_id, food_id, quantity, price) " +
                                 "SELECT ?, ?, c.food_id, c.quantity, f.price FROM cart c " +
                                 "JOIN food_items f ON c.food_id = f.food_id WHERE c.user_id = ?";
            pstmt = conn.prepareStatement(insertItems);
            pstmt.setInt(1, orderId);
            pstmt.setInt(2, user.getId()); // ✅ Store user_id
            pstmt.setInt(3, user.getId());
            pstmt.executeUpdate();
            pstmt.close();

            // 🔹 Clear cart after order placement
            String clearCart = "DELETE FROM cart WHERE user_id = ?";
            pstmt = conn.prepareStatement(clearCart);
            pstmt.setInt(1, user.getId());
            pstmt.executeUpdate();
            pstmt.close();

            conn.commit(); // ✅ Commit transaction
            response.getWriter().write("success");

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
            response.getWriter().write("error");
        } finally {
            try { if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
