package com.restaurant.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.restaurant.dao.UserDao;
import com.restaurant.entities.User;
import com.restaurant.util.DBConnection;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/plain");
		PrintWriter out = response.getWriter();

		String name = request.getParameter("name");
		String address = request.getParameter("address");
		String gender = request.getParameter("gender");
		String email = request.getParameter("email");
		String mobileNumber = request.getParameter("mobileNumber");
		String password = request.getParameter("password");

		User user = new User(name, address, gender, email, mobileNumber, password);
		UserDao dao = new UserDao(DBConnection.getConnection());

		if (dao.isEmailRegistered(email)) {
			out.print("exists");
		} else {
			boolean saved = dao.saveUser(user);
			out.print(saved ? "done" : "error");
		}
	}
}
