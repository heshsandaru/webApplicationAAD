package lk.ijse.admin;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import javax.sql.DataSource;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet(name = "AdminProductServlet", value = "/admin-product")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Maximum file size of 5 MB
public class AdminProductServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    private static final String UPLOAD_DIRECTORY = "uploads"; // Folder where images will be stored

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            addProduct(req, resp);
        } else if ("delete".equals(action)) {
            deleteProduct(req, resp);
        } else if ("update".equals(action)) {
            updateProduct(req, resp);
        }
    }

    private void addProduct(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        double price = Double.parseDouble(req.getParameter("price"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));
        int categoryId = Integer.parseInt(req.getParameter("categoryId"));
        Part filePart = req.getPart("description");

        String imagePath = saveFile(filePart);
        System.out.println(imagePath);
        try (Connection connection = dataSource.getConnection()) {
            String sql = "INSERT INTO products (name, description, price, quantity, category_id) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, imagePath); // Store image path
                ps.setDouble(3, price);
                ps.setInt(4, quantity);
                ps.setInt(5, categoryId);

                ps.executeUpdate();
                resp.sendRedirect("admin-homepage.jsp?message=Product added successfully");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("admin-homepage.jsp?error=Failed to add product");
        }
    }

    private void updateProduct(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String productId = req.getParameter("productId");
        String name = req.getParameter("name");
        double price = Double.parseDouble(req.getParameter("price"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));
        int categoryId = Integer.parseInt(req.getParameter("categoryId"));
        Part filePart = req.getPart("description");

        String imagePath = filePart != null && filePart.getSize() > 0 ? saveFile(filePart) : null;

        try (Connection connection = dataSource.getConnection()) {
            String sql = imagePath != null
                    ? "UPDATE products SET name = ?, description = ?, price = ?, quantity = ?, category_id = ? WHERE id = ?"
                    : "UPDATE products SET name = ?, price = ?, quantity = ?, category_id = ? WHERE id = ?";

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, name);
                if (imagePath != null) {
                    ps.setString(2, imagePath);
                    ps.setDouble(3, price);
                    ps.setInt(4, quantity);
                    ps.setInt(5, categoryId);
                    ps.setInt(6, Integer.parseInt(productId));
                } else {
                    ps.setDouble(2, price);
                    ps.setInt(3, quantity);
                    ps.setInt(4, categoryId);
                    ps.setInt(5, Integer.parseInt(productId));
                }

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    resp.sendRedirect("admin-homepage.jsp?message=Product updated successfully");
                } else {
                    resp.sendRedirect("admin-homepage.jsp?error=Failed to update product");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("admin-homepage.jsp?error=Failed to update product");
        }
    }

    private String saveFile(Part filePart) throws IOException {
        String fileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString(); // Get the file name
        String uploadDir = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        File uploads = new File(uploadDir);
        if (!uploads.exists()) {
            uploads.mkdir();
        }

        File file = new File(uploadDir + File.separator + fileName);
        try (InputStream inputStream = filePart.getInputStream()) {
            Files.copy(inputStream, file.toPath(), StandardCopyOption.REPLACE_EXISTING); // Save the file to disk
        }

        return UPLOAD_DIRECTORY + "/" + fileName; // Return the relative path
    }

    private void deleteProduct(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String productId = req.getParameter("productId");

        if (productId == null || productId.isEmpty()) {
            resp.sendRedirect("admin-homepage.jsp?error=Product ID is required to delete");
            return;
        }

        try (Connection connection = dataSource.getConnection()) {
            String sql = "DELETE FROM products WHERE id = ?";
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(productId));
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    resp.sendRedirect("admin-homepage.jsp?message=Product deleted successfully");
                } else {
                    resp.sendRedirect("admin-homepage.jsp?error=Product not found");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("admin-homepage.jsp?error=Failed to delete product");
        }
    }
}
