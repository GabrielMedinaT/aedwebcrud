package Servlets;


import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;



/**
 *
 * @author Gabriel Medina
 */
public class MiServlet extends HttpServlet{

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (java.io.PrintWriter salida = resp.getWriter()) {
            salida.println("Hola desde el servidor");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (java.io.PrintWriter salida = resp.getWriter()) {
            salida.println("Hola desde el servidor de gabriel");
        }
    }   
}
