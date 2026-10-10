package com.ecommerce.controller.admin;

import com.ecommerce.dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/products")
public class ManageProductsServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if ("delete".equalsIgnoreCase(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                productDAO.deleteProduct(productId);
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=product_deleted");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }
        } catch (SQLException e) {
            throw new ServletException("Product management operation failed", e);
        }
    }
}