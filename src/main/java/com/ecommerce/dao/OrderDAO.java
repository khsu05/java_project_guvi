package com.ecommerce.dao;

import com.ecommerce.config.DBConnection;
import com.ecommerce.model.Order;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /**
     * Executes atomic purchase:
     * 1. Checks available stock with row-level locking (FOR UPDATE).
     * 2. Decrements stock count.
     * 3. Inserts row into orders table.
     * 4. Inserts line-item into order_items table.
     */
    public boolean placeOrder(int buyerId, int productId, int quantity, String shippingAddress) throws SQLException {
        String selectProductSql = "SELECT price, stock, seller_id FROM products WHERE product_id = ? FOR UPDATE";
        String updateStockSql = "UPDATE products SET stock = stock - ? WHERE product_id = ?";
        String insertOrderSql = "INSERT INTO orders (buyer_id, total_amount, order_status, shipping_address) VALUES (?, ?, 'PENDING', ?)";
        String insertOrderItemSql = "INSERT INTO order_items (order_id, product_id, seller_id, quantity, unit_price) VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin ACID transaction

            BigDecimal price;
            int currentStock;
            int sellerId;

            // 1. Verify stock availability with lock
            try (PreparedStatement ps = conn.prepareStatement(selectProductSql)) {
                ps.setInt(1, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }
                    price = rs.getBigDecimal("price");
                    currentStock = rs.getInt("stock");
                    sellerId = rs.getInt("seller_id");
                }
            }

            if (currentStock < quantity) {
                conn.rollback();
                return false; // Not enough inventory
            }

            // 2. Decrement stock
            try (PreparedStatement ps = conn.prepareStatement(updateStockSql)) {
                ps.setInt(1, quantity);
                ps.setInt(2, productId);
                ps.executeUpdate();
            }

            // 3. Create Order
            int orderId = 0;
            BigDecimal totalAmount = price.multiply(BigDecimal.valueOf(quantity));
            try (PreparedStatement ps = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, buyerId);
                ps.setBigDecimal(2, totalAmount);
                ps.setString(3, shippingAddress);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    }
                }
            }

            // 4. Create Order Item
            try (PreparedStatement ps = conn.prepareStatement(insertOrderItemSql)) {
                ps.setInt(1, orderId);
                ps.setInt(2, productId);
                ps.setInt(3, sellerId);
                ps.setInt(4, quantity);
                ps.setBigDecimal(5, price);
                ps.executeUpdate();
            }

            conn.commit(); // Transaction complete
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    // Buyer functionality: get orders made by this buyer
    public List<Order> getOrdersByBuyer(int buyerId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE buyer_id = ? ORDER BY order_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, buyerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        }
        return orders;
    }

    // Admin & Seller functionality: update order status
    public boolean updateOrderStatus(int orderId, String newStatus) throws SQLException {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    // Admin functionality: list all orders across the system
    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.name AS buyer_name FROM orders o " +
                     "JOIN users u ON o.buyer_id = u.user_id ORDER BY o.order_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setBuyerName(rs.getString("buyer_name"));
                orders.add(order);
            }
        }
        return orders;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setBuyerId(rs.getInt("buyer_id"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setOrderStatus(rs.getString("order_status"));
        o.setShippingAddress(rs.getString("shipping_address"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        return o;
    }
}