package Data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import Connections.MyConnection;

public class StudentManagement {

    private Connection con;
    private final String TABLE = "students";

    public StudentManagement() {
        var myCon = new MyConnection();
        con = myCon.getConnection();
    }

    // Crear estudiante - CREATE
    public boolean createStudent(String name, String surname, int age, String address, int year, String familyData) {
        try {
            var ps = con.prepareStatement(
                    "INSERT INTO " + TABLE + " (name, surname, age, address, year, familyData) VALUES (?, ?, ?, ?, ?, ?)"
            );
            ps.setString(1, name);
            ps.setString(2, surname);
            ps.setInt(3, age);
            ps.setString(4, address);
            ps.setInt(5, year);
            ps.setString(6, familyData);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            System.out.println("Error al agregar un estudiante: " + ex.getMessage());
        }
        return false;
    }

    // Leer estudiantes - READ
public List<Map<String, Object>> readStudents() {
    List<Map<String, Object>> students = new ArrayList<>();
    try {
        var ps = con.prepareStatement("SELECT * FROM " + TABLE);
        ResultSet rs = ps.executeQuery();

        // Ajuste de la longitud del separador
        int LINE_LENGTH = 132;
        String separator = "-".repeat(LINE_LENGTH);

        // Imprimir encabezado de la tabla
        System.out.println(separator);
        System.out.printf("| %-3s | %-20s | %-20s | %-3s | %-40s | %-4s | %-20s |\n",
                          "ID", "Name", "Surname", "Age", "Address", "Year", "Family Data");
        System.out.println(separator);

        // Iterar por los resultados y construir cada fila
        while (rs.next()) {
            Map<String, Object> student = new HashMap<>();
            student.put("id", rs.getInt("id"));
            student.put("name", rs.getString("name"));
            student.put("surname", rs.getString("surname"));
            student.put("age", rs.getInt("age"));
            student.put("address", rs.getString("address"));
            student.put("year", rs.getInt("year"));
            student.put("familyData", rs.getString("familyData"));
            students.add(student);

            // Imprimir cada fila con formato consistente
            System.out.printf("| %-3d | %-20s | %-20s | %-3d | %-40s | %-4d | %-20s |\n",
                              rs.getInt("id"),
                              rs.getString("name") != null ? rs.getString("name") : "", // Llenar con vacío si es null
                              rs.getString("surname") != null ? rs.getString("surname") : "",
                              rs.getInt("age"),
                              rs.getString("address") != null ? rs.getString("address") : "",
                              rs.getInt("year"),
                              rs.getString("familyData") != null ? rs.getString("familyData") : "");
        }

        // Imprimir separador final
        System.out.println(separator);

    } catch (Exception ex) {
        System.out.println("Error leyendo los estudiantes: " + ex.getMessage());
    }
    return students;
}



    // Actualizar estudiante - UPDATE
    public boolean updateStudent(int id, String name, String surname, Integer age, String address, Integer year, String familyData) {
        try {
            StringBuilder sqlBuilder = new StringBuilder("UPDATE " + TABLE + " SET ");
            boolean hasPrevious = false;

            if (name != null && !name.equals("-")) {
                sqlBuilder.append("name = ?");
                hasPrevious = true;
            }
            if (surname != null && !surname.equals("-")) {
                if (hasPrevious) {
                    sqlBuilder.append(", ");
                }
                sqlBuilder.append("surname = ?");
                hasPrevious = true;
            }
            if (age != null && age != -1) {
                if (hasPrevious) {
                    sqlBuilder.append(", ");
                }
                sqlBuilder.append("age = ?");
                hasPrevious = true;
            }
            if (address != null && !address.equals("-")) {
                if (hasPrevious) {
                    sqlBuilder.append(", ");
                }
                sqlBuilder.append("address = ?");
                hasPrevious = true;
            }
            if (year != null && year != -1) {
                if (hasPrevious) {
                    sqlBuilder.append(", ");
                }
                sqlBuilder.append("year = ?");
                hasPrevious = true;
            }
            if (familyData != null && !familyData.equals("-")) {
                if (hasPrevious) {
                    sqlBuilder.append(", ");
                }
                sqlBuilder.append("familyData = ?");
            }
            sqlBuilder.append(" WHERE id = ?");

            PreparedStatement ps = con.prepareStatement(sqlBuilder.toString());

            int parameterIndex = 1;
            if (name != null && !name.equals("-")) {
                ps.setString(parameterIndex++, name);
            }
            if (surname != null && !surname.equals("-")) {
                ps.setString(parameterIndex++, surname);
            }
            if (age != null && age != -1) {
                ps.setInt(parameterIndex++, age);
            }
            if (address != null && !address.equals("-")) {
                ps.setString(parameterIndex++, address);
            }
            if (year != null && year != -1) {
                ps.setInt(parameterIndex++, year);
            }
            if (familyData != null && !familyData.equals("-")) {
                ps.setString(parameterIndex++, familyData);
            }

            ps.setInt(parameterIndex, id);

            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            System.out.println("Error al actualizar el estudiante: " + ex.getMessage());
        }
        return false;
    }

    // Eliminar estudiante - DELETE
    public boolean deleteStudent(int id) {
        try {
            var ps = con.prepareStatement("DELETE FROM " + TABLE + " WHERE id = ?");
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            System.out.println("Error al eliminar el estudiante: " + ex.getMessage());
        }
        return false;
    }
}
