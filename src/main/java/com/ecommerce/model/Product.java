package com.ecommerce.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Product {
    private int productId;
    private int sellerId;
    private String sellerName;
    private String name;
    private String description;
    private BigDecimal price;
    private int stock;
    private Timestamp createdAt;

    public Product() {}

    public Product(int productId, int sellerId, String name, String description, BigDecimal price, int stock) {
        this.productId = productId;
        this.sellerId = sellerId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stock = stock;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }

    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) { this.sellerName = sellerName; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}