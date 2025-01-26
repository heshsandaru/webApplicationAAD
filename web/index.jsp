<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liberty - Products</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/styles/userStyles/user-product.css" rel="stylesheet">
    <style>
        /* Global Background Gradient */
        body {
            background: linear-gradient(45deg, #a3a3c2, #150303);
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background-color: #c9c9c9;
        }

        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
            color: white !important;
        }

        #ck {
            color: yellow;
        }

        .nav-link {
            color: white !important;
            position: relative;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .nav-link:hover {
            color: yellow !important;
        }

        .nav-link:hover::after {
            content: '';
            display: block;
            width: 100%;
            height: 2px;
            background-color: yellow;
            position: absolute;
            bottom: -5px;
            left: 0;
        }

        .btn-search {
            color: black;
            background-color: transparent;
            border: none;
            display: flex;
            align-items: center;
            font-size: 1.1rem;
            position: relative;
        }

        .btn-search i {
            margin-left: 5px;
            font-size: 1.2rem;
        }

        .btn-search:hover {
            color: red;
        }

        .btn-search:hover::after {
            content: '';
            display: block;
            width: 100%;
            height: 2px;
            background-color: white;
            position: absolute;
            bottom: -3px;
            left: 0;
        }

        /* Banner Section */
        .banner {
            z-index: 0;
            background-image: url('https://via.placeholder.com/1920x600?text=Shop+Our+Latest+Products');
            background-size: cover;
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

        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .product-info {
            padding: 20px;
        }

        .product-title {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 10px;
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

        /* Footer Section */
        .footer {
            background-color: #f8f9fa;
            padding: 40px 0;
            text-align: center;
            background: linear-gradient(45deg, #343333, #9b9999);
        }

        .footer .footer-title {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .footer .footer-links a {
            color: #6c757d;
            text-decoration: none;
            margin: 0 10px;
            transition: color 0.3s;
        }

        .footer .footer-links a:hover {
            color: #dc3545;
        }

    </style>
</head>
<body>
<%--Nav Bar--%>
<nav class="navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Te<span id="ck">ck</span>World</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active" id="user_product_nav" href="user-product.jsp">Products</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" id="user_cart_nav" href="user-cart.jsp">Cart</a>
                </li>
            </ul>
            <div class="d-flex align-items-center">
                <a class="btn btn-search" id="user_search_nav" href="#"><i class="bi bi-search"></i></a>
            </div>

            <%-- Check if the user is logged in --%>
            <% if (session.getAttribute("user") != null) { %>
            <!-- Logged-in state -->
            <a href="user-details.jsp" class="btn btn-secondary ms-3">
                <i class="bi bi-gear"></i> Settings
            </a>
            <a href="logout.jsp" class="btn btn-danger ms-2">Logout</a>
            <% } else { %>
            <!-- Guest state -->
            <a href="user-loginpage.jsp" class="btn btn-danger ms-3">Log In</a>
            <% } %>
        </div>
    </div>
</nav>

<!-- Banner -->
<div class="banner">
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
</div>

<!-- Footer Section -->
<div class="footer">
    <div class="footer-title">Stay Connected</div>
    <div class="footer-links">
        <a href="#">Facebook</a>
        <a href="#">Instagram</a>
        <a href="#">Twitter</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>