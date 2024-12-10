package Data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import Connections.MyConnection;

public class AdminManagement {

    private Connection con;
    private final String TABLE = "admin"; // Tabla en la base de datos

    public AdminManagement() {
        var myCon = new MyConnection();
        con = myCon.getConnection();
    }

    // Verificar credenciales de administrador
public boolean validateAdmin(String username, String password) {
        try {
            var ps = con.prepareStatement(
                "SELECT * FROM " + TABLE + " WHERE name = ? AND password = ?"
            );
            ps.setString(1, username); // Mapeo con el campo 'name' de la tabla
            ps.setString(2, password); // Mapeo con el campo 'password' de la tabla
            ResultSet rs = ps.executeQuery();
            return rs.next(); // Si encuentra un resultado, las credenciales son válidas
        } catch (SQLException e) {
            System.out.println("Error al validar administrador: " + e.getMessage());
        }
        return false;
    }




    // Crear nuevo administrador
    public boolean createAdmin(String username, String password) {
        try {
            var ps = con.prepareStatement(
                "INSERT INTO " + TABLE + " (name, password) VALUES (?, ?)"
            );
            ps.setString(1, username);
            ps.setString(2, password); // Considera usar un hash para mayor seguridad
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error al crear administrador: " + e.getMessage());
        }
        return false;
    }

    // Actualizar contraseña
    public boolean updatePassword(String username, String newPassword) {
        try {
            var ps = con.prepareStatement(
                "UPDATE " + TABLE + " SET password = ? WHERE name = ?"
            );
            ps.setString(1, newPassword);
            ps.setString(2, username);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error al actualizar contraseña: " + e.getMessage());
        }
        return false;
    }

    // Eliminar administrador
    public boolean deleteAdmin(String username) {
        try {
            var ps = con.prepareStatement(
                "DELETE FROM " + TABLE + " WHERE name = ?"
            );
            ps.setString(1, username);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error al eliminar administrador: " + e.getMessage());
        }
        return false;
    }
}
