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
import javax.servlet.http.HttpSession;

import com.restaurant.dao.UserDao;
import com.restaurant.entities.Message;
import com.restaurant.entities.User;
import com.restaurant.util.DBConnection;

/**
 * Servlet implementation class UpdateProfileServlet
 */
@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public UpdateProfileServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try (PrintWriter out = response.getWriter()) {

			String userName = request.getParameter("user_name");
			String userPassword = request.getParameter("user_password");
			String userEmail = request.getParameter("user_email");
			String userAddress = request.getParameter("user_address");
			String userMobile = request.getParameter("user_mobile");

			// get the user from session
			HttpSession s = request.getSession();
			User user = (User) s.getAttribute("currentUser");
			user.setEmail(userEmail);
			user.setName(userName);
			user.setPassword(userPassword);
			user.setAddress(userAddress);
			user.setMobileNumber(userMobile);

			Connection conn = DBConnection.getConnection();
			// update database
			UserDao userDao = new UserDao(conn);

			if (userDao.updateUser(user)) {
				out.println("Updated to DB...");
				out.println("profile updated ...");
				Message msg = new Message("Profile details updated ...", "success", "alert-success");
				s.setAttribute("msg", msg);
			} else {
				out.println("Not updated...");
				Message msg = new Message("Something went wrong ...", "error", "alert-danger");
				s.setAttribute("msg", msg);
			}
			try {
				PreparedStatement ps = conn.prepareStatement("SELECT role FROM users WHERE email=?");
				ps.setString(1, user.getEmail());
				ResultSet resultSet = ps.executeQuery();
				if (resultSet.next()) {
					String role = resultSet.getString("role");
					if (role.equals("admin")) {
						response.sendRedirect("./ADMIN/home.jsp");
					} else {
						response.sendRedirect("profile.jsp");
					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
