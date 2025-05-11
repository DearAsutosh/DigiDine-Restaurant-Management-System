package com.restaurant.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.restaurant.entities.User;
import com.restaurant.entities.Message;
import com.restaurant.util.DBConnection;

@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {
  
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get session and user (if logged in)
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("comments");

        // Validate form fields
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            
            session.setAttribute("msg", new Message("All fields are required!", "error", "alert-danger"));
            response.sendRedirect("contact");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Establish DB connection
            conn = DBConnection.getConnection();

            // Prepare SQL query
            String sql = "INSERT INTO messages (user_id, name, email, message) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            
            // If user is logged in, set user_id, otherwise set null
            if (user != null) {
                pstmt.setInt(1, user.getId());
            } else {
                pstmt.setNull(1, java.sql.Types.INTEGER);
            }

            pstmt.setString(2, name);
            pstmt.setString(3, email);
            pstmt.setString(4, message);

            // Execute update
            int rowsInserted = pstmt.executeUpdate();

            if (rowsInserted > 0) {
                session.setAttribute("msg", new Message("Message sent successfully!", "success", "alert-success"));
            } else {
                session.setAttribute("msg", new Message("Failed to send message. Try again!", "error", "alert-danger"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", new Message("Something went wrong. Try again later!", "error", "alert-danger"));
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Redirect back to contact page with status message
        response.sendRedirect("contact");
    }
}
