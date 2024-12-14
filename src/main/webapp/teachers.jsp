<%-- 
    Document   : teachers
    Created on : 14 dic 2024, 14:29:57
    Author     : Gabriel
--%>

<%@ page import="Data.Teacher" %>
<%@ page import="Data.TeacherManagement" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Objects" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificar si el usuario está logueado
    Object loggedIn = session.getAttribute("loggedInUser");
    String role = (String) session.getAttribute("userRole");

    if (Objects.isNull(loggedIn) || !"super".equals(role)) {
        // Redirigir al login o a una página de error si no es admin
        response.sendRedirect("index.jsp"); // Cambiar a una página de acceso denegado si es necesario
        return;
    }

    // Inicializar el controlador de profesores
    TeacherManagement tm = new TeacherManagement();
    String action = request.getParameter("action");

    // Variables para mensajes
    String message = null;
    String status = null;

    if (action != null) {
        try {
            if (action.equals("delete")) {
                // Eliminar profesor
                int id = Integer.parseInt(request.getParameter("id"));
                tm.deleteTeacher(id);
                message = "El profesor se ha eliminado correctamente.";
                status = "success";
            } else if (action.equals("insert") || action.equals("edit")) {
                // Obtener datos comunes para insertar o actualizar
                String firstName = request.getParameter("first_name");
                String lastName = request.getParameter("last_name");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");

                if (action.equals("insert")) {
                    tm.createTeacher(firstName, lastName, email, phone, true); // Activo por defecto
                    message = "El profesor se ha añadido correctamente.";
                    status = "success";
                } else if (action.equals("edit")) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    tm.updateTeacher(id, firstName, lastName, email, phone, null); // Active no se actualiza aquí
                    message = "El profesor se ha actualizado correctamente.";
                    status = "success";
                }
            }
        } catch (Exception e) {
            message = "Ocurrió un error: " + e.getMessage();
            status = "error";
        }
    }

    // Obtener lista de profesores
    List<Teacher> teachers = tm.getTeachers("id", "asc"); // Orden por defecto
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestión de Profesores</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    </head>
    <body>
        <div class="container mt-5">
            <!-- Mensaje de éxito o error -->
            <% if (message != null && status != null) {%>
            <div class="alert <%= status.equals("success") ? "alert-success" : "alert-danger"%>" role="alert">
                <%= message%>
            </div>
            <% } %>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2>Gestión de Profesores</h2>
                <form action="LogoutServlet" method="POST">
                    <button class="btn btn-danger">Cerrar sesión</button>
                </form>
            </div>

            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Apellido</th>
                        <th>Email</th>
                        <th>Teléfono</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Teacher teacher : teachers) {%>
                    <tr>
                        <td><%= teacher.getId()%></td>
                        <td><%= teacher.getFirstName()%></td>
                        <td><%= teacher.getLastName()%></td>
                        <td><%= teacher.getEmail()%></td>
                        <td><%= teacher.getPhone()%></td>
                        <td>
                            <!-- Botón para editar -->
                            <form action="form.jsp" method="GET" style="display: inline;">
                                <button type="submit" class="btn btn-warning btn-sm">Editar</button>
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="id" value="<%= teacher.getId()%>">
                                <input type="hidden" name="source" value="teachers.jsp"> <!-- Parámetro source -->
                            </form>
                            <!-- Botón para eliminar -->
                            <form action="teachers.jsp" method="GET" style="display: inline;">
                                <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= teacher.getId()%>">
                            </form>
                        </td>
                    </tr>
                    <% }%>
                </tbody>
            </table>

            <!-- Botón para agregar un profesor -->
            <form action="form.jsp" method="GET">
                <button class="btn btn-primary">Añadir Profesor</button>
                <input type="hidden" name="action" value="insert">
                <input type="hidden" name="source" value="teachers.jsp"> <!-- Parámetro source -->
            </form>
        </div>
    </body>
</html>
