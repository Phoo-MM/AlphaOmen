package com.alphaomen.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DB {
    private static final String URL = "jdbc:mysql://localhost:3306/alldb";
    private static final String USER = "root"; // change if needed
    private static final String PASSWORD = ""; // change if needed
    
    private static Connection connection = null;
    
    public static Connection getConnection(){
    	try {
            if (connection == null || connection.isClosed()) {
                // Load MySQL driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                // Establish connection
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database connection failed", e);
        }
        return connection;
    }
}