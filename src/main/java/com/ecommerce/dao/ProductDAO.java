package com.ecommerce.dao;

import com.ecommerce.config.DBConnection;
import com.ecommerce.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // Buyer browsing: get all products currently in stock
    public List<Product> getAllAvailableProducts() throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, u.name AS seller_name FROM products p " +
                     "JOIN users u ON p.seller_id = u.user_id " +
                     "WHERE p.stock > 0 ORDER BY p.product_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        }
        return products;
    }

    // Seller functionality: get inventory owned by this seller
    public List<Product> getProductsBySeller(int sellerId) throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, u.name AS seller_name FROM products p " +
                     "JOIN users u ON p.seller_id = u.user_id " +
                     "WHERE p.seller_id = ? ORDER BY p.product_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        }
        return products;
    }

    // Seller functionality: add new product
    public boolean addProduct(Product product) throws SQLException {
        String sql = "INSERT INTO products (seller_id, name, description, price, stock) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, product.getSellerId());
            ps.setString(2, product.getName());
            ps.setString(3, product.getDescription());
            ps.setBigDecimal(4, product.getPrice());
            ps.setInt(5, product.getStock());
            return ps.executeUpdate() > 0;
        }
    }

    // Delete product (Admin or Seller)
    public boolean deleteProduct(int productId) throws SQLException {
        String sql = "DELETE FROM products WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateProductPriceAndStock(int productId, int sellerId, double price, int stock) {
    String sql = "UPDATE products SET price = ?, stock = ? WHERE product_id = ? AND seller_id = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setDouble(1, price);
        ps.setInt(2, stock);
        ps.setInt(3, productId);
        ps.setInt(4, sellerId);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setSellerId(rs.getInt("seller_id"));
        p.setSellerName(rs.getString("seller_name"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setStock(rs.getInt("stock"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        return p;
    }
}