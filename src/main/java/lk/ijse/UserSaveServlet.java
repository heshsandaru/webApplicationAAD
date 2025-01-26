package lk.ijse;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "UserSaveServlet", value = "/user-save")
public class UserSaveServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/webApplicationAAD";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Ijse@123";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("user_name");
        String email = req.getParameter("user_email");
        String password = req.getParameter("user_password");
        String role = req.getParameter("user_role");

        if (username == null || email == null || password == null || role == null) {
            resp.sendRedirect("user-save.jsp?error=Missing required fields");
            return;
        }

//        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        try {
            // Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement pst = connection.prepareStatement("INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)")) {

                pst.setString(1, username);
                pst.setString(2, email);
                pst.setString(3, password);
                pst.setString(4, role);

                int affectedRows = pst.executeUpdate();
                if (affectedRows > 0) {
                    resp.sendRedirect("user-save.jsp?message=User Saved Successfully");
                } else {
                    resp.sendRedirect("user-save.jsp?error=User Save Failed");
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("user-save.jsp?error=Database error: " + e.getMessage());
        }
    }
}
