package com.ecommerce.dao;

import com.ecommerce.config.DBConnection;
import com.ecommerce.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Authenticate user by email and plain-text password using BCrypt
    public User login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");
                    if (BCrypt.checkpw(password, storedHash)) {
                        User user = new User();
                        user.setUserId(rs.getInt("user_id"));
                        user.setName(rs.getString("name"));
                        user.setEmail(rs.getString("email"));
                        user.setRole(rs.getString("role"));
                        user.setCreatedAt(rs.getTimestamp("created_at"));
                        return user;
                    }
                }
            }
        }
        return null; // Login failed
    }

    // Register a new user with BCrypt hashed password
    public boolean register(User user) throws SQLException {
        String sql = "INSERT INTO users (name, email, password_hash, role) VALUES (?, ?, ?, ?)";
        String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt(10));

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashedPassword);
            ps.setString(4, user.getRole());
            return ps.executeUpdate() > 0;
        }
    }

    // Admin functionality: retrieve all users
    public List<User> getAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT user_id, name, email, role, created_at FROM users ORDER BY user_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(u);
            }
        }
        return list;
    }

    // Admin functionality: delete a user
    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }
}