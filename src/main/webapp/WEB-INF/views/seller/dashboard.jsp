<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Central | Supplier Hub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --seller-nav: #1b2838;
            --seller-sub: #2a475e;
            --primary-accent: #2563eb;
            --primary-hover: #1d4ed8;
            --bg-page: #f1f5f9;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --badge-green: #16a34a;
            --badge-amber: #d97706;
            --badge-red: #dc2626;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }

        body {
            background-color: var(--bg-page);
            color: var(--text-main);
            min-height: 100vh;
        }

        /* Header */
        .seller-navbar {
            background-color: var(--seller-nav);
            color: white;
            padding: 12px 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 3px solid var(--primary-accent);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .seller-brand {
            font-size: 20px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
            color: white;
            text-decoration: none;
        }

        .seller-brand span {
            color: #60a5fa;
        }

        .seller-brand .tag {
            background: rgba(37, 99, 235, 0.25);
            color: #93c5fd;
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 4px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .seller-user-section {
            display: flex;
            align-items: center;
            gap: 16px;
            font-size: 13px;
        }

        .store-chip {
            background: rgba(255, 255, 255, 0.08);
            padding: 6px 14px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn-logout {
            background: #ef4444;
            color: white;
            padding: 6px 14px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            transition: background 0.2s;
        }

        .btn-logout:hover {
            background: #dc2626;
        }

        /* Container */
        .container {
            max-width: 1400px;
            margin: 24px auto;
            padding: 0 24px;
        }

        /* Alert Banners */
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

        .alert-error {
            background-color: #f8d7da;
            border-left-color: #842029;
            color: #842029;
        }

        /* KPI Metric Cards */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 18px;
            margin-bottom: 24px;
        }

        .kpi-card {
            background: var(--card-bg);
            border-radius: 8px;
            border: 1px solid var(--border-color);
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 1px 3px rgba(0,0,0,0.04);
        }

        .kpi-meta h4 {
            font-size: 12px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .kpi-meta .kpi-value {
            font-size: 26px;
            font-weight: 700;
            color: var(--text-main);
        }

        .kpi-icon {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            background: #eff6ff;
            color: var(--primary-accent);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }

        /* Split Workspace Grid */
        .workspace-grid {
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 24px;
            margin-bottom: 30px;
        }

        @media (max-width: 992px) {
            .workspace-grid {
                grid-template-columns: 1fr;
            }
        }

        .panel-card {
            background: var(--card-bg);
            border-radius: 8px;
            border: 1px solid var(--border-color);
            padding: 22px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.04);
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 12px;
        }

        .panel-header h3 {
            font-size: 16px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Form Styles */
        .listing-form {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .form-group label {
            font-size: 12px;
            font-weight: 600;
            color: #334155;
        }

        .form-group input, .form-group textarea {
            padding: 10px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 13px;
            outline: none;
            transition: border-color 0.2s;
        }

        .form-group input:focus, .form-group textarea:focus {
            border-color: var(--primary-accent);
            box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.15);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 70px;
        }

        .btn-submit-listing {
            background-color: var(--primary-accent);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 12px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 4px;
        }

        .btn-submit-listing:hover {
            background-color: var(--primary-hover);
        }

        /* Tables */
        .table-responsive {
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .data-table th {
            background-color: #f8fafc;
            color: var(--text-muted);
            font-weight: 600;
            text-align: left;
            padding: 12px 14px;
            border-bottom: 1px solid var(--border-color);
            text-transform: uppercase;
            font-size: 11px;
            letter-spacing: 0.5px;
        }

        .data-table td {
            padding: 14px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .data-table tr:hover td {
            background-color: #f8fafc;
        }

        /* Stock Health Badges */
        .stock-badge {
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 12px;
            display: inline-block;
        }

        .stock-ok { background: #dcfce7; color: var(--badge-green); }
        .stock-warning { background: #fef3c7; color: var(--badge-amber); }
        .stock-empty { background: #fee2e2; color: var(--badge-red); }

        .btn-edit-action {
            background: #f1f5f9;
            border: 1px solid #cbd5e1;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            color: #1e293b;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-edit-action:hover {
            background: #e2e8f0;
            border-color: #94a3b8;
        }

        /* Order fulfillment control */
        .fulfillment-form {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .status-select {
            padding: 6px 8px;
            border: 1px solid #cbd5e1;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            outline: none;
        }

        .btn-update-status {
            background: #0f172a;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn-update-status:hover {
            background: #334155;
        }

        /* Modal Popup Styles */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(15, 23, 42, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            backdrop-filter: blur(2px);
        }

        .modal-card {
            background: #ffffff;
            border-radius: 8px;
            width: 100%;
            max-width: 400px;
            padding: 24px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 10px;
        }

        .modal-header h3 {
            font-size: 16px;
            color: #0f172a;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 22px;
            cursor: pointer;
            color: #64748b;
        }

        .modal-cancel-btn {
            background: #f8fafc;
            border: 1px solid #cbd5e1;
            color: #475569;
            padding: 10px 16px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }

        .modal-cancel-btn:hover {
            background: #f1f5f9;
        }
    </style>
</head>
<body>

    <!-- Supplier Header -->
    <header class="seller-navbar">
        <a href="${pageContext.request.contextPath}/seller/dashboard" class="seller-brand">
            market<span>hub</span>
            <span class="tag">Seller Central</span>
        </a>

        <div class="seller-user-section">
            <div class="store-chip">
                <span>🏪</span>
                <strong>${sessionScope.currentUser.name}</strong>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
        </div>
    </header>

    <main class="container">

        <!-- Flash Notices -->
        <c:if test="${not empty message}">
            <div class="alert-banner">✓ ${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert-banner alert-error">⚠ ${error}</div>
        </c:if>

        <!-- KPI Metric Tiles -->
        <section class="kpi-grid">
            <div class="kpi-card">
                <div class="kpi-meta">
                    <h4>Total Listed Products</h4>
                    <div class="kpi-value">${products.size()}</div>
                </div>
                <div class="kpi-icon">📦</div>
            </div>

            <div class="kpi-card">
                <div class="kpi-meta">
                    <h4>Fulfillment Orders</h4>
                    <div class="kpi-value">${orders.size()}</div>
                </div>
                <div class="kpi-icon">🚚</div>
            </div>

            <div class="kpi-card">
                <div class="kpi-meta">
                    <h4>Account Status</h4>
                    <div class="kpi-value" style="font-size: 18px; color: var(--badge-green);">ACTIVE ●</div>
                </div>
                <div class="kpi-icon">🛡️</div>
            </div>
        </section>

        <!-- Product Management Grid -->
        <div class="workspace-grid">
            
            <!-- Left: Add New Item Drawer -->
            <section class="panel-card">
                <div class="panel-header">
                    <h3>➕ Add New Listing</h3>
                </div>

                <form action="${pageContext.request.contextPath}/seller/add-product" method="POST" class="listing-form">
                    <div class="form-group">
                        <label for="name">Product Title</label>
                        <input type="text" id="name" name="name" placeholder="e.g. Wireless Mouse" required>
                    </div>

                    <div class="form-group">
                        <label for="price">Listing Price ($)</label>
                        <input type="number" id="price" name="price" step="0.01" min="0.01" placeholder="29.99" required>
                    </div>

                    <div class="form-group">
                        <label for="stock">Initial Stock Quantity</label>
                        <input type="number" id="stock" name="stock" min="1" placeholder="50" required>
                    </div>

                    <div class="form-group">
                        <label for="description">Short Description</label>
                        <textarea id="description" name="description" placeholder="Provide bullet points or key features..."></textarea>
                    </div>

                    <button type="submit" class="btn-submit-listing">Publish Listing</button>
                </form>
            </section>

            <!-- Right: Active Catalog Table -->
            <section class="panel-card">
                <div class="panel-header">
                    <h3>📋 Your Active Inventory</h3>
                    <span style="font-size: 12px; color: var(--text-muted);">${products.size()} items tracked</span>
                </div>

                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Product Details</th>
                                <th>Unit Price</th>
                                <th>Stock Health</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty products}">
                                    <c:forEach var="prod" items="${products}">
                                        <tr>
                                            <td>
                                                <strong style="color: #1e293b; display: block; font-size: 14px;">${prod.name}</strong>
                                                <span style="color: var(--text-muted); font-size: 11px;">ID: #${prod.productId}</span>
                                            </td>
                                            <td><strong style="font-size: 14px;">$${prod.price}</strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${prod.stock <= 0}">
                                                        <span class="stock-badge stock-empty">Sold Out (0)</span>
                                                    </c:when>
                                                    <c:when test="${prod.stock <= 5}">
                                                        <span class="stock-badge stock-warning">Low: ${prod.stock} left</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="stock-badge stock-ok">${prod.stock} in stock</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><span style="color: var(--badge-green); font-weight: 600; font-size: 12px;">Active</span></td>
                                            <td>
                                                <button type="button" class="btn-edit-action" 
                                                        onclick="openEditModal('${prod.productId}', '${prod.name}', '${prod.price}', '${prod.stock}')">
                                                    ✏️ Edit
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" style="text-align: center; padding: 24px; color: var(--text-muted);">
                                            No active listings found. Add your first item using the form on the left.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>

        <!-- Orders & Fulfillment Panel -->
        <section class="panel-card">
            <div class="panel-header">
                <h3>📦 Customer Orders & Dispatch Pipeline</h3>
                <span style="font-size: 12px; color: var(--text-muted);">${orders.size()} orders received</span>
            </div>

            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Total</th>
                            <th>Shipping Destination</th>
                            <th>Current Status</th>
                            <th>Update Fulfillment</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty orders}">
                                <c:forEach var="ord" items="${orders}">
                                    <tr>
                                        <td><strong>#${ord.orderId}</strong></td>
                                        <td><strong style="color: #16a34a;">$${ord.totalAmount}</strong></td>
                                        <td>${ord.shippingAddress}</td>
                                        <td>
                                            <span style="font-weight: 700; font-size: 12px;">
                                                ${ord.orderStatus}
                                            </span>
                                        </td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/seller/update-order-status" method="POST" class="fulfillment-form">
                                                <input type="hidden" name="orderId" value="${ord.orderId}">
                                                <select name="status" class="status-select">
                                                    <option value="PENDING" ${ord.orderStatus == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                                    <option value="SHIPPED" ${ord.orderStatus == 'SHIPPED' ? 'selected' : ''}>SHIPPED</option>
                                                    <option value="DELIVERED" ${ord.orderStatus == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                                                    <option value="CANCELLED" ${ord.orderStatus == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                                </select>
                                                <button type="submit" class="btn-update-status">Update</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" style="text-align: center; padding: 24px; color: var(--text-muted);">
                                        No customer orders currently in the pipeline.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>

    </main>

    <!-- Quick Edit Modal -->
    <div id="editModal" class="modal-overlay" style="display:none;">
        <div class="modal-card">
            <div class="modal-header">
                <h3 id="modalProductTitle">Update Inventory</h3>
                <button type="button" class="modal-close" onclick="closeEditModal()">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/seller/update-product" method="POST" class="listing-form">
                <input type="hidden" id="editProductId" name="productId">

                <div class="form-group">
                    <label for="editPrice">Listing Price ($)</label>
                    <input type="number" id="editPrice" name="price" step="0.01" min="0.01" required>
                </div>

                <div class="form-group">
                    <label for="editStock">Available Stock Units</label>
                    <input type="number" id="editStock" name="stock" min="0" required>
                </div>

                <div style="display: flex; gap: 10px; margin-top: 10px;">
                    <button type="submit" class="btn-submit-listing" style="flex: 1;">Save Changes</button>
                    <button type="button" class="modal-cancel-btn" onclick="closeEditModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Client-Side Modal Handlers -->
    <script>
        function openEditModal(id, name, price, stock) {
            document.getElementById('editProductId').value = id;
            document.getElementById('modalProductTitle').innerText = 'Update: ' + name;
            document.getElementById('editPrice').value = price;
            document.getElementById('editStock').value = stock;
            document.getElementById('editModal').style.display = 'flex';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        // Close modal if user clicks outside the modal card
        window.onclick = function(event) {
            const modal = document.getElementById('editModal');
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        };
    </script>
    <!-- Quick Edit Modal -->
    <div id="editModal" class="modal-overlay" style="display:none;">
        <div class="modal-card">
            <div class="modal-header">
                <h3 id="modalProductTitle" style="font-size: 16px; color: #0f172a;">Update Inventory</h3>
                <button type="button" class="modal-close" onclick="closeEditModal()">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/seller/update-product" method="POST" class="listing-form">
                <input type="hidden" id="editProductId" name="productId">

                <div class="form-group">
                    <label for="editPrice">Listing Price ($)</label>
                    <input type="number" id="editPrice" name="price" step="0.01" min="0.01" required>
                </div>

                <div class="form-group">
                    <label for="editStock">Available Stock Units</label>
                    <input type="number" id="editStock" name="stock" min="0" required>
                </div>

                <div style="display: flex; gap: 10px; margin-top: 10px;">
                    <button type="submit" class="btn-submit-listing" style="flex: 1;">Save Changes</button>
                    <button type="button" class="modal-cancel-btn" onclick="closeEditModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <style>
        .btn-edit-action {
            background: #f1f5f9;
            border: 1px solid #cbd5e1;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            color: #1e293b;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-edit-action:hover {
            background: #e2e8f0;
            border-color: #94a3b8;
        }
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            backdrop-filter: blur(2px);
        }
        .modal-card {
            background: #ffffff;
            border-radius: 8px;
            width: 100%;
            max-width: 400px;
            padding: 24px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2);
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 10px;
        }
        .modal-close {
            background: none; border: none; font-size: 22px; cursor: pointer; color: #64748b;
        }
        .modal-cancel-btn {
            background: #f8fafc;
            border: 1px solid #cbd5e1;
            color: #475569;
            padding: 10px 16px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }
        .modal-cancel-btn:hover { background: #f1f5f9; }
    </style>

    <script>
        function openEditModal(id, name, price, stock) {
            document.getElementById('editProductId').value = id;
            document.getElementById('modalProductTitle').innerText = 'Update: ' + name;
            document.getElementById('editPrice').value = price;
            document.getElementById('editStock').value = stock;
            document.getElementById('editModal').style.display = 'flex';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        window.onclick = function(event) {
            const modal = document.getElementById('editModal');
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        };
    </script>
</body>
</html>