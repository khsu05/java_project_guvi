<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Platform Login</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #f4f6f9; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        .login-card { background: #ffffff; padding: 32px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 340px; }
        .login-card h2 { margin-top: 0; text-align: center; color: #222; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 500; font-size: 14px; }
        .form-group input { width: 100%; box-sizing: border-box; padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
        .btn-submit { width: 100%; background: #0066cc; color: #fff; padding: 10px; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; }
        .btn-submit:hover { background: #0052a3; }
        .alert-error { color: #d93025; background: #fde7e9; padding: 10px; border-radius: 4px; font-size: 13px; margin-bottom: 16px; text-align: center; }
        .alert-info { color: #1e4620; background: #def2d6; padding: 10px; border-radius: 4px; font-size: 13px; margin-bottom: 16px; text-align: center; }
    </style>
</head>
<body>

<div class="login-card">
    <h2>Marketplace Sign In</h2>

    <c:if test="${not empty errorMessage}">
        <div class="alert-error">${errorMessage}</div>
    </c:if>
    <c:if test="${param.message eq 'logged_out'}">
        <div class="alert-info">You have been logged out successfully.</div>
    </c:if>
    <c:if test="${param.error eq 'unauthorized'}">
        <div class="alert-error">Please log in to continue.</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="POST">
        <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="e.g. buyer@ecommerce.com" required autofocus>
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="••••••••" required>
        </div>
        <button type="submit" class="btn-submit">Sign In</button>
    </form>
</div>

</body>
</html>