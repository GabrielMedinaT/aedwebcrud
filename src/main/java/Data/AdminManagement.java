package Data;

import Connections.MyConnection;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminManagement {

    private Connection con;
    private final String TABLE = "admin"; // Tabla en la base de datos

    public AdminManagement() {
        // Inicializar la conexión
        MyConnection myCon = new MyConnection();
        this.con = myCon.getConnection();

        if (this.con == null) {
            System.err.println("Error: No se pudo establecer la conexión con la base de datos.");
        }
    }

    public boolean validateAdmin(String username, String password) {
        if (con == null) {
            System.err.println("Error: La conexión a la base de datos es nula.");
            return false;
        }

        try {
            String hashedPassword = hashPassword(password);
            System.out.println("Usuario ingresado: " + username);
            System.out.println("Contraseña hasheada: " + hashedPassword);

            String query = "SELECT * FROM admin WHERE name = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ResultSet rs = ps.executeQuery();

            boolean isValid = rs.next();
            System.out.println("Usuario válido: " + isValid);
            return isValid;
        } catch (SQLException e) {
            System.err.println("Error al validar administrador: " + e.getMessage());
        }

        return false;
    }

// Método para hashear contraseñas
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error al hashear la contraseña", e);
        }
    }

    public String getRole(String username) {
        if (con == null) {
            System.err.println("Error: La conexión a la base de datos es nula.");
            return null;
        }

        try {
            String query = "SELECT role FROM admin WHERE name = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("role");
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener el rol: " + e.getMessage());
        }

        return null; // Si no se encuentra el usuario o ocurre un error
    }

}
