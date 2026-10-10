<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Operations Console | MarketHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --nav-bg: #0f172a;
            --accent-purple: #6366f1;
            --accent-purple-hover: #4f46e5;
            --bg-page: #f8fafc;
            --card-bg: #ffffff;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --badge-admin: #818cf8;
            --badge-seller: #38bdf8;
            --badge-buyer: #34d399;
            --danger-red: #ef4444;
            --danger-hover: #dc2626;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
        body { background-color: var(--bg-page); color: var(--text-dark); min-height: 100vh; }

        /* Global Header */
        .admin-navbar {
            background-color: var(--nav-bg);
            color: white;
            padding: 12px 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 3px solid var(--accent-purple);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .admin-brand {
            font-size: 20px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
            color: white;
            text-decoration: none;
        }

        .admin-brand .badge-tag {
            background: rgba(99, 102, 241, 0.2);
            color: #a5b4fc;
            border: 1px solid rgba(165, 180, 252, 0.3);
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 4px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        .admin-profile {
            display: flex;
            align-items: center;
            gap: 16px;
            font-size: 13px;
        }

        .user-tag {
            background: rgba(255, 255, 255, 0.08);
            padding: 6px 12px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn-logout {
            background: rgba(239, 68, 68, 0.15);
            color: #fca5a5;
            border: 1px solid rgba(239, 68, 68, 0.3);
            padding: 6px 14px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-logout:hover { background: var(--danger-red); color: white; }

        /* Container */
        .container {
            max-width: 1400px;
            margin: 24px auto;
            padding: 0 24px;
        }

        /* Banner Alerts */
        .alert-banner {
            background-color: #d1e7dd;
            border-left: 5px solid #0f5132;
            color: #0f5132;
            padding: 12px 18px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 13px;
            font-weight: 500;
        }

        /* KPI Grid */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
            margin-bottom: 28px;
        }

        .kpi-card {
            background: var(--card-bg);
            border-radius: 10px;
            border: 1px solid var(--border-color);
            padding: 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
            position: relative;
            overflow: hidden;
        }

        .kpi-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--accent-purple), #a855f7);
        }

        .kpi-meta h4 {
            font-size: 12px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }

        .kpi-meta .kpi-num {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-dark);
        }

        .kpi-icon {
            width: 52px;
            height: 52px;
            border-radius: 12px;
            background: #eef2ff;
            color: var(--accent-purple);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }

        /* Panel Sections */
        .panel {
            background: var(--card-bg);
            border-radius: 10px;
            border: 1px solid var(--border-color);
            padding: 24px;
            margin-bottom: 28px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 14px;
        }

        .panel-header h3 {
            font-size: 17px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .panel-header .counter {
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 500;
        }

        /* Tables */
        .table-responsive {
            overflow-x: auto;
        }

        .admin-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .admin-table th {
            background-color: #f8fafc;
            color: var(--text-muted);
            font-weight: 600;
            text-align: left;
            padding: 12px 16px;
            border-bottom: 1px solid var(--border-color);
            text-transform: uppercase;
            font-size: 11px;
            letter-spacing: 0.5px;
        }

        .admin-table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .admin-table tr:hover td {
            background-color: #f8fafc;
        }

        /* Role Badges */
        .role-pill {
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            display: inline-block;
            letter-spacing: 0.5px;
        }

        .role-ADMIN { background: #e0e7ff; color: #4338ca; }
        .role-SELLER { background: #e0f2fe; color: #0369a1; }
        .role-BUYER { background: #dcfce7; color: #15803d; }

        /* Action Buttons */
        .btn-delete {
            background: #fee2e2;
            color: var(--danger-red);
            border: 1px solid #fecaca;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-delete:hover {
            background: var(--danger-red);
            color: white;
        }

        /* User Provisioning Form */
        .provision-box {
            background: #f8fafc;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }

        .provision-box h4 {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 14px;
            color: var(--text-dark);
        }

        .inline-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)) 140px;
            gap: 12px;
            align-items: end;
        }

        .form-field {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .form-field label {
            font-size: 11px;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        .form-field input, .form-field select {
            padding: 9px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 13px;
            outline: none;
            background: white;
            transition: border-color 0.2s;
        }

        .form-field input:focus, .form-field select:focus {
            border-color: var(--accent-purple);
            box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.2);
        }

        .btn-add-user {
            background: var(--accent-purple);
            color: white;
            border: none;
            padding: 10px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
            height: 39px;
        }

        .btn-add-user:hover { background: var(--accent-purple-hover); }

        /* Order Status Pills */
        .order-badge {
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 14px;
            text-transform: uppercase;
        }

        .status-PENDING { background: #fef3c7; color: #92400e; }
        .status-SHIPPED { background: #e0f2fe; color: #0369a1; }
        .status-DELIVERED { background: #dcfce7; color: #15803d; }
        .status-CANCELLED { background: #fee2e2; color: #991b1b; }
    </style>
</head>
<body>

    <!-- Enterprise Navbar -->
    <header class="admin-navbar">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-brand">
            market<span>hub</span>
            <span class="badge-tag">Platform Governance</span>
        </a>

        <div class="admin-profile">
            <div class="user-tag">
                <span>🛡️</span>
                <strong>${sessionScope.currentUser.name}</strong>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
        </div>
    </header>

    <main class="container">

        <!-- Flash Notice -->
        <c:if test="${not empty message}">
            <div class="alert-banner">✓ ${message}</div>
        </c:if>

        <!-- KPI Metrics Grid -->
        <section class="kpi-grid">
            <div class="kpi-card">
                <div class="kpi-meta">
                    <h4>Platform Accounts</h4>
                    <div class="kpi-num">${users.size()}</div>
                </div>
                <div class="kpi-icon">👥</div>
            </div>

            <div class="kpi-card">
                <div class="kpi-meta">
                    <h4>Listed Products</h4>
                    <div class="kpi-num">${products.size()}</div>
                </div>
                <div class="kpi-icon">📦</div>
            </div>

            <div class="kpi-card">
                <div class="kpi-meta">
                    <h4>Total Orders Executed</h4>
                    <div class="kpi-num">${orders.size()}</div>
                </div>
                <div class="kpi-icon">📈</div>
            </div>
        </section>

        <!-- Panel 1: User Governance & Provisioning -->
        <section class="panel">
            <div class="panel-header">
                <h3>👥 Registered User Accounts</h3>
                <span class="counter">${users.size()} active accounts</span>
            </div>

            <div class="table-responsive">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Full Name</th>
                            <th>Email Address</th>
                            <th>Assigned Role</th>
                            <th>Created Timestamp</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td><strong>#${u.userId}</strong></td>
                                <td><strong style="color: #1e293b;">${u.name}</strong></td>
                                <td>${u.email}</td>
                                <td><span class="role-pill role-${u.role}">${u.role}</span></td>
                                <td style="color: var(--text-muted);">${u.createdAt}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Provision New Account -->
            <div class="provision-box">
                <h4>➕ Provision New User Account</h4>
                <form action="${pageContext.request.contextPath}/admin/users" method="POST" class="inline-form">
                    <div class="form-field">
                        <label for="uname">Full Name</label>
                        <input type="text" id="uname" name="name" placeholder="John Doe" required>
                    </div>

                    <div class="form-field">
                        <label for="uemail">Email</label>
                        <input type="email" id="uemail" name="email" placeholder="john@example.com" required>
                    </div>

                    <div class="form-field">
                        <label for="upass">Password</label>
                        <input type="password" id="upass" name="password" placeholder="••••••••" required>
                    </div>

                    <div class="form-field">
                        <label for="urole">Role</label>
                        <select id="urole" name="role" required>
                            <option value="BUYER">BUYER</option>
                            <option value="SELLER">SELLER</option>
                            <option value="ADMIN">ADMIN</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-add-user">Create User</button>
                </form>
            </div>
        </section>

        <!-- Panel 2: Catalog Moderation -->
        <section class="panel">
            <div class="panel-header">
                <h3>📦 Marketplace Product Catalog</h3>
                <span class="counter">${products.size()} total products</span>
            </div>

            <div class="table-responsive">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Product ID</th>
                            <th>Title</th>
                            <th>Unit Price</th>
                            <th>Stock Count</th>
                            <th>Seller ID</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty products}">
                                <c:forEach var="p" items="${products}">
                                    <tr>
                                        <td><strong>#${p.productId}</strong></td>
                                        <td><strong style="color: #1e293b;">${p.name}</strong></td>
                                        <td>$${p.price}</td>
                                        <td>${p.stock} units</td>
                                        <td>Seller #${p.sellerId}</td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin/products" method="POST" onsubmit="return confirm('Permanently remove this product listing?');">
                                                <input type="hidden" name="productId" value="${p.productId}">
                                                <button type="submit" class="btn-delete">Remove</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 20px;">
                                        No catalog products found.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Panel 3: Global Orders Audit -->
        <section class="panel">
            <div class="panel-header">
                <h3>📑 Platform Transactions & Audit Log</h3>
                <span class="counter">${orders.size()} processed transactions</span>
            </div>

            <div class="table-responsive">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Buyer ID</th>
                            <th>Amount</th>
                            <th>Shipping Address</th>
                            <th>Status</th>
                            <th>Placed At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty orders}">
                                <c:forEach var="o" items="${orders}">
                                    <tr>
                                        <td><strong>#${o.orderId}</strong></td>
                                        <td>User #${o.buyerId}</td>
                                        <td><strong style="color: #15803d;">$${o.totalAmount}</strong></td>
                                        <td>${o.shippingAddress}</td>
                                        <td><span class="order-badge status-${o.orderStatus}">${o.orderStatus}</span></td>
                                        <td style="color: var(--text-muted);">${o.createdAt}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 20px;">
                                        No platform orders found.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>

    </main>
</body>
</html>