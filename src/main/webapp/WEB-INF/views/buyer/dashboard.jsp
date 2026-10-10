<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Marketplace Storefront | Buyer Portal</title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <style>
                :root {
                    --nav-bg: #131921;
                    --nav-sub: #232f3e;
                    --accent: #febd69;
                    --btn-buy: #ffd814;
                    --btn-buy-hover: #f7ca00;
                    --text-dark: #0f1111;
                    --text-muted: #565959;
                    --bg-light: #eaeded;
                    --card-bg: #ffffff;
                    --badge-green: #007600;
                    --badge-orange: #b12704;
                }

                * {
                    box-sizing: border-box;
                    margin: 0;
                    padding: 0;
                    font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
                }

                body {
                    background-color: var(--bg-light);
                    color: var(--text-dark);
                    min-height: 100vh;
                }

                .navbar {
                    background-color: var(--nav-bg);
                    color: white;
                    padding: 10px 24px;
                    display: flex;
                    align-items: center;
                    gap: 20px;
                    position: sticky;
                    top: 0;
                    z-index: 100;
                }

                .nav-logo {
                    font-size: 22px;
                    font-weight: 700;
                    display: flex;
                    align-items: center;
                    gap: 4px;
                    color: white;
                    text-decoration: none;
                }

                .nav-logo span {
                    color: var(--accent);
                }

                .nav-delivery {
                    display: flex;
                    flex-direction: column;
                    font-size: 12px;
                    color: #ccc;
                }

                .nav-delivery strong {
                    font-size: 13px;
                    color: white;
                }

                .nav-search {
                    flex: 1;
                    max-width: 700px;
                    display: flex;
                }

                .nav-search input {
                    width: 100%;
                    padding: 10px 14px;
                    border-radius: 4px 0 0 4px;
                    border: none;
                    font-size: 14px;
                    outline: none;
                }

                .nav-search button {
                    background-color: var(--accent);
                    border: none;
                    padding: 0 18px;
                    border-radius: 0 4px 4px 0;
                    cursor: pointer;
                    font-weight: 600;
                }

                .nav-user {
                    margin-left: auto;
                    display: flex;
                    align-items: center;
                    gap: 16px;
                    font-size: 13px;
                }

                .nav-user .greeting {
                    display: flex;
                    flex-direction: column;
                }

                .nav-user .greeting span {
                    color: #ccc;
                    font-size: 11px;
                }

                .logout-btn {
                    background: rgba(255, 255, 255, 0.12);
                    color: white;
                    padding: 6px 12px;
                    border-radius: 4px;
                    text-decoration: none;
                    font-size: 12px;
                    border: 1px solid rgba(255, 255, 255, 0.2);
                }

                .logout-btn:hover {
                    background: rgba(255, 255, 255, 0.22);
                }

                .subnav {
                    background-color: var(--nav-sub);
                    padding: 8px 24px;
                    display: flex;
                    align-items: center;
                    gap: 18px;
                    color: white;
                    font-size: 13px;
                }

                .subnav a {
                    color: white;
                    text-decoration: none;
                    padding: 4px 8px;
                    border-radius: 3px;
                }

                .subnav a:hover {
                    background-color: rgba(255, 255, 255, 0.15);
                }

                .main-container {
                    max-width: 1350px;
                    margin: 20px auto;
                    padding: 0 20px;
                }

                .alert-banner {
                    background-color: #d1e7dd;
                    border-left: 5px solid #0f5132;
                    color: #0f5132;
                    padding: 14px 20px;
                    border-radius: 6px;
                    margin-bottom: 20px;
                    font-weight: 500;
                }

                .alert-error {
                    background-color: #f8d7da;
                    border-left-color: #842029;
                    color: #842029;
                }

                .section-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-end;
                    margin-bottom: 16px;
                    border-bottom: 2px solid #cbd5e1;
                    padding-bottom: 8px;
                }

                .section-header h2 {
                    font-size: 20px;
                    font-weight: 700;
                }

                .section-header .count-badge {
                    font-size: 13px;
                    color: var(--text-muted);
                }

                .products-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                    gap: 20px;
                    margin-bottom: 40px;
                }

                .product-card {
                    background: var(--card-bg);
                    border-radius: 8px;
                    border: 1px solid #e2e8f0;
                    padding: 18px;
                    display: flex;
                    flex-direction: column;
                    transition: transform 0.2s, box-shadow 0.2s;
                }

                .product-card:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 8px 18px rgba(0, 0, 0, 0.06);
                }

                .card-img-placeholder {
                    width: 100%;
                    height: 150px;
                    background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                    border-radius: 6px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-bottom: 14px;
                    font-size: 40px;
                }

                .card-title {
                    font-size: 15px;
                    font-weight: 600;
                    margin-bottom: 6px;
                    line-height: 1.3;
                    height: 40px;
                    overflow: hidden;
                }

                .rating-row {
                    display: flex;
                    align-items: center;
                    gap: 6px;
                    margin-bottom: 10px;
                    font-size: 12px;
                }

                .stars {
                    color: #ffa41c;
                }

                .price-row {
                    display: flex;
                    align-items: baseline;
                    gap: 6px;
                    margin-bottom: 8px;
                }

                .price-main {
                    font-size: 24px;
                    font-weight: 700;
                }

                .stock-indicator {
                    font-size: 12px;
                    font-weight: 600;
                    margin-bottom: 12px;
                }

                .in-stock {
                    color: var(--badge-green);
                }

                .low-stock {
                    color: var(--badge-orange);
                }

                .order-form {
                    margin-top: auto;
                    display: flex;
                    flex-direction: column;
                    gap: 10px;
                }

                .form-row-qty {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    font-size: 12px;
                }

                .qty-stepper {
                    display: inline-flex;
                    border: 1px solid #cbd5e1;
                    border-radius: 4px;
                    overflow: hidden;
                }

                .qty-stepper button {
                    background: #f1f5f9;
                    border: none;
                    width: 26px;
                    height: 26px;
                    cursor: pointer;
                    font-weight: bold;
                }

                .qty-stepper input {
                    width: 36px;
                    text-align: center;
                    border: none;
                    font-size: 13px;
                    outline: none;
                }

                .address-field {
                    width: 100%;
                    padding: 8px 10px;
                    border: 1px solid #cbd5e1;
                    border-radius: 4px;
                    font-size: 12px;
                    outline: none;
                }

                .btn-order {
                    background-color: var(--btn-buy);
                    border: 1px solid #fcd200;
                    border-radius: 18px;
                    padding: 9px;
                    font-size: 13px;
                    font-weight: 600;
                    cursor: pointer;
                }

                .btn-order:hover {
                    background-color: var(--btn-buy-hover);
                }

                .orders-panel {
                    background: white;
                    border-radius: 8px;
                    border: 1px solid #e2e8f0;
                    padding: 20px;
                }

                .order-card-row {
                    border: 1px solid #e2e8f0;
                    border-radius: 6px;
                    margin-bottom: 14px;
                    overflow: hidden;
                }

                .order-card-header {
                    background-color: #f8fafc;
                    padding: 12px 18px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    font-size: 12px;
                    border-bottom: 1px solid #e2e8f0;
                }

                .meta-col {
                    display: flex;
                    flex-direction: column;
                }

                .meta-col span:first-child {
                    color: var(--text-muted);
                    font-size: 11px;
                }

                .order-card-body {
                    padding: 14px 18px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    font-size: 13px;
                }

                .status-badge {
                    padding: 5px 12px;
                    border-radius: 14px;
                    font-size: 11px;
                    font-weight: 700;
                    text-transform: uppercase;
                }

                .status-PENDING {
                    background-color: #fef3c7;
                    color: #92400e;
                }

                .status-SHIPPED {
                    background-color: #e0f2fe;
                    color: #0369a1;
                }

                .status-DELIVERED {
                    background-color: #dcfce7;
                    color: #15803d;
                }

                .status-CANCELLED {
                    background-color: #fee2e2;
                    color: #991b1b;
                }
            </style>
        </head>

        <body>

            <header class="navbar">
                <a href="${pageContext.request.contextPath}/buyer/dashboard" class="nav-logo">
                    market<span>hub</span>
                </a>

                <div class="nav-delivery">
                    <span>Deliver to ${sessionScope.currentUser.name}</span>
                    <strong>India 400001</strong>
                </div>

                <div class="nav-search">
                    <input type="text" id="liveSearchInput" placeholder="Search products..." onkeyup="filterCatalog()">
                    <button type="button">🔍</button>
                </div>

                <div class="nav-user">
                    <div class="greeting">
                        <span>Hello, ${sessionScope.currentUser.name}</span>
                        <strong>Account & Orders</strong>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Sign Out</a>
                </div>
            </header>

            <div class="subnav">
                <a href="#">All Categories</a>
                <a href="#">Electronics</a>
                <a href="#">Computers</a>
                <a href="#">Deals</a>
            </div>

            <main class="main-container">
                <c:if test="${not empty message}">
                    <div class="alert-banner">✓ ${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert-banner alert-error">⚠ ${error}</div>
                </c:if>

                <section>
                    <div class="section-header">
                        <h2>Featured Products</h2>
                        <span class="count-badge" id="productCount">${products.size()} items available</span>
                    </div>

                    <div class="products-grid" id="productGrid">
                        <c:choose>
                            <c:when test="${not empty products}">
                                <c:forEach var="prod" items="${products}">
                                    <div class="product-card" data-title="${prod.name.toLowerCase()}">
                                        <div class="card-img-placeholder">📦</div>
                                        <h3 class="card-title">${prod.name}</h3>
                                        <div class="rating-row">
                                            <span class="stars">★★★★☆</span>
                                            <span>(4.5)</span>
                                        </div>
                                        <div class="price-row">
                                            <span class="price-main">$${prod.price}</span>
                                        </div>

                                        <c:choose>
                                            <c:when test="${prod.stock <= 5 && prod.stock > 0}">
                                                <p class="stock-indicator low-stock">Only ${prod.stock} left in stock
                                                </p>
                                            </c:when>
                                            <c:when test="${prod.stock > 5}">
                                                <p class="stock-indicator in-stock">In Stock (${prod.stock})</p>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="stock-indicator low-stock">Out of stock</p>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:if test="${prod.stock > 0}">
                                            <form action="${pageContext.request.contextPath}/buyer/order" method="POST"
                                                class="order-form">
                                                <input type="hidden" name="productId" value="${prod.productId}">
                                                <div class="form-row-qty">
                                                    <label>Qty:</label>
                                                    <div class="qty-stepper">
                                                        <button type="button" onclick="decrementQty(this)">-</button>
                                                        <input type="number" name="quantity" value="1" min="1"
                                                            max="${prod.stock}" readonly>
                                                        <button type="button" onclick="incrementQty(this)"
                                                            data-max="${prod.stock}">+</button>
                                                    </div>
                                                </div>
                                                <input type="text" name="address" class="address-field"
                                                    placeholder="Enter delivery address..." required>
                                                <button type="submit" class="btn-order">Buy Now</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p style="padding: 20px; color: #64748b;">No products available.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>

                <section class="orders-panel">
                    <div class="section-header">
                        <h2>Your Orders</h2>
                        <span class="count-badge">${orders.size()} orders placed</span>
                    </div>

                    <c:choose>
                        <c:when test="${not empty orders}">
                            <c:forEach var="ord" items="${orders}">
                                <div class="order-card-row">
                                    <div class="order-card-header">
                                        <div class="meta-col">
                                            <span>Date</span>
                                            <strong>${ord.createdAt}</strong>
                                        </div>
                                        <div class="meta-col">
                                            <span>Total</span>
                                            <strong>$${ord.totalAmount}</strong>
                                        </div>
                                        <div class="meta-col">
                                            <span>Order ID</span>
                                            <strong>#${ord.orderId}</strong>
                                        </div>
                                    </div>
                                    <div class="order-card-body">
                                        <div><strong>Address:</strong> ${ord.shippingAddress}</div>
                                        <span class="status-badge status-${ord.orderStatus}">${ord.orderStatus}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="padding: 10px; color: #64748b;">No orders placed yet.</p>
                        </c:otherwise>
                    </c:choose>
                </section>
            </main>

            <script>
                function incrementQty(btn) {
                    const input = btn.parentElement.querySelector('input');
                    const maxStock = parseInt(btn.getAttribute('data-max'), 10) || 1;
                    let current = parseInt(input.value, 10) || 1;
                    if (current < maxStock) {
                        input.value = current + 1;
                    }
                }

                function decrementQty(btn) {
                    const input = btn.parentElement.querySelector('input');
                    let current = parseInt(input.value, 10) || 1;
                    if (current > 1) {
                        input.value = current - 1;
                    }
                }

                function filterCatalog() {
                    const query = document.getElementById('liveSearchInput').value.toLowerCase();
                    const cards = document.querySelectorAll('.product-card');
                    let count = 0;
                    cards.forEach(card => {
                        const title = card.getAttribute('data-title');
                        if (title && title.includes(query)) {
                            card.style.display = 'flex';
                            count++;
                        } else {
                            card.style.display = 'none';
                        }
                    });
                    document.getElementById('productCount').innerText = count + ' items available';
                }
            </script>
        </body>

        </html>