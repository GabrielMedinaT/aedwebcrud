package Connections;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Gabriel Medina
 */
public class MyConnection {
    private static final String URL = "jdbc:mysql://localhost:3307/aed";
    private static final String URLP = "jdbc:postgresql://localhost:5432/aed?characterEncoding=UTF-8";
    private static final String USERP = "postgres";
    private static final String USER = "root";
    private static final String PASSWORD = "root1234";
    private Connection con;

    public MyConnection() {
        try {
            System.out.println("Intentando cargar el driver MySQL...");
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver MySQL cargado exitosamente.");
            
            System.out.println("Intentando conectar a la base de datos MySQL...");
            con = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Conexión establecida exitosamente con MySQL.");
        } catch (ClassNotFoundException ex) {
            System.out.println("Error al cargar el driver: " + ex.getMessage());
            con = null;
        } catch (SQLException se) {
            System.out.println("Error de SQL al conectar: " + se.getMessage());
            con = null;
        }
    }

    public Connection getConnection() {
        if (con == null) {
            System.out.println("Error: La conexión no está disponible.");
        }
        return con;
    }
}
