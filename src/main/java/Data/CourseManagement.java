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
import Connections.MyConnection;

public class CourseManagement {

    private Connection con;

    // Constructor
    public CourseManagement() {
        this.con = new MyConnection().getConnection();
    }

    // Crear curso - CREATE
    public boolean createCourse(String name) {
        try {
            String query = "INSERT INTO courses (name) VALUES (?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, name);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error al crear curso: " + ex.getMessage());
            return false;
        }
    }

    // Leer todos los cursos - READ
    public ArrayList<Course> getCourses() {
        ArrayList<Course> courses = new ArrayList<>();
        try {
            String query = "SELECT * FROM courses";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                courses.add(new Course(
                        rs.getInt("id"),
                        rs.getString("name")
                ));
            }
        } catch (SQLException ex) {
            System.out.println("Error al obtener cursos: " + ex.getMessage());
        }
        return courses;
    }

    // Actualizar curso - UPDATE
    public boolean updateCourse(int id, String newName) {
        try {
            String query = "UPDATE courses SET name = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, newName);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error al actualizar curso: " + ex.getMessage());
            return false;
        }
    }

    // Eliminar curso - DELETE
    public boolean deleteCourse(int id) {
        try {
            String query = "DELETE FROM courses WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error al eliminar curso: " + ex.getMessage());
            return false;
        }
    }
}

