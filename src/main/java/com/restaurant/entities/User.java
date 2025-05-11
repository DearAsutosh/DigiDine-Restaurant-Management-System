package com.restaurant.entities;

import java.sql.Timestamp;

public class User {
    private int id; // User ID
    private String name; // User's name
    private String email; // User's email
    private String password; // User's password
    private String address; // User's address
    private String gender; // User's gender
    private String mobileNumber; // User's mobile number
    private Timestamp dateTime; // Registration timestamp

    // Constructor with ID (for retrieving from database)
    public User(int id, String name, String address, String gender, Timestamp dateTime, String email, String mobileNumber, String password) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.gender = gender;
        this.dateTime = dateTime;
        this.mobileNumber = mobileNumber;
        this.address = address; // Initialize address
    }

    // Constructor without ID for new users
    public User(String name, String address, String gender, String email, String mobileNumber, String password) {
        this.name = name;
        this.address = address; // Initialize address
        this.email = email;
        this.password = password; // Ensure this is hashed before storage
        this.gender = gender;
        this.mobileNumber = mobileNumber;
    }

    // Default constructor
    public User() {}

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAddress() {
        return address; // Getter for address
    }

    public void setAddress(String address) {
        this.address = address; // Setter for address
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public Timestamp getDateTime() {
        return dateTime;
    }

    public void setDateTime(Timestamp dateTime) {
        this.dateTime = dateTime;
    }

    @Override
    public String toString() {
        return "User  [id=" + id + ", name=" + name + ", email=" + email + ", address=" + address + ", gender=" + gender + ", mobileNumber=" + mobileNumber + ", dateTime=" + dateTime + "]";
    }
}