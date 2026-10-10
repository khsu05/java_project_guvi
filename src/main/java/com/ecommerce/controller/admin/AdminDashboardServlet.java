package com.ecommerce.controller.admin;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.Order;
import com.ecommerce.model.Product;
import com.ecommerce.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private UserDAO userDAO;
    private ProductDAO productDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<User> users = userDAO.getAllUsers();
            List<Product> products = productDAO.getAllAvailableProducts();
            List<Order> orders = orderDAO.getAllOrders();

            req.setAttribute("users", users);
            req.setAttribute("products", products);
            req.setAttribute("orders", orders);

            // Compute summary metrics for activity monitoring
            req.setAttribute("totalUsers", users.size());
            req.setAttribute("totalProducts", products.size());
            req.setAttribute("totalOrders", orders.size());

            req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Failed to load admin dashboard data", e);
        }
    }
}