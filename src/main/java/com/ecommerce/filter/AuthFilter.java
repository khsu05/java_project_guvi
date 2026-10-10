package com.ecommerce.filter;

import com.ecommerce.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Whitelist public endpoints
        if (path.startsWith("/assets") || 
            path.startsWith("/login") || 
            path.startsWith("/register") || 
            path.equals("/") || 
            path.equals("/index.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Redirect unauthenticated requests to login page
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=unauthorized");
            return;
        }

        // Role-Based Access Control checks
        if (path.startsWith("/admin") && !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admins Only");
            return;
        }

        if (path.startsWith("/seller") && !"SELLER".equalsIgnoreCase(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Sellers Only");
            return;
        }

        if (path.startsWith("/buyer") && !"BUYER".equalsIgnoreCase(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Buyers Only");
            return;
        }

        chain.doFilter(request, response);
    }
}