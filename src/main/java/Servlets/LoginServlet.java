package Servlets;

import Data.AdminManagement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener los parámetros del formulario
        String username = request.getParameter("name");
        String password = request.getParameter("password");

        // Crear instancia de AdminManagement
        AdminManagement adminManagement = new AdminManagement();

        try {
            // Validar al usuario
            boolean isValid = adminManagement.validateAdmin(username, password);

            if (isValid) {
                // Si las credenciales son válidas, obtener el rol del usuario
                String role = adminManagement.getRole(username);

                // Iniciar sesión y guardar datos en la sesión
                HttpSession session = request.getSession();
                session.setAttribute("loggedInUser", username);
                session.setAttribute("userRole", role);

                // Redirigir al panel principal
                response.sendRedirect("Main.jsp");
            } else {
                // Si las credenciales no son válidas, mostrar error
                request.setAttribute("errorMessage", "Usuario o contraseña incorrectos.");
                request.getRequestDispatcher("no.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Manejo de errores no esperados
            System.err.println("Error durante el proceso de login: " + e.getMessage());
            request.setAttribute("errorMessage", "Ocurrió un error. Por favor, inténtelo más tarde.");
            request.getRequestDispatcher("no.jsp").forward(request, response);
        }
    }
}
