package Data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import Connections.MyConnection;
import java.sql.SQLException;

public class StudentManagement {

    private Connection con;
    private final String TABLE = "students";

    public StudentManagement() {
        var myCon = new MyConnection();
        con = myCon.getConnection();
    }

    // Crear estudiante - CREATE
    public boolean createStudent(String name, String surname, int age, String address, int year, String familyData, boolean consentimiento) {
        try {
            var ps = con.prepareStatement(
                    "INSERT INTO students (name, surname, age, address, year, familydata, consentimiento) VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            ps.setString(1, name);
            ps.setString(2, surname);
            ps.setInt(3, age);
            ps.setString(4, address);
            ps.setInt(5, year);
            ps.setString(6, familyData);
            ps.setBoolean(7, consentimiento);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error al agregar un estudiante: " + ex.getMessage());
            return false;
        }
    }

    // Leer estudiantes - READ 
    public ArrayList<Student> getStudents(String sortField, String order) {
        ArrayList<Student> listStudents = new ArrayList<>();
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
            String query = "SELECT * FROM students ORDER BY " + sortField + " " + order;

            // Preparar y ejecutar la consulta
            statement = con.prepareStatement(query);
            resultSet = statement.executeQuery();

            // Procesar los resultados
            while (resultSet.next()) {
                listStudents.add(new Student(
                        resultSet.getInt("id"),
                        resultSet.getString("name"),
                        resultSet.getString("surname"),
                        resultSet.getInt("age"),
                        resultSet.getString("address"),
                        resultSet.getInt("year"),
                        resultSet.getString("familydata"),
                        resultSet.getBoolean("consentimiento")));
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener datos: " + e);
        }

        return listStudents;
    }

    public Student select(int id) {
        PreparedStatement ps;
        ResultSet rs;
        try {
            ps = con.prepareStatement("SELECT * FROM students WHERE id = ?");
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new Student(
                        id,
                        rs.getString("name"),
                        rs.getString("surname"),
                        rs.getInt("age"),
                        rs.getString("address"),
                        rs.getInt("year"),
                        rs.getString("familydata"),
                        rs.getBoolean("consentimiento")
                );
            } else {
                return null;
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener: " + e);
            return null;
        }
    }

    public void updateStudentPartial(int id, int age, String address, int year, String familyData) throws SQLException {
        if (con == null) {
            throw new SQLException("La conexión a la base de datos es nula.");
        }

        String query = "UPDATE students SET age = ?, address = ?, year = ?, familydata = ? WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, age);
            ps.setString(2, address);
            ps.setInt(3, year);
            ps.setString(4, familyData);
            ps.setInt(5, id);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No se encontró el estudiante con ID " + id);
            }
        }
    }

    /*
public ArrayList<Student> getStudents() {
    ArrayList<Student> listStudents = new ArrayList<>();
    String query = "SELECT * FROM students";
    try (PreparedStatement statement = con.prepareStatement(query);
         ResultSet resultSet = statement.executeQuery()) {
        while (resultSet.next()) {
            listStudents.add(new Student(
                    resultSet.getInt("id"),
                    resultSet.getString("name"),
                    resultSet.getString("surname"),
                    resultSet.getInt("age"),
                    resultSet.getString("address"),
                    resultSet.getInt("year"),
                    resultSet.getString("familyData")));
        }
    } catch (SQLException e) {
        System.err.println("Error al obtener estudiantes: " + e.getMessage());
    }
    return listStudents;
}
    

     */
    public boolean updateStudent(int id, String name, String surname, Integer age, String address, Integer year, String familyData, Boolean consentimiento) {
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
                sqlBuilder.append("familydata = ?");
                hasPrevious = true;
            }
            if (consentimiento != null) { // No se evalúa "-" porque es boolean
                if (hasPrevious) {
                    sqlBuilder.append(", ");
                }
                sqlBuilder.append("consentimiento = ?");
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
            if (consentimiento != null) {
                ps.setBoolean(parameterIndex++, consentimiento);
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

    public boolean enrollStudentInCourse(int studentId, int courseId) {
        Connection con = this.con; // Asume que la conexión ya está inicializada
        try {
            // Consulta las asignaturas asociadas al curso
            String querySubjects = "SELECT subject_id FROM course_subjects WHERE course_id = ?";
            PreparedStatement psSubjects = con.prepareStatement(querySubjects);
            psSubjects.setInt(1, courseId);
            ResultSet rsSubjects = psSubjects.executeQuery();

            // Preparar inserción de estudiante en asignaturas
            String insertQuery = "INSERT INTO student_subjects (student_id, subject_id) VALUES (?, ?)";
            PreparedStatement psInsert = con.prepareStatement(insertQuery);

            while (rsSubjects.next()) {
                int subjectId = rsSubjects.getInt("subject_id");

                // Verificar si ya está matriculado en esta asignatura
                if (!isStudentEnrolledInSubject(studentId, subjectId)) {
                    psInsert.setInt(1, studentId);
                    psInsert.setInt(2, subjectId);
                    psInsert.addBatch(); // Añadir a un batch para ejecución más eficiente
                }
            }

            // Ejecutar inserciones en batch
            psInsert.executeBatch();
            return true;

        } catch (SQLException ex) {
            System.out.println("Error al matricular al estudiante en el curso: " + ex.getMessage());
            return false;
        }
    }

// Método auxiliar para verificar si un estudiante ya está matriculado en una asignatura
    private boolean isStudentEnrolledInSubject(int studentId, int subjectId) throws SQLException {
        String query = "SELECT COUNT(*) FROM student_subjects WHERE student_id = ? AND subject_id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, studentId);
        ps.setInt(2, subjectId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0; // Devuelve true si ya está matriculado
        }
        return false;
    }
    
     public List<Course> getCoursesByStudent(int studentId) {
        List<Course> courses = new ArrayList<>();
        try {
            String query = "SELECT DISTINCT c.id, c.name "
                    + "FROM courses c "
                    + "JOIN course_subjects cs ON c.id = cs.course_id "
                    + "JOIN student_subjects ss ON cs.subject_id = ss.subject_id "
                    + "WHERE ss.student_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                courses.add(new Course(
                        rs.getInt("id"),
                        rs.getString("name")
                ));
            }
        } catch (SQLException ex) {
            System.out.println("Error al obtener los cursos del estudiante: " + ex.getMessage());
        }
        return courses;
    }

}
