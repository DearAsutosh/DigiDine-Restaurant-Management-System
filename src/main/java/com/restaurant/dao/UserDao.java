package com.restaurant.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.restaurant.entities.User;

public class UserDao {
	private Connection con;

	public UserDao(Connection con) {
		this.con = con;
	}

	// Method to insert user into database
	public boolean saveUser(User user) {
		boolean success = false;
		String query = "INSERT INTO users(name, email, password, address, gender, mobileNumber) VALUES (?, ?, ?, ?, ?, ?)";

		try (PreparedStatement pstmt = this.con.prepareStatement(query)) {
			pstmt.setString(1, user.getName());
			pstmt.setString(2, user.getEmail());
			pstmt.setString(3, user.getPassword()); // Ensure this is hashed
			pstmt.setString(4, user.getAddress()); // Set address
			pstmt.setString(5, user.getGender());
			pstmt.setString(6, user.getMobileNumber());

			int rowsInserted = pstmt.executeUpdate();
			success = rowsInserted > 0;
		} catch (SQLException e) {
			e.printStackTrace(); // Consider using a logging framework
		}
		return success;
	}

	// Get user by email and password
	public User getUserByEmailAndPassword(String email, String password) {
		User user = null;
		String query = "SELECT * FROM users WHERE email=? AND password=?";

		try (PreparedStatement pstmt = this.con.prepareStatement(query)) {
			pstmt.setString(1, email);
			pstmt.setString(2, password); // Ensure this is hashed for comparison
			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				user = new User();
				user.setId(rs.getInt("userid"));
				user.setName(rs.getString("name"));
				user.setEmail(rs.getString("email"));
				user.setPassword(rs.getString("password")); // Avoid returning this
				user.setAddress(rs.getString("address")); // Retrieve address
				user.setGender(rs.getString("gender"));
				user.setMobileNumber(rs.getString("mobileNumber"));
				user.setDateTime(rs.getTimestamp("registered_on"));
			}
		} catch (SQLException e) {
			e.printStackTrace(); // Consider using a logging framework
		}
		return user;
	}

	// Update user details
	public boolean updateUser(User user) {
		boolean success = false;
		String query = "UPDATE users SET name=?, email=?, password=?, address=?, gender=?, mobileNumber=? WHERE userid=?";

		try (PreparedStatement pstmt = con.prepareStatement(query)) {
			pstmt.setString(1, user.getName());
			pstmt.setString(2, user.getEmail());
			pstmt.setString(3, user.getPassword());
			pstmt.setString(4, user.getAddress());
			pstmt.setString(5, user.getGender());
			pstmt.setString(6, user.getMobileNumber());
			pstmt.setInt(7, user.getId());

			int rowsUpdated = pstmt.executeUpdate();
			success = rowsUpdated > 0;
		} catch (SQLException e) {
			e.printStackTrace(); // Consider using a logging framework
		}
		return success;
	}

	// check if emailexist or not
	public boolean isEmailRegistered(String email) {
		boolean exists = false;
		String query = "SELECT userid FROM users WHERE email = ?";
		try (PreparedStatement pstmt = con.prepareStatement(query)) {
			pstmt.setString(1, email);
			ResultSet rs = pstmt.executeQuery();
			exists = rs.next(); // If any row is returned, email exists
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return exists;
	}

}