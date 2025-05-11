# DigiDine - Restaurant Management System 🍽️

DigiDine is a dynamic and responsive web-based Restaurant Management System built using **JSP**, **Servlets**, and **MySQL**. It offers a seamless dining experience for both customers and administrators, enabling online ordering, real-time cart management, user profile handling, admin-level analytics, guest order support, and professional bill generation.

---

## 🔥 Features

### 👤 Customer Side
- User Registration & Login
- Profile View and Edit (with AJAX)
- Browse Menu by Category
- Add/Update Items in Cart (AJAX-based)
- Place Online Orders
- View Order History
- Download Printable Bill (with amount in words)

### 👥 Guest User Support
- Admin can place guest orders manually
- Guest Bill Generation
- Separate guest order table management

### 🔐 Admin Side
- Secure Admin Login
- Manage Users (View customer list)
- Manage Menu (CRUD on food items and categories)
- View Online & Offline Order Histories
- View All Order Items per Order (Guest + Registered)
- Dynamic Dashboard UI with Modals

---

## 🧰 Technologies Used

- **Frontend:** HTML, CSS, Bootstrap 5, JavaScript, AJAX, jQuery
- **Backend:** JSP, Servlets
- **Database:** MySQL
- **Java Libraries:** JavaMail (for registration email), JDBC
- **Build Tools:** Apache Tomcat


## ⚙️ Database Structure

Tables:
- `users` (registered users)
- `categories` (menu categories)
- `food_items` (items available)
- `cart` (temporary cart per user)
- `orders` (order metadata)
- `order_items` (individual order entries)
- `guest_orders` (admin-placed guest orders)
- `guest_order_items` (guest order items)

ER diagram and SQL dump available in `/database` folder.

---
## ✅ Unique Points
- Dark themed UI for all roles
- AJAX-powered modals for seamless interaction
- Separate flow for guest vs registered user orders
- Order history with bill preview
- Clean SRS documentation for academic submission

---
## 🚀 Getting Started

1. Clone this repo:
   ```bash
   git clone https://github.com/yourusername/DigiDine-Restaurant-Management-System.git
   ```
2. Import into Eclipse/NetBeans or any Java EE IDE.


3. Configure your DBConnection.java with your local DB credentials.

4. Create the database schema using provided SQL dump.

5. Run on Apache Tomcat server.

## 🤝 Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you'd like to change.


## 📧 Contact
- [Portfolio 🧑](https://asutoshsahoo.netlify.app/)
- [LinkedIn 😀](https://www.linkedin.com/in/asutoshsahoo/)
- Feel free to fork , star ⭐, and contribute 🤝!

> Developed with 💛 by Asutosh | Channel: JavaWithAsh