package com.ecommerce.controller.seller;

import com.ecommerce.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/seller/orders", "/seller/update-order-status"})
public class UpdateOrderStatusServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int orderId = Integer.parseInt(req.getParameter("orderId"));
        String newStatus = req.getParameter("status");

        try {
            orderDAO.updateOrderStatus(orderId, newStatus);
            resp.sendRedirect(req.getContextPath() + "/seller/dashboard?msg=order_updated");
        } catch (SQLException e) {
            throw new ServletException("Order status update failed", e);
        }
    }
}