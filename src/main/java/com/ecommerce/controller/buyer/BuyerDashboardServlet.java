package com.ecommerce.controller.buyer;

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

@WebServlet("/buyer/dashboard")
public class BuyerDashboardServlet extends HttpServlet {
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
        User buyer = (User) session.getAttribute("currentUser");

        try {
            List<Product> products = productDAO.getAllAvailableProducts();
            List<Order> orders = orderDAO.getOrdersByBuyer(buyer.getUserId());

            req.setAttribute("products", products);
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/WEB-INF/views/buyer/dashboard.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Failed to load buyer dashboard data", e);
        }
    }
}