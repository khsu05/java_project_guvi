<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Market-HUB | Welcome & Sign In</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --header-bg: #ffffff;
            --hero-pink-start: #ffc0cb;
            --hero-pink-end: #f9a8d4;
            --accent-dark: #0f172a;
            --accent-rose: #be123c;
            --accent-rose-hover: #9f1239;
            --text-dark: #1e293b;
            --text-muted: #475569;
            --border-dark: #0f172a;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }

        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: var(--hero-pink-start);
            color: var(--text-dark);
        }

        /* Top Navigation Bar (Matches Wireframe Header) */
        .top-navbar {
            background-color: var(--header-bg);
            padding: 14px 36px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 3px solid var(--border-dark);
            position: sticky;
            top: 0;
            z-index: 50;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .brand-logo {
            font-size: 22px;
            font-weight: 800;
            color: var(--accent-dark);
            text-decoration: none;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .brand-logo span {
            color: var(--accent-rose);
        }

        .btn-header-signin {
            background-color: #ffffff;
            color: var(--accent-dark);
            border: 2.5px solid var(--border-dark);
            padding: 8px 24px;
            font-size: 14px;
            font-weight: 700;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-header-signin:hover {
            background-color: var(--accent-dark);
            color: #ffffff;
        }

        /* Main Pink Hero Section (Matches Wireframe Body) */
        .hero-canvas {
            flex: 1;
            background: linear-gradient(135deg, #6726e0 0%, #647cc0 50%, #6549e4 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 40px 24px;
            position: relative;
        }

        .hero-content {
            max-width: 760px;
            z-index: 2;
        }

        .hero-badge {
            display: inline-block;
            background: rgba(255, 255, 255, 0.75);
            border: 1.5px solid var(--accent-dark);
            color: var(--accent-dark);
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 24px;
        }

        .hero-title {
            font-size: clamp(32px, 5vw, 54px);
            font-weight: 800;
            color: #881337;
            line-height: 1.15;
            margin-bottom: 22px;
            text-shadow: 0 1px 2px rgba(255, 255, 255, 0.5);
        }

        .hero-subtitle {
            font-size: clamp(18px, 2.5vw, 24px);
            font-weight: 600;
            color: #4c0519;
            margin-bottom: 36px;
        }

        .hero-cta-group {
            display: flex;
            gap: 14px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-primary-hero {
            background-color: var(--accent-dark);
            color: #ffffff;
            border: 2px solid var(--accent-dark);
            padding: 14px 32px;
            font-size: 15px;
            font-weight: 700;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.15s, background-color 0.2s;
            box-shadow: 0 8px 20px rgba(15, 23, 42, 0.2);
        }

        .btn-primary-hero:hover {
            background-color: #1e293b;
            transform: translateY(-2px);
        }

        /* Electronic Category Pills */
        .category-strip {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 48px;
        }

        .cat-pill {
            background: rgba(255, 255, 255, 0.65);
            backdrop-filter: blur(4px);
            padding: 8px 16px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            color: #4c0519;
            border: 1px solid rgba(136, 19, 55, 0.2);
        }

        /* Alert Banner (If Login Fails or Logout Occurs) */
        .alert-toast {
            background-color: #ffffff;
            border-left: 5px solid #dc2626;
            color: #991b1b;
            padding: 12px 20px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 24px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            display: inline-block;
        }

        .alert-toast.info {
            border-left-color: #16a34a;
            color: #166534;
        }

        /* Sign-In Modal Overlay */
        .modal-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.65);
            backdrop-filter: blur(4px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 200;
            padding: 16px;
        }

        .modal-backdrop.active {
            display: flex;
        }

        .signin-card {
            background: #ffffff;
            width: 100%;
            max-width: 410px;
            border-radius: 12px;
            border: 2px solid var(--border-dark);
            padding: 28px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.35);
            text-align: left;
            animation: popIn 0.2s ease-out;
        }

        @keyframes popIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }

        .signin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 1px solid #e2e8f0;
        }

        .signin-header h2 {
            font-size: 20px;
            font-weight: 800;
            color: var(--accent-dark);
        }

        .btn-close-modal {
            background: none;
            border: none;
            font-size: 24px;
            color: #64748b;
            cursor: pointer;
            line-height: 1;
        }

        .btn-close-modal:hover {
            color: var(--accent-dark);
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            color: #334155;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .form-group input {
            width: 100%;
            padding: 11px 14px;
            border: 1.5px solid #cbd5e1;
            border-radius: 6px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s;
        }

        .form-group input:focus {
            border-color: var(--accent-rose);
            box-shadow: 0 0 0 3px rgba(190, 18, 60, 0.12);
        }

        .btn-submit-login {
            width: 100%;
            background-color: var(--accent-rose);
            color: #ffffff;
            border: none;
            padding: 12px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 4px;
        }

        .btn-submit-login:hover {
            background-color: var(--accent-rose-hover);
        }

        /* Quick Demo Role Fillers */
        .demo-accounts {
            margin-top: 20px;
            padding-top: 14px;
            border-top: 1px dashed #cbd5e1;
        }

        .demo-accounts p {
            font-size: 11px;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .demo-btns {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 6px;
        }

        .btn-demo {
            background: #f8fafc;
            border: 1px solid #cbd5e1;
            padding: 6px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            color: #334155;
            cursor: pointer;
            transition: background 0.15s;
        }

        .btn-demo:hover {
            background: #e2e8f0;
        }
    </style>
</head>
<body>

    <!-- Top Header Bar -->
    <header class="top-navbar">
        <a href="${pageContext.request.contextPath}/login" class="brand-logo">
            Market-<span>HUB</span>
        </a>
        <button type="button" class="btn-header-signin" onclick="openSignInModal()">
            Sign In
        </button>
    </header>

    <!-- Main Pink Hero Area -->
    <main class="hero-canvas">
        <div class="hero-content">

            <!-- Display Error or Logout Message if Present -->
            <c:if test="${not empty error}">
                <div class="alert-toast">⚠ ${error}</div><br>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert-toast info">✓ ${message}</div><br>
            </c:if>

            <div class="hero-badge">⚡ Official Electronics Storefront</div>

            <h1 class="hero-title">Welcome to Market Hub</h1>

            <p class="hero-subtitle">All types of Electronic items available here</p>

            <div class="hero-cta-group">
                <button type="button" class="btn-primary-hero" onclick="openSignInModal()">
                    Sign In to Explore Deals →
                </button>
            </div>

            <div class="category-strip">
                <span class="cat-pill">🎧 Audio & Headphones</span>
                <span class="cat-pill">⌨️ Mechanical Keyboards</span>
                <span class="cat-pill">🔌 USB-C Hubs & Docks</span>
                <span class="cat-pill">💻 Laptops & Accessories</span>
            </div>
        </div>
    </main>

    <!-- Sign-In Modal Popup -->
    <div id="signInModal" class="modal-backdrop ${not empty error ? 'active' : ''}">
        <div class="signin-card">
            <div class="signin-header">
                <h2>Sign In to Market-HUB</h2>
                <button type="button" class="btn-close-modal" onclick="closeSignInModal()">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="you@example.com" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn-submit-login">Sign In</button>
            </form>

            <!-- Quick One-Click Demo Logins -->
            <div class="demo-accounts">
                <p>Quick Demo Login:</p>
                <div class="demo-btns">
                    <button type="button" class="btn-demo" onclick="fillDemo('buyer@ecommerce.com', 'pass123')">Buyer</button>
                    <button type="button" class="btn-demo" onclick="fillDemo('seller@ecommerce.com', 'pass123')">Seller</button>
                    <button type="button" class="btn-demo" onclick="fillDemo('admin@ecommerce.com', 'pass123')">Admin</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function openSignInModal() {
            document.getElementById('signInModal').classList.add('active');
            setTimeout(() => document.getElementById('email').focus(), 100);
        }

        function closeSignInModal() {
            document.getElementById('signInModal').classList.remove('active');
        }

        function fillDemo(email, pass) {
            document.getElementById('email').value = email;
            document.getElementById('password').value = pass;
        }

        // Close modal if user clicks outside the card
        document.getElementById('signInModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeSignInModal();
            }
        });
    </script>

</body>
</html>