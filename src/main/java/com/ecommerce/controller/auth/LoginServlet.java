package com.ecommerce.controller.auth;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            User user = userDAO.login(email, password);
            if (user != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("currentUser", user);

                // Dispatch to role-specific dashboard
                switch (user.getRole().toUpperCase()) {
                    case "ADMIN" -> resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                    case "SELLER" -> resp.sendRedirect(req.getContextPath() + "/seller/dashboard");
                    case "BUYER" -> resp.sendRedirect(req.getContextPath() + "/buyer/dashboard");
                    default -> resp.sendRedirect(req.getContextPath() + "/login?error=invalid_role");
                }
            } else {
                req.setAttribute("errorMessage", "Invalid email or password");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error during authentication", e);
        }
    }
}