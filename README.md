#  E-Commerce Database (PostgreSQL)

This project focuses on designing and implementing a **scalable and efficient relational database** for an e-commerce system using **PostgreSQL**. It supports core business operations such as customer management, order processing, payments, shipping, inventory tracking, and analytics.

---

##  Overview

Modern e-commerce platforms generate large volumes of data that must be efficiently managed. This project replaces traditional spreadsheet-based systems with a **relational database model** that ensures:

- Data consistency
- Scalability
- Efficient querying
- Transaction reliability

The system is designed using **Entity-Relationship modeling** and normalized up to **BCNF (Boyce-Codd Normal Form)** for optimal performance :contentReference[oaicite:0]{index=0}.

---

##  Key Features

- Customer management system
- Order and transaction tracking
- Payment processing
- Shipping and delivery tracking
- Inventory management
- Product reviews and ratings
- Discount and promotion handling
- Customer support ticket system

---

##  Database Design

The database consists of multiple relational tables, including:

- **Customers**
- **Orders**
- **OrderItems**
- **Products**
- **Cart**
- **Payments**
- **Shipping**
- **Reviews**
- **Inventory**
- **Suppliers**
- **Discounts**
- **Support Tickets**

Each table is properly normalized to reduce redundancy and maintain data integrity :contentReference[oaicite:1]{index=1}.

---

##  Entity-Relationship Model

The system is designed using an ER model that defines relationships such as:

- Customers → Orders (1:M)
- Orders → OrderItems (1:M)
- Products → Inventory
- Orders → Payments & Shipping

 The ER diagram (Page 5 of the report) visually represents all relationships and dependencies

---

##  SQL Implementation

The project includes:

###  CRUD Operations
- Insert, Update, Delete queries
- Safe deletion using conditional checks

###  Advanced Queries
- JOIN operations
- GROUP BY and aggregation
- Subqueries for filtering

###  Stored Procedures
- Insert payment records
- Update product inventory automatically

###  Transactions & Error Handling
- Transaction rollback on failure
- Error logging system

###  Indexing & Optimization
- Indexes created on frequently queried columns
- Query performance analysis using `EXPLAIN ANALYZE` :contentReference[oaicite:3]{index=3}

---

##  Project Structure

``` id="8xq0jq"
E-Commerce_Database/
│
├── script.sql                         # SQL queries, procedures, indexing, transactions
├── saitanvi_apllerl_hpreddie_phase_1.pdf  # Detailed project report
└── README.md                          # Project documentation
