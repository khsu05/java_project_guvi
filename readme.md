# Enterprise Multi-Role E-Commerce Platform

A role-based e-commerce web application built with **Java 21, Jakarta Servlets, JSP/JSTL, JDBC, MySQL, and Apache Tomcat**.

The project is intentionally implemented without high-level frameworks such as Spring Boot or Hibernate to demonstrate strong fundamentals in **HTTP request handling, MVC architecture, JDBC persistence, session management, authorization, transaction processing, and concurrent inventory management**.

> **Engineering focus:** correctness, clear separation of concerns, transactional integrity, and maintainable server-side Java code.

---

## Features

### Authentication & Authorization

* Session-based user authentication
* Secure password hashing using **BCrypt**
* Role-based access control for:

  * `ADMIN`
  * `SELLER`
  * `BUYER`
* Centralized `AuthFilter` for protected routes
* Unauthorized requests return appropriate HTTP status codes
* Session invalidation on logout

### Product & Inventory Management

* Seller-owned product catalog
* Product creation and management
* Stock tracking
* Low-stock monitoring
* Product availability validation during checkout

### Order Management

* Buyer checkout with shipping address
* Order and order-item persistence
* Order lifecycle management:

  * `PENDING`
  * `PROCESSING`
  * `SHIPPED`
  * `DELIVERED`
  * `CANCELLED`
* Buyer order history
* Seller fulfillment workflow
* Admin-level order visibility

### Transactional Checkout

Checkout operations are executed inside an explicit JDBC transaction.

Inventory rows are locked using:

```sql
SELECT price, stock
FROM products
WHERE product_id = ?
FOR UPDATE;
```

This prevents concurrent checkout requests from consuming the same inventory and helps maintain consistent stock levels.

---

# Architecture

The application follows a conventional **MVC architecture** with a layered persistence model.

```text
                    ┌─────────────────────┐
                    │       Browser       │
                    └──────────┬──────────┘
                               │ HTTP
                               ▼
                    ┌─────────────────────┐
                    │  Jakarta Servlets   │
                    │    Controllers      │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │      Services       │
                    │  Business Logic     │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │        DAO          │
                    │   JDBC Persistence  │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │       MySQL         │
                    │     Database        │
                    └─────────────────────┘

             JSP/JSTL Views ◄── Controllers
```

### Request Flow

```text
HTTP Request
     │
     ▼
AuthFilter
     │
     ├── Authentication check
     ├── Role authorization
     │
     ▼
Controller Servlet
     │
     ▼
Business Logic
     │
     ▼
DAO Layer
     │
     ▼
MySQL
     │
     ▼
DAO Result
     │
     ▼
Servlet
     │
     ▼
JSP/JSTL View
     │
     ▼
HTTP Response
```

---

# Role Model

| Role       | Route Scope | Responsibilities                                                          |
| ---------- | ----------- | ------------------------------------------------------------------------- |
| **ADMIN**  | `/admin/*`  | User management, catalog oversight, order monitoring, operational metrics |
| **SELLER** | `/seller/*` | Product management, inventory monitoring, order fulfillment               |
| **BUYER**  | `/buyer/*`  | Product discovery, checkout, order tracking, order history                |

Authorization is enforced centrally rather than duplicated across individual JSP pages or controllers.

---

# Technology Stack

| Component          | Technology            |
| ------------------ | --------------------- |
| Language           | Java 21               |
| Web Layer          | Jakarta Servlets 6.0  |
| View Layer         | JSP / JSTL            |
| Application Server | Apache Tomcat 10.1+   |
| Database           | MySQL 8.0+            |
| Persistence        | JDBC                  |
| Database Driver    | MySQL Connector/J 8.4 |
| Password Hashing   | jBCrypt 0.4           |
| Build System       | Apache Maven 3.8+     |
| Architecture       | MVC + DAO             |

---

# Project Structure

```text
ecommerce-platform/
│
├── pom.xml
├── README.md
│
└── src/
    └── main/
        │
        ├── java/
        │   └── com/
        │       └── ecommerce/
        │
        │           ├── config/
        │           │   └── DBConnection.java
        │           │
        │           ├── controller/
        │           │   ├── admin/
        │           │   ├── auth/
        │           │   ├── buyer/
        │           │   └── seller/
        │           │
        │           ├── dao/
        │           │   ├── OrderDAO.java
        │           │   ├── ProductDAO.java
        │           │   └── UserDAO.java
        │           │
        │           ├── filter/
        │           │   └── AuthFilter.java
        │           │
        │           ├── model/
        │           │   ├── Order.java
        │           │   ├── Product.java
        │           │   └── User.java
        │           │
        │           └── service/
        │               └── ...
        │
        └── webapp/
            │
            ├── index.jsp
            ├── login.jsp
            │
            └── WEB-INF/
                ├── web.xml
                │
                └── views/
                    ├── admin/
                    │   └── dashboard.jsp
                    │
                    ├── buyer/
                    │   └── dashboard.jsp
                    │
                    └── seller/
                        └── dashboard.jsp
```

> The `service` layer can be omitted for simple CRUD operations where it adds no value. Business-critical workflows such as checkout can use a service layer when transaction boundaries need to span multiple DAOs.

---

# Database Design

The system uses a relational MySQL schema with foreign-key constraints to maintain referential integrity.

### Entity Relationship

```text
                 ┌──────────────┐
                 │    users     │
                 │──────────────│
                 │ user_id PK   │
                 │ name         │
                 │ email        │
                 │ password     │
                 │ role         │
                 └──────┬───────┘
                        │
              ┌─────────┴─────────┐
              │                   │
              ▼                   ▼
       ┌──────────────┐    ┌──────────────┐
       │   products   │    │    orders    │
       │──────────────│    │──────────────│
       │ product_id   │    │ order_id PK  │
       │ seller_id FK │    │ buyer_id FK  │
       │ name         │    │ total_amount │
       │ price        │    │ status       │
       │ stock        │    │ address      │
       └──────┬───────┘    └──────┬───────┘
              │                   │
              └────────┬──────────┘
                       ▼
                ┌──────────────┐
                │ order_items  │
                │──────────────│
                │ item_id PK   │
                │ order_id FK  │
                │ product_id   │
                │ seller_id FK │
                │ quantity     │
                │ unit_price   │
                └──────────────┘
```

---

# Database Setup

Create the database:

```sql
CREATE DATABASE IF NOT EXISTS ecommerce_platform_db;

USE ecommerce_platform_db;
```

### Users

```sql
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'SELLER', 'BUYER') NOT NULL DEFAULT 'BUYER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Products

```sql
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    seller_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_product_seller
        FOREIGN KEY (seller_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);
```

### Orders

```sql
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    buyer_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    order_status ENUM(
        'PENDING',
        'PROCESSING',
        'SHIPPED',
        'DELIVERED',
        'CANCELLED'
    ) DEFAULT 'PENDING',
    shipping_address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_order_buyer
        FOREIGN KEY (buyer_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);
```

### Order Items

```sql
CREATE TABLE order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    seller_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,

    CONSTRAINT fk_item_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_item_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_item_seller
        FOREIGN KEY (seller_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);
```

---

# Concurrency & Transaction Integrity

One of the main engineering goals of the project is preventing inventory inconsistencies during concurrent checkouts.

A naïve implementation might perform:

```text
SELECT stock
       ↓
check stock
       ↓
UPDATE stock
```

Two concurrent requests can both observe the same inventory before either request performs the update.

This can result in **overselling**.

The checkout workflow instead uses a database transaction and pessimistic row locking.

```java
Connection connection = DBConnection.getConnection();

try {
    connection.setAutoCommit(false);

    // Lock the product row until the transaction completes.
    String lockSql = """
        SELECT price, stock
        FROM products
        WHERE product_id = ?
        FOR UPDATE
        """;

    // Validate stock availability.
    // ...

    // Decrement inventory.
    String updateSql = """
        UPDATE products
        SET stock = stock - ?
        WHERE product_id = ?
        """;

    // Insert order and order items.
    // ...

    connection.commit();

} catch (SQLException exception) {

    if (connection != null) {
        connection.rollback();
    }

    throw exception;

} finally {

    if (connection != null) {
        connection.setAutoCommit(true);
        connection.close();
    }
}
```

### Transaction Boundary

```text
BEGIN TRANSACTION
       │
       ▼
Lock Product Row
       │
       ▼
Validate Inventory
       │
       ├── Insufficient Stock ──► ROLLBACK
       │
       ▼
Update Inventory
       │
       ▼
Create Order
       │
       ▼
Create Order Items
       │
       ▼
COMMIT
```

This ensures that inventory changes and order creation succeed or fail as a single unit.

---

# Security Considerations

The application implements several baseline security controls:

* BCrypt password hashing
* No plaintext password storage
* Parameterized SQL queries through `PreparedStatement`
* Session-based authentication
* Centralized role authorization
* Protected application views under `WEB-INF`
* HTTP status handling for unauthorized requests

### Example

```java
if (!userHasRequiredRole) {
    response.sendError(HttpServletResponse.SC_FORBIDDEN);
    return;
}
```

---

# Configuration

Database configuration should match the local development environment.

```java
private static final String URL =
    "jdbc:mysql://localhost:3306/ecommerce_platform_db"
    + "?useSSL=false"
    + "&allowPublicKeyRetrieval=true"
    + "&serverTimezone=UTC";

private static final String USER = "root";

private static final String PASSWORD =
    "your_actual_password";
```

### Recommended

For a real deployment, credentials should **not** be committed to Git.

Prefer environment variables or external configuration:

```text
DB_URL
DB_USER
DB_PASSWORD
```

---

# Running the Application

## Prerequisites

Install:

* JDK 21
* Maven 3.8+
* MySQL 8.0+
* Apache Tomcat 10.1+

Verify Java:

```bash
java -version
```

Verify Maven:

```bash
mvn -version
```

---

## 1. Clone the Repository

```bash
git clone <repository-url>

cd ecommerce-platform
```

---

## 2. Configure MySQL

Create the database and tables using the SQL schema above.

Then configure the database connection in:

```text
src/main/java/com/ecommerce/config/DBConnection.java
```

---

## 3. Build

```bash
mvn clean package
```

The generated WAR file will be:

```text
target/ecommerce-platform.war
```

---

## 4. Deploy to Tomcat

Copy the WAR file into:

```text
<TOMCAT_HOME>/webapps/
```

For example:

```text
<TOMCAT_HOME>/webapps/ecommerce-platform.war
```

Start Tomcat.

### Windows

```bash
<TOMCAT_HOME>\bin\startup.bat
```

### Linux / macOS

```bash
<TOMCAT_HOME>/bin/startup.sh
```

---

## 5. Open the Application

```text
http://localhost:8080/ecommerce-platform/
```

---

# Demo Accounts

For local development/testing:

| Role   | Email                  | Password  |
| ------ | ---------------------- | --------- |
| Admin  | `admin@ecommerce.com`  | `pass123` |
| Seller | `seller@ecommerce.com` | `pass123` |
| Buyer  | `buyer@ecommerce.com`  | `pass123` |

> These credentials are intended only for local development. Production deployments should use securely generated credentials and external secret management.

---

# Engineering Decisions

### Why Servlets instead of Spring Boot?

The project intentionally uses Jakarta Servlets to demonstrate understanding of the underlying web stack rather than relying entirely on framework abstractions.

This includes:

* HTTP request/response lifecycle
* Servlet filters
* Session management
* URL routing
* Form handling
* Server-side rendering
* JDBC transaction management

### Why JDBC instead of Hibernate?

Raw JDBC provides direct visibility into:

* SQL execution
* Connection lifecycle
* Prepared statements
* Transaction boundaries
* Row locking
* Commit/rollback behavior
* Database performance characteristics

This makes the project useful as a **Java backend fundamentals project** rather than simply demonstrating framework configuration.

---

# Design Principles

The implementation follows several core engineering principles:

* **Separation of concerns**
* **Least-privilege authorization**
* **Parameterized SQL**
* **Explicit transaction boundaries**
* **Fail-fast validation**
* **Database-enforced referential integrity**
* **Minimal framework abstraction**
* **Clear ownership of business logic**
* **Resource cleanup using try/finally or try-with-resources**

---

# Future Improvements

Potential extensions include:

* Connection pooling using HikariCP
* Database migrations using Flyway
* Automated unit and integration testing
* Docker-based development environment
* Structured application logging
* Centralized exception handling
* CSRF protection
* Pagination and product search
* Product categories
* Shopping cart persistence
* Payment gateway integration
* Redis-based caching
* REST API layer
* CI/CD pipeline
* Containerized deployment
* Observability and metrics

These are intentionally separated from the current implementation to keep the core project focused and understandable.

---

# Project Status

**Status:** Active Development

Current focus:

* Core MVC architecture
* Authentication and RBAC
* Product and inventory management
* Transaction-safe checkout
* Order lifecycle management
* Database integrity

---

# License

This project is licensed under the **MIT License**.
