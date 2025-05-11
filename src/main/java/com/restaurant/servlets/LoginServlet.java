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

import com.restaurant.dao.UserDao;
import com.restaurant.entities.Message;
import com.restaurant.entities.User;
import com.restaurant.util.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public LoginServlet() {
        super();
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//login
        //fetch username and password 
        String email=request.getParameter("email");
        String userPassword=request.getParameter("password");
        
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            throw new ServletException("Database connection is null. Check DBConnection.");
        }
        UserDao dao = new UserDao(conn);
        User u = dao.getUserByEmailAndPassword(email, userPassword);
        if(u==null) {
        	//login...
            //error
            Message msg=new Message("Invalid Details ! Try with another ...", "error", "alert-danger");
            HttpSession s= request.getSession();
            s.setAttribute("msg", msg);            
            response.sendRedirect("login");
        }
        else {
        	 //login success
            HttpSession s=request.getSession();
            s.setAttribute("currentUser", u);
           try {
			PreparedStatement ps=conn.prepareStatement("SELECT role FROM users WHERE email=?");
			ps.setString(1, email);
			ResultSet resultSet = ps.executeQuery();
			if (resultSet.next()) {
			String role=resultSet.getString("role");
			s.setAttribute("role", role);
			if(role.equals("admin")) {
				response.sendRedirect("./ADMIN/home.jsp");
			}
			else {
				response.sendRedirect("profile.jsp");
			}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
           
            
        }
		}
}
