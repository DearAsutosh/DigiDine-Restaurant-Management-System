package com.restaurant.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.restaurant.util.DBConnection;

/**
 * Servlet implementation class FetchFoodItemsServlet
 */
@WebServlet("/FetchFoodItemsServlet")
public class FetchFoodItemsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FetchFoodItemsServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT c.category_name, f.food_id, f.food_name FROM food_items f " +
                         "JOIN categories c ON f.category_id = c.category_id ORDER BY c.category_name, f.food_name";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();

            String currentCategory = "";
            boolean isFirst = true;

            while (rs.next()) {
                String category = rs.getString("category_name");
                int foodId = rs.getInt("food_id");
                String foodName = rs.getString("food_name");

                // If category changes, close the previous optgroup and start a new one
                if (!category.equals(currentCategory)) {
                    if (!isFirst) {
                        out.println("</optgroup>");
                    }
                    out.println("<optgroup label=\"" + category + "\">");
                    currentCategory = category;
                }
                isFirst = false;

                out.println("<option value=\"" + foodId + "\">" + foodName + "</option>");
            }

            // Close the last optgroup
            if (!isFirst) {
                out.println("</optgroup>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<option value=''>Error loading items</option>");
        } finally {
            out.close();
        }
    }

}
