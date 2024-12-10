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
        String username = request.getParameter("name");
        String password = request.getParameter("password");

        AdminManagement adminManagement = new AdminManagement();
        
        // Método futuro para devolver el rol del usuario (por ahora se ignora)
        //String role = adminManagement.getUserRole(username, password); 
        
        // Valida al administrador
        boolean isValid = adminManagement.validateAdmin(username, password);

        if (isValid) {
            // Guardar el usuario en la sesión
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", username);
            
            // Guardar el rol en la sesión (sin usarlo por ahora)
            //session.setAttribute("userRole", role); 
            
            // Redirige al panel principal
            response.sendRedirect("Main.jsp");
        } else {
            // Manejar error
            request.setAttribute("errorMessage", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("no.jsp").forward(request, response);
        }
    }
}
