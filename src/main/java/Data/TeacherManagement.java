/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Data;

/**
 *
 * @author Gabriel
 */
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import Connections.MyConnection;
import java.sql.SQLException;

public class TeacherManagement {

    private Connection con;
    private final String TABLE = "teachers";

    public TeacherManagement() {
        var myCon = new MyConnection();
        con = myCon.getConnection();
    }

    // Crear profesor - CREATE
    public boolean createTeacher(String firstName, String lastName, String email, String phone, boolean active) {
        try {
            var ps = con.prepareStatement(
                    "INSERT INTO teachers (first_name, last_name, email, phone, active) VALUES (?, ?, ?, ?, ?)"
            );
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setBoolean(5, active);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error al agregar un profesor: " + ex.getMessage());
            return false;
        }
    }

    // Leer profesores - READ
    public List<Teacher> getTeachers(String sortField, String order) {
        List<Teacher> listTeachers = new ArrayList<>();
        PreparedStatement statement;
        ResultSet resultSet;

        try {
            // Validar los parámetros
            if (sortField == null || sortField.isEmpty()) {
                sortField = "id"; // Campo predeterminado
            }
            if (order == null || (!order.equalsIgnoreCase("asc") && !order.equalsIgnoreCase("desc"))) {
                order = "asc"; // Orden predeterminado
            }

            // Construir la consulta SQL dinámicamente
            String query = "SELECT * FROM teachers ORDER BY " + sortField + " " + order;

            // Preparar y ejecutar la consulta
            statement = con.prepareStatement(query);
            resultSet = statement.executeQuery();

            // Procesar los resultados
            while (resultSet.next()) {
                listTeachers.add(new Teacher(
                        resultSet.getInt("id"),
                        resultSet.getString("first_name"),
                        resultSet.getString("last_name"),
                        resultSet.getString("email"),
                        resultSet.getString("phone"),
                        resultSet.getBoolean("active")
                ));
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener profesores: " + e.getMessage());
        }

        return listTeachers;
    }

    // Seleccionar un profesor - SELECT BY ID
    public Teacher select(int id) {
        PreparedStatement ps;
        ResultSet rs;
        try {
            ps = con.prepareStatement("SELECT * FROM teachers WHERE id = ?");
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new Teacher(
                        id,
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getBoolean("active")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener el profesor: " + e.getMessage());
        }
        return null;
    }

    // Actualizar un profesor - UPDATE
    public boolean updateTeacher(int id, String firstName, String lastName, String email, String phone, Boolean active) {
        try {
            StringBuilder sqlBuilder = new StringBuilder("UPDATE " + TABLE + " SET ");
            boolean hasPrevious = false;

            if (firstName != null && !firstName.equals("-")) {
                sqlBuilder.append("first_name = ?");
                hasPrevious = true;
            }
            if (lastName != null && !lastName.equals("-")) {
                if (hasPrevious) sqlBuilder.append(", ");
                sqlBuilder.append("last_name = ?");
                hasPrevious = true;
            }
            if (email != null && !email.equals("-")) {
                if (hasPrevious) sqlBuilder.append(", ");
                sqlBuilder.append("email = ?");
                hasPrevious = true;
            }
            if (phone != null && !phone.equals("-")) {
                if (hasPrevious) sqlBuilder.append(", ");
                sqlBuilder.append("phone = ?");
                hasPrevious = true;
            }
            if (active != null) {
                if (hasPrevious) sqlBuilder.append(", ");
                sqlBuilder.append("active = ?");
            }

            sqlBuilder.append(" WHERE id = ?");

            PreparedStatement ps = con.prepareStatement(sqlBuilder.toString());
            int parameterIndex = 1;

            if (firstName != null && !firstName.equals("-")) ps.setString(parameterIndex++, firstName);
            if (lastName != null && !lastName.equals("-")) ps.setString(parameterIndex++, lastName);
            if (email != null && !email.equals("-")) ps.setString(parameterIndex++, email);
            if (phone != null && !phone.equals("-")) ps.setString(parameterIndex++, phone);
            if (active != null) ps.setBoolean(parameterIndex++, active);

            ps.setInt(parameterIndex, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error al actualizar el profesor: " + ex.getMessage());
        }
        return false;
    }

    // Eliminar profesor - DELETE
    public boolean deleteTeacher(int id) {
        try {
            var ps = con.prepareStatement("DELETE FROM " + TABLE + " WHERE id = ?");
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error al eliminar el profesor: " + ex.getMessage());
        }
        return false;
    }
}
