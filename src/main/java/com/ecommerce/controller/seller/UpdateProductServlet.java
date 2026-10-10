package com.ecommerce.controller.seller;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/seller/update-product")
public class UpdateProductServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User seller = (User) session.getAttribute("currentUser");

        try {
            int productId = Integer.parseInt(req.getParameter("productId"));
            double price = Double.parseDouble(req.getParameter("price"));
            int stock = Integer.parseInt(req.getParameter("stock"));

            boolean updated = productDAO.updateProductPriceAndStock(productId, seller.getUserId(), price, stock);
            if (updated) {
                session.setAttribute("message", "Product updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update product.");
            }
        } catch (Exception e) {
            session.setAttribute("error", "Invalid price or stock values provided.");
        }

        resp.sendRedirect(req.getContextPath() + "/seller/dashboard");
    }
}