package com.ecommerce.config;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static String url;
    private static String user;
    private static String password;

    static {
        // 1. Set baseline default configuration
        url = "jdbc:mysql://localhost:3306/ecommerce_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        user = "root";
        password = ""; // Kept blank for security in Git

        // 2. Attempt to load properties from a local db.properties file (if present)
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                Properties props = new Properties();
                props.load(input);

                if (props.getProperty("db.url") != null) {
                    url = props.getProperty("db.url");
                }
                if (props.getProperty("db.user") != null) {
                    user = props.getProperty("db.user");
                }
                if (props.getProperty("db.password") != null) {
                    password = props.getProperty("db.password");
                }
            }
        } catch (Exception e) {
            System.err.println("Notice: db.properties file not found or could not be read. Continuing with fallback/env config.");
        }

        // 3. Environment variables take highest precedence (standard for production/Docker/Cloud)
        if (System.getenv("DB_URL") != null) {
            url = System.getenv("DB_URL");
        }
        if (System.getenv("DB_USER") != null) {
            user = System.getenv("DB_USER");
        }
        if (System.getenv("DB_PASSWORD") != null) {
            password = System.getenv("DB_PASSWORD");
        }

        // 4. Load MySQL JDBC Driver
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Fatal: MySQL JDBC Driver not found on classpath.");
            e.printStackTrace();
        }
    }

    // Private constructor to prevent direct instantiation
    private DBConnection() {}

    /**
     * Provides an active SQL connection to the database.
     * @return Connection instance
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }
}