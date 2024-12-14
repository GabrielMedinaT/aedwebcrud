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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import Connections.MyConnection;

public class SubjectManagement {

    private Connection con;

    // Constructor
    public SubjectManagement() {
        this.con = new MyConnection().getConnection();
    }

    // Crear materia - CREATE
    public boolean createSubject(String name) {
        try {
            String query = "INSERT INTO subjects (name) VALUES (?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, name);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error al crear materia: " + ex.getMessage());
            return false;
        }
    }

    // Leer todas las materias - READ
    public List<Subject> getSubjects() {
        List<Subject> subjects = new ArrayList<>();
        try {
            String query = "SELECT * FROM subjects";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                subjects.add(new Subject(
                        rs.getInt("id"),
                        rs.getString("name")
                ));
            }
        } catch (SQLException ex) {
            System.out.println("Error al obtener materias: " + ex.getMessage());
        }
        return subjects;
    }

    // Obtener materias por curso - READ BY COURSE
    public List<Subject> getSubjectsByCourse(int courseId) {
        List<Subject> subjects = new ArrayList<>();
        try {
            String query = "SELECT s.id, s.name "
                    + "FROM subjects s "
                    + "JOIN course_subjects cs ON s.id = cs.subject_id "
                    + "WHERE cs.course_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                subjects.add(new Subject(
                        rs.getInt("id"),
                        rs.getString("name")
                ));
            }
        } catch (SQLException ex) {
            System.out.println("Error al obtener materias del curso: " + ex.getMessage());
        }
        return subjects;
    }

    // Actualizar materia - UPDATE
    public boolean updateSubject(int id, String newName) {
        try {
            String query = "UPDATE subjects SET name = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, newName);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error al actualizar materia: " + ex.getMessage());
            return false;
        }
    }

    // Eliminar materia - DELETE
    public boolean deleteSubject(int id) {
        try {
            String query = "DELETE FROM subjects WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error al eliminar materia: " + ex.getMessage());
            return false;
        }
    }

    public List<Subject> getSubjectsByStudent(int studentId) {
        List<Subject> subjects = new ArrayList<>();
        try {
            String query = "SELECT s.id, s.name "
                    + "FROM subjects s "
                    + "JOIN student_subjects ss ON s.id = ss.subject_id "
                    + "WHERE ss.student_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                subjects.add(new Subject(
                        rs.getInt("id"),
                        rs.getString("name")
                ));
            }
        } catch (SQLException ex) {
            System.out.println("Error al obtener asignaturas del estudiante: " + ex.getMessage());
        }
        return subjects;
    }

    public List<Subject> getSubjectsByCourseWithTeachers(int courseId) {
        List<Subject> subjects = new ArrayList<>();
        try {
            String query = "SELECT s.id AS subject_id, s.name AS subject_name, "
                    + "t.id AS teacher_id, t.first_name, t.last_name "
                    + "FROM subjects s "
                    + "JOIN course_subjects cs ON s.id = cs.subject_id "
                    + "LEFT JOIN teacher_subjects ts ON s.id = ts.subject_id "
                    + "LEFT JOIN teachers t ON ts.teacher_id = t.id "
                    + "WHERE cs.course_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Subject subject = new Subject(
                        rs.getInt("subject_id"),
                        rs.getString("subject_name")
                );

                // Añadimos información del profesor si está disponible
                if (rs.getInt("teacher_id") != 0) {
                    subject.setTeacherName(
                            rs.getString("first_name") + " " + rs.getString("last_name")
                    );
                } else {
                    subject.setTeacherName("Sin asignar");
                }

                subjects.add(subject);
            }
        } catch (SQLException ex) {
            System.out.println("Error al obtener las asignaturas con profesores: " + ex.getMessage());
        }
        return subjects;
    }
public List<Subject> getSubjectsByTeacher(int teacherId) {
    List<Subject> subjects = new ArrayList<>();
    try {
        String query = "SELECT s.id, s.name " +
                       "FROM subjects s " +
                       "JOIN teacher_subjects ts ON s.id = ts.subject_id " +
                       "WHERE ts.teacher_id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, teacherId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            subjects.add(new Subject(
                rs.getInt("id"),
                rs.getString("name")
            ));
        }
    } catch (SQLException ex) {
        System.out.println("Error al obtener asignaturas del profesor: " + ex.getMessage());
    }
    return subjects;
}
public List<Subject> getAllSubjects() {
    List<Subject> subjects = new ArrayList<>();
    try {
        String query = "SELECT id, name FROM subjects";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            subjects.add(new Subject(
                rs.getInt("id"),
                rs.getString("name")
            ));
        }
    } catch (SQLException ex) {
        System.out.println("Error al obtener todas las asignaturas: " + ex.getMessage());
    }
    return subjects;
}

}
