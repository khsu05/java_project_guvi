package com.ecommerce.controller.seller;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Order;
import com.ecommerce.model.Product;
import com.ecommerce.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/seller/dashboard")
public class SellerDashboardServlet extends HttpServlet {
    private ProductDAO productDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User seller = (User) session.getAttribute("currentUser");

        try {
            List<Product> products = productDAO.getProductsBySeller(seller.getUserId());
            List<Order> allOrders = orderDAO.getAllOrders(); // Shows active platform orders

            req.setAttribute("products", products);
            req.setAttribute("orders", allOrders);
            req.getRequestDispatcher("/WEB-INF/views/seller/dashboard.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Failed to load seller dashboard", e);
        }
    }
}