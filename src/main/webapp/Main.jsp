<%@ page import="Data.Student" %>
<%@ page import="Data.StudentManagement" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Objects" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificar si el usuario está logueado
    Object loggedIn = session.getAttribute("loggedInUser");
    String role = (String) session.getAttribute("userRole");
    if (Objects.isNull(loggedIn)) {
        // Redirigir al login si no está logueado
        response.sendRedirect("Index.jsp");
        return; // Detener ejecución del resto del código
    }
%>

<%
    // Inicializar el controlador de estudiantes
    StudentManagement sm = new StudentManagement();
    var action = request.getParameter("action");

    // Variables para el mensaje
    String message = null;
    String status = null;

    if (action != null) {
        try {
            if (role.equals("teacher") && action.equals("delete")) {
                message = "No tienes permisos para eliminar estudiantes.";
                status = "error";
            } else if (action.equals("delete")) {
                // Eliminar estudiante
                int id = Integer.parseInt(request.getParameter("id"));
                sm.deleteStudent(id);
                message = "El estudiante se ha eliminado correctamente.";
                status = "success";
            } else if (action.equals("insert") || action.equals("edit")) {
                // Obtener datos comunes para insertar o actualizar
                String name = request.getParameter("name");
                String surname = request.getParameter("surname");
                int age = Integer.parseInt(request.getParameter("age"));
                String address = request.getParameter("address");
                int year = Integer.parseInt(request.getParameter("year"));
                String familyData = request.getParameter("familyData");

                if (action.equals("insert")) {
                    sm.createStudent(name, surname, age, address, year, familyData);
                    message = "El estudiante se ha añadido correctamente.";
                    status = "success";
                } else if (action.equals("edit")) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    if (role.equals("teacher")) {
                        // Teacher no puede actualizar nombre ni apellidos
                        sm.updateStudentPartial(id, age, address, year, familyData);
                        message = "Los datos del estudiante se han actualizado correctamente (excepto nombre y apellidos).";
                    } else {
                        sm.updateStudent(id, name, surname, age, address, year, familyData);
                        message = "El estudiante se ha actualizado correctamente.";
                    }
                    status = "success";
                }
            }
        } catch (Exception e) {
            message = "Ocurrió un error: " + e.getMessage();
            status = "error";
        }
    }

    // Obtener la lista de estudiantes
    List<Student> students = sm.getStudents();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestión de Alumnos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    </head>
    <body>
        <div class="container mt-5">
        <!-- Mensaje de éxito o error -->
        <% if (message != null && status != null) { %>
<div id="alert-message" class="alert <%= status.equals("success") ? "alert-success" : "alert-danger" %>" role="alert">
    <%= message %>
    <button type="button" class="btn btn-danger" onclick="closeAlert()">X</button>
</div>

<script>
    function closeAlert() {
        const alertMessage = document.getElementById('alert-message');
        if (alertMessage) {
            alertMessage.style.display = 'none';
        }
    }
</script>

        <% } %>
        <%
    // Obtener el nombre del usuario de la sesión
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        // Si no está logueado, redirigir al login
        response.sendRedirect("Index.jsp");
        return;
    }
%>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Bienvenido, <%= loggedInUser %></h2>
    <form action="LogoutServlet" method="POST">
        <button type="submit" class="btn btn-danger">Salir (<%= loggedInUser %>)</button>
    </form>
</div>


        <h1 class="text-center">Gestión de Estudiantes</h1>
        <div class="container-fluid">
            <div class="row">
                <div class="col-12">
                    <table class="table table-success table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>NOMBRE</th>
                                <th>APELLIDOS</th>
                                <th>EDAD</th>
                                <th>DIRECCIÓN</th>
                                <th>CURSO</th>
                                <th>DATOS DE LA FAMILIA</th>
                                <% if (!role.equals("user")) { %>
                                    <th>Actualizar</th>
                                <% } %>
                                <% if (role.equals("admin")) { %>
                                    <th>Eliminar</th>
                                <% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Student student : students) { %>
                            <tr>
                                <td><%= student.getId() %></td>
                                <td><%= student.getName() %></td>
                                <td><%= student.getSurnames() %></td>
                                <td><%= student.getAge() %></td>
                                <td><%= student.getAddress() %></td>
                                <td><%= student.getYear() %></td>
                                <td><%= student.getFamilyData() %></td>
                                <% if (!role.equals("user")) { %>
                                <td>
                                    <form action="form.jsp" method="GET">
                                        <button type="submit" class="btn btn-warning">Actualizar</button>
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" name="id" value="<%= student.getId() %>">
                                        <input type="hidden" name="name" value="<%= student.getName() %>">
                                        <input type="hidden" name="surname" value="<%= student.getSurnames() %>">
                                        <input type="hidden" name="age" value="<%= student.getAge() %>">
                                        <input type="hidden" name="address" value="<%= student.getAddress() %>">
                                        <input type="hidden" name="year" value="<%= student.getYear() %>">
                                        <input type="hidden" name="familyData" value="<%= student.getFamilyData() %>">
                                    </form>
                                </td>
                                <% } %>
                                <% if (role.equals("admin")) { %>
                                <td>
                                    <form action="Main.jsp" method="GET">
                                        <button type="submit" class="btn btn-danger">Eliminar</button>
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= student.getId() %>">
                                    </form>
                                </td>
                                <% } %>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% if (!role.equals("user")) { %>
                    <form action="form.jsp" method="GET">
                        <button class="btn btn-primary btn-lg btn-block">Añadir</button>
                        <input type="hidden" name="action" value="insert">
                    </form>
                    <% } %>
                </div>
            </div>
        </div>
    </body>
</html>
