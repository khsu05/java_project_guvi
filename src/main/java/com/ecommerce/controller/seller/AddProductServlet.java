package com.ecommerce.controller.seller;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Product;
import com.ecommerce.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet("/seller/add-product")
public class AddProductServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User seller = (User) session.getAttribute("currentUser");

        String name = req.getParameter("name");
        String description = req.getParameter("description");
        BigDecimal price = new BigDecimal(req.getParameter("price"));
        int stock = Integer.parseInt(req.getParameter("stock"));

        Product product = new Product(0, seller.getUserId(), name, description, price, stock);

        try {
            boolean success = productDAO.addProduct(product);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/seller/dashboard?msg=product_added");
            } else {
                resp.sendRedirect(req.getContextPath() + "/seller/dashboard?error=failed");
            }
        } catch (SQLException e) {
            throw new ServletException("Error saving new product", e);
        }
    }
}