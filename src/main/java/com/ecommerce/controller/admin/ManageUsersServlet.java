package com.ecommerce.controller.admin;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/users")
public class ManageUsersServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if ("delete".equalsIgnoreCase(action)) {
                int userId = Integer.parseInt(req.getParameter("userId"));
                userDAO.deleteUser(userId);
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=user_deleted");
            } else if ("create".equalsIgnoreCase(action)) {
                User newUser = new User();
                newUser.setName(req.getParameter("name"));
                newUser.setEmail(req.getParameter("email"));
                newUser.setPassword(req.getParameter("password"));
                newUser.setRole(req.getParameter("role"));

                userDAO.register(newUser);
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=user_created");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }
        } catch (SQLException e) {
            throw new ServletException("User management operation failed", e);
        }
    }
}