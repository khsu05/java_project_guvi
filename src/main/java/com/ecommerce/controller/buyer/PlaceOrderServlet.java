package com.ecommerce.controller.buyer;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/buyer/order")
public class PlaceOrderServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User buyer = (User) session.getAttribute("currentUser");

        int productId = Integer.parseInt(req.getParameter("productId"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));
        String shippingAddress = req.getParameter("shippingAddress");

        try {
            boolean success = orderDAO.placeOrder(buyer.getUserId(), productId, quantity, shippingAddress);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/buyer/dashboard?status=order_success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/buyer/dashboard?status=out_of_stock");
            }
        } catch (SQLException e) {
            throw new ServletException("Order processing failed", e);
        }
    }
}