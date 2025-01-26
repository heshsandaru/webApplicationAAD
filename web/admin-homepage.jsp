<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Homepage</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="assets/styles/adminStyles/admin-homepage.css">
  <link rel="stylesheet" href="assets/styles/adminStyles/admin-categories.css">
  <link rel="stylesheet" href="assets/styles/adminStyles/admin-product.css">

  <style>
    .banner {
      z-index: 0;
      background-image: url('https://via.placeholder.com/1920x600?text=Shop+Our+Latest+Products');
      background-size: cover;
      background-repeat:no-repeat ;
      background-position: center;
      height: 400px;
      color: white;
      text-align: center;
      display: flex;
      justify-content: center;
      align-items: center;
      font-size: 2rem;
      font-weight: bold;
      background: linear-gradient(45deg, rgb(241, 86, 86), rgba(255, 255, 255, 0.8)), url('https://via.placeholder.com/1920x600?text=Shop+Our+Latest+Products');
      background-size: cover;
      background-position: center;
    }

    /* Product Grid */
    .product-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 30px;
      padding: 30px 0;
    }
    #red{
      color: yellow;
    }
    .product-card {
      background-color: #fff;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      overflow: hidden;
      transition: transform 0.3s ease;
    }

    .product-card:hover {
      transform: translateY(-10px);
    }
    #cata{
      color: yellow;
    }

    .product-card img {
      width: 100%;
      height: 200px;
      object-fit: cover;
    }

    .product-info {
      padding: 20px;
    }
    #pro{
      color: yellow;
    }
    .product-title {
      font-size: 1.2rem;
      font-weight: bold;
      margin-bottom: 10px;
    }
    .nav-link:hover {
      color: yellow !important;
    }
    .product-description {
      color: #6c757d;
      font-size: 0.9rem;
      margin-bottom: 15px;
    }

    .product-price {
      color: #dc3545;
      font-size: 1.2rem;
      font-weight: bold;
    }

  </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">Te<span id="red">ck</span>World</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link active" id="home_nav" aria-current="page" href="#">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link active" id="category_nav" href="#">Categories</a>
        </li>
        <li class="nav-item">
          <a class="nav-link active" id="product_nav" href="#">Product</a>
        </li>
        <li class="nav-item">
          <a class="nav-link active" id="customer_details_nav" href="#">Customers</a>
        </li>
        <li class="nav-item">
          <a class="nav-link active" id="order_details_nav" href="#">Order Details</a>
        </li>
      </ul>
      <form class="d-flex" role="search">
        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
        <button class="btn btn-outline-danger" type="submit">Search</button>
      </form>
      <!-- Logout Button with Margin Start -->
      <button type="submit" class="btn btn-danger logout-button ms-3">
        <a href="admin-loginpage.jsp"></a>
        Logout</button>
    </div>
  </div>
</nav>




<%--Admin Category Page--%>
<%
  String message = request.getParameter("message");
  String error = request.getParameter("error");
%>

<% if (message != null) { %>
<div class="alert alert-success" role="alert"><%= message %></div>
<% } %>

<% if (error != null) { %>
<div class="alert alert-danger" role="alert"><%= error %></div>
<% } %>

<div id="admin_category_section" class="container mt-5">
  <h1 class="text-center mb-4"><b>Manage <span class="cat" id="cata">Categories</span></b></h1>
  <form id="categoryForm" class="shadow p-4 rounded bg-light" action="admin-categories" method="POST">
    <input type="hidden" name="categoryId" id="categoryId">
    <div class="mb-3">
      <label for="categoryName" class="form-label">Category Name</label>
      <input type="text" id="categoryName" class="form-control" placeholder="Enter category name" name="categories_name" required>
    </div>
    <div class="mb-3">
      <label for="categoryDescription" class="form-label">Description</label>
      <input type="text" id="categoryDescription" class="form-control" placeholder="Enter category description" name="categories_description" required>
    </div>
    <button type="submit" class="btn btn-outline-secondary w-100" name="action" value="add">Add Category</button>
    <button type="submit" class="btn btn-outline-danger w-100 mt-2" name="action" value="update">Update Category</button>
  </form>

  <h2 class="mt-5">Categories List</h2>
  <table class="table table-hover custom-table mt-3 shadow">
    <thead class="table-secondary">
    <tr>
      <th>ID</th>
      <th>Category Name</th>
      <th>Description</th>
      <th>Action</th>
    </tr>
    </thead>
    <tbody id="categoryTableBody">
    <%
      Connection connection = null;
      PreparedStatement ps = null;
      ResultSet rs = null;

      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/webApplicationAAD", "root", "Ijse@123");

        String sql = "SELECT id, name, description FROM categories";
        ps = connection.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next()) {
          int id = rs.getInt("id");
          String name = rs.getString("name");
          String description = rs.getString("description");
    %>
    <tr data-id="<%= id %>" data-name="<%= name %>" data-description="<%= description %>">
      <td><%= id %></td>
      <td><%= name %></td>
      <td><%= description %></td>
      <td>
        <!-- Delete button form -->
        <form action="admin-categories" method="POST" style="display:inline;">
          <input type="hidden" name="categoryId" value="<%= id %>">
          <button type="submit" name="action" value="delete" class="btn btn-danger btn-sm">
            Delete
          </button>
        </form>
      </td>
    </tr>
    <%
        }
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (connection != null) connection.close();
      }
    %>
    </tbody>
  </table>
</div>



<%--Admin Product Page--%>
<%
  String message1 = request.getParameter("message");
  String error1 = request.getParameter("error");
%>

<% if (message1 != null) { %>
<div class="alert alert-success" role="alert"><%= message %></div>
<% } %>
<% if (error1 != null) { %>
<div class="alert alert-danger" role="alert"><%= error %></div>
<% } %>

<div id="admin_product_section" class="container mt-5">
  <input type="hidden" name="productId" id="productId">
  <h1 class="text-center mb-4"><b>Manage <span class="cat" id="pro">Product</span></b></h1>
  <form id="productForm" class="shadow p-4 rounded bg-light" action="admin-product" method="POST" enctype="multipart/form-data">
    <div class="mb-3">
      <label for="productName" class="form-label">Product Name</label>
      <input type="text" id="productName" class="form-control" placeholder="Enter product name" name="name" required>
    </div>
    <div class="mb-3">
      <label for="description" class="form-label">Product Image</label>
      <input type="file" id="description" name="description" class="form-control" accept="image/*" required>
      <!-- Display field for filename -->
      <input type="text" id="fileNameDisplay" class="form-control mt-2" placeholder="Selected image filename" readonly name="productId">
    </div>
    <div class="mb-3">
      <label for="productPrice" class="form-label">Price</label>
      <input type="number" id="productPrice" class="form-control" placeholder="Enter product price" name="price" step="0.01" required>
    </div>
    <div class="mb-3">
      <label for="productQty" class="form-label">Quantity</label>
      <input type="number" id="productQty" class="form-control" placeholder="Enter product quantity" name="quantity" required>
    </div>
    <div class="mb-3">
      <label for="categoryId" class="form-label">Category ID</label>
      <input type="number" id="categoryIds" class="form-control" placeholder="Enter category ID" name="categoryId" required>
    </div>
    <div class="d-flex justify-content-between">
      <button type="submit" class="btn btn-outline-secondary w-50 me-2" name="action" value="add">Add Product</button>
      <button type="submit" class="btn btn-outline-danger w-50" name="action" value="update">Update Product</button>
    </div>
  </form>
<div class="container section">
  <h2 class="text-center mb-4">Product List</h2>
  <table class="table table-hover custom-table shadow">
    <thead class="table-secondary">
    <tr>
      <th>ID</th>
      <th>Product Name</th>
      <th>Image</th>
      <th>Price</th>
      <th>Quantity</th>
      <th>Category ID</th>
      <th>Action</th>
    </tr>
    </thead>
    <tbody id="productTableBody">
    <%
      Connection connection1 = null;
      PreparedStatement pst = null;
      ResultSet rst = null;

      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/webApplicationAAD", "root", "Ijse@123");

        String sql = "SELECT id, name, description, price, quantity, category_id FROM products";
        pst = connection1.prepareStatement(sql);
        rst = pst.executeQuery();

        while (rst.next()) {
          int id = rst.getInt("id");
          String name = rst.getString("name");
          double price = rst.getDouble("price");
          int quantity = rst.getInt("quantity");
          int categoryId = rst.getInt("category_id");
          String imageUrl = "image?id=" + id;
    %>
    <tr data-id="<%= id %>" data-name="<%= name %>" data-price="<%= price %>" data-quantity="<%= quantity %>" data-category-id="<%= categoryId %>">
      <td><%= id %></td>
      <td><%= name %></td>
      <td><img src="<%= imageUrl %>" alt="<%= name %>" style="width: 100px; height: auto;"></td>
      <td>$<%= String.format("%.2f", price) %></td>
      <td><%= quantity %></td>
      <td><%= categoryId %></td>
      <td>
        <!-- Delete button form -->
        <form action="admin-product" method="POST" style="display:inline;">
          <input type="hidden" name="productId" value="<%= id %>">
          <button type="submit" name="action" value="delete" class="btn btn-danger btn-sm">
            Delete
          </button>
        </form>
      </td>
    </tr>
    <%
        }
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        if (rst != null) rst.close();
        if (pst != null) pst.close();
        if (connection1 != null) connection1.close();
      }
    %>
    </tbody>
  </table>
</div>
</div>


<%--Admin Customer Activate Deactivate--%>
<%
  DataSource dataSource = null;
  try {
    Context initContext = new InitialContext();
    Context envContext = (Context) initContext.lookup("java:comp/env");
    dataSource = (DataSource) envContext.lookup("jdbc/pool");
  } catch (Exception e) {
    System.out.println("Error initializing datasource: " + e.getMessage());
  }

  Connection connection2 = null;
  PreparedStatement statement = null;
  ResultSet resultSet = null;
%>
<div id="admin_customer_activate_deactivate_section" class="container mt-4">
  <h1 class="mb-4">Customer Details</h1>
  <table class="table table-striped">
    <thead>
    <tr>
      <th>ID</th>
      <th>Username</th>
      <th>Email</th>
      <th>Status</th>
      <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <%
      try {
        connection = dataSource.getConnection();
        String query = "SELECT id, username, email, status FROM users WHERE role = 'customer'";
        statement = connection.prepareStatement(query);
        resultSet = statement.executeQuery();

        while (resultSet.next()) {
          int id = resultSet.getInt("id");
          String username = resultSet.getString("username");
          String email = resultSet.getString("email");
          boolean status = resultSet.getBoolean("status");
    %>
    <tr>
      <td><%= id %></td>
      <td><%= username %></td>
      <td><%= email %></td>
      <td>
                <span class="badge <%= status ? "bg-success" : "bg-danger" %>">
                    <%= status ? "Active" : "Inactive" %>
                </span>
      </td>
      <td>
        <form method="post" action="admin-customer-details" style="display:inline-block;">
          <input type="hidden" name="id" value="<%= id %>">
          <input type="hidden" name="action" value="<%= status ? "deactivate" : "activate" %>">
          <button type="submit" class="btn <%= status ? "btn-danger" : "btn-success" %>">
            <%= status ? "Deactivate" : "Activate" %>
          </button>
        </form>
      </td>
    </tr>
    <%
        }
      } catch (SQLException e) {
        System.out.println("<tr><td colspan='5'>Error loading data: " + e.getMessage() + "</td></tr>");
      } finally {
        if (resultSet != null) resultSet.close();
        if (statement != null) statement.close();
        if (connection != null) connection.close();
      }
    %>
    </tbody>
  </table>
</div>
<%--<div class="banner">
  <div>
    <img src="assets/image/lap.jpg" >

  </div>
</div>

<!-- Product Grid Section -->
<div class="container product-grid">
  <div class="product-card">
    <img src="assets/image/l3.png" alt="ASUS ROG STRIX G16 2024 G614JIR I9 14TH GEN RTX 4070">
    <div class="product-info">
      <div class="product-title">ASUS ROG STRIX G16 2024 G614JIR I9 14TH GEN RTX 4070</div>
      <div class="product-description">Intel Core i9 14900HX (36MB Cache, up to 5.8 GHz, 24 cores, 32 Threads)
        16GB DDR5 5600MHZ
        1TB M.2 GEN4 NVME SSD
        16-inch , QHD+ 16:10 (2560 x 1600, WQXGA) 240HZ G-Sync Supported
        NVIDIA® GeForce RTX 4070 8GB GDDR6
        Backlit Chiclet Keyboard Per-Key RGB
        2.5 kg, 90WHrs
        Free ASUS ROG Backpack
        2 Years Company Warranty
        Genuine Windows 11 Home 64Bit Pre-installed.</div>
      <div class="product-price">295,000 LKR</div>
    </div>
  </div>
  <div class="product-card">
    <img src="assets/image/l2.png" alt="MSI MODERN 15 F1MG INTEL CORE 7 14TH GEN DOS">
    <div class="product-info">
      <div class="product-title">MSI MODERN 15 F1MG INTEL CORE 7 14TH GEN DOS</div>
      <div class="product-description">MSI MODERN 15 F1MG INTEL CORE 7 14TH GEN
        Intel®️ Core™️ 7-150U Processor (12M Cache, up to 5.4GHz)
        16GB DDR4 3200MHZ (8GB x 2)
        1TB NVME GEN4 M.2 SSD
        15.6” 1080P Display IPS LEVEL
        Integrated Intel Iris Xe Graphics Functions as UHD Graphics
        Backlight Keyboard (Single-Color, White)
        1.7kg, 46.8WHrs
        MSI Sleeve
        2 Years Company Warranty
        No OS.</div>
      <div class="product-price">495,000 LKR</div>
    </div>
  </div>
  <div class="product-card">
    <img src="assets/image/l1.png" alt="ASUS TUF GAMING A15 FA507NVR RYZEN 7 RTX 4060 8GB">
    <div class="product-info">
      <div class="product-title">ASUS TUF GAMING A15 FA507NVR RYZEN 7 RTX 4060 8GB</div>
      <div class="product-description">ASUS TUF GAMING A15 FA506NFR RYZEN 7 7000 SERIES RTX 2050

        AMD Ryzen™️ 7 7435HS (20MB Cache, up to 4.5 GHz, 8 cores, 16 Threads)

        16GB DDR5 4800MHZ (8GB Removable + Free 8GB RAM Upgrade)

        512GB M.2 NVMe PCIe®️ 4.0 SSD

        15.6" 1080P 144Hz Anti-Glare IPS-level

        NVIDIA®️ GeForce RTX 2050 4GB GDDR6 TGP 75W

        1-Zone RGB Backlit Chiclet Keyboard

        2.2kg, 48WHrs

        Free ASUS TUF BACKPACK

        2 Years Company warranty

        Genuine Windows 11 Home 64Bit Pre-installed



        Storage upgrades (Additional Slot Available Supports up to GEN4)

        M.2 NVME Supported (Options Available in STORAGE & NAS Category.</div>
      <div class="product-price">245,000 LKR</div>
    </div>
  </div>
  <!-- Add more products as needed -->
</div>--%>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/admin/admin-category.js"></script>
<script src="js/admin/admin-product.js"></script>
<script src="js/admin/admin-dashboard.js"></script>
</body>
</html>