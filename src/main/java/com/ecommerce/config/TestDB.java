package com.ecommerce.config;

import java.sql.Connection;
import java.sql.PreparedStatement;
import org.mindrot.jbcrypt.BCrypt;

public class TestDB {
    public static void main(String[] args) {
        String plainPassword = "pass123";
        String hashed = BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
        System.out.println("Generated Hash: " + hashed);

        String sql = "UPDATE users SET password_hash = ? WHERE email = ?";

        try (Connection conn = DBConnection.getConnection()) {
            // Update admin
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, hashed);
                ps.setString(2, "admin@ecommerce.com");
                ps.executeUpdate();
            }
            // Update seller
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, hashed);
                ps.setString(2, "seller@ecommerce.com");
                ps.executeUpdate();
            }
            // Update buyer
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, hashed);
                ps.setString(2, "buyer@ecommerce.com");
                ps.executeUpdate();
            }

            System.out.println(" Successfully updated all 3 accounts with fresh Java-generated BCrypt hash!");
            
            // Double check verification
            boolean match = BCrypt.checkpw("pass123", hashed);
            System.out.println("Verification check (pass123): " + (match ? "PASSED" : "FAILED"));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}