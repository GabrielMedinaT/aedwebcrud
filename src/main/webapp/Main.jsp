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
                boolean consentimiento = "on".equals(request.getParameter("consentimiento"));

                if (action.equals("insert")) {
                    sm.createStudent(name, surname, age, address, year, familyData, consentimiento);
                    message = "El estudiante se ha añadido correctamente.";
                    status = "success";
                } else if (action.equals("edit")) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    if (role.equals("teacher")) {
                        // Teacher no puede actualizar nombre ni apellidos
                        sm.updateStudentPartial(id, age, address, year, familyData);
                        message = "Los datos del estudiante se han actualizado correctamente (excepto nombre y apellidos).";
                    } else {
                        sm.updateStudent(id, name, surname, age, address, year, familyData, consentimiento);
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

    // Obtener los parámetros de orden
    String sortField = request.getParameter("sort");
    String order = request.getParameter("order");

    // Valores predeterminados
    if (sortField == null || sortField.isEmpty()) {
        sortField = "id";
    }
    if (order == null || order.isEmpty()) {
        order = "asc";
    }

    // Alternar orden
    String newOrder = order.equals("asc") ? "desc" : "asc";

    // Obtener la lista de estudiantes
    List<Student> students = sm.getStudents(sortField, order);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestión de Alumnos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <style>
            a, a:link, a:visited, a:hover, a:active {
                text-decoration: none;
                color: inherit;
            }
            .hourglassBackground {
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background-color: rgb(71, 60, 60);
                height: 130px;
                width: 130px;
                border-radius: 50%;
                z-index: 9999;
            }

            .hourglassContainer {
                position: absolute;
                top: 30px;
                left: 40px;
                width: 50px;
                height: 70px;
                animation: hourglassRotate 2s ease-in 0s infinite;
                transform-style: preserve-3d;
                perspective: 1000px;
            }
            /* Resto del CSS de la animación */
            .hourglassContainer div,
            .hourglassContainer div:before,
            .hourglassContainer div:after {
                transform-style: preserve-3d;
            }
            @keyframes hourglassRotate {
                0% {
                    transform: rotateX(0deg);
                }
                50% {
                    transform: rotateX(180deg);
                }
                100% {
                    transform: rotateX(180deg);
                }
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <!-- Mensaje de éxito o error -->
            <% if (message != null && status != null) {%>
            <div id="alert-message" class="alert <%= status.equals("success") ? "alert-success" : "alert-danger"%>" role="alert">
                <%= message%>
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
            <% }%>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2>Bienvenido, <%= loggedIn%></h2>
                <form action="LogoutServlet" method="POST">
                    <button type="submit" class="btn btn-success">Salir (<%= loggedIn%>)</button>
                </form>
            </div>

            <h1 class="text-center">Gestión de Estudiantes</h1>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12">
                        <table class="table table-success table-striped">
                            <thead>
                                <tr>
                                    <th><a href="Main.jsp?sort=id&order=<%= ("id".equals(sortField) ? newOrder : "asc")%>">ID<%= "id".equals(sortField) ? ("asc".equals(order) ? " ⬆" : " ⬇") : ""%></a></th>
                                    <th><a href="Main.jsp?sort=name&order=<%= ("name".equals(sortField) ? newOrder : "asc")%>">NOMBRE<%= "name".equals(sortField) ? ("asc".equals(order) ? " ⬆" : " ⬇") : ""%></a></th>
                                    <th><a href="Main.jsp?sort=surname&order=<%= ("surname".equals(sortField) ? newOrder : "asc")%>">APELLIDOS<%= "surname".equals(sortField) ? ("asc".equals(order) ? " ⬆" : " ⬇") : ""%></a></th>
                                    <th><a href="Main.jsp?sort=age&order=<%= ("age".equals(sortField) ? newOrder : "asc")%>">EDAD<%= "age".equals(sortField) ? ("asc".equals(order) ? " ⬆" : " ⬇") : ""%></a></th>
                                    <th><a href="Main.jsp?sort=address&order=<%= ("address".equals(sortField) ? newOrder : "asc")%>">DIRECCIÓN<%= "address".equals(sortField) ? ("asc".equals(order) ? " ⬆" : " ⬇") : ""%></a></th>
                                    <th><a href="Main.jsp?sort=year&order=<%= ("year".equals(sortField) ? newOrder : "asc")%>">CURSO<%= "year".equals(sortField) ? ("asc".equals(order) ? " ⬆" : " ⬇") : ""%></a></th>
                                    <th><a href="Main.jsp?sort=consentimiento&order=<%= ("consentimiento".equals(sortField) ? newOrder : "asc")%>">
                                            CONSENTIMIENTO<%= "consentimiento".equals(sortField) ? ("asc".equals(order) ? " ⬆" : " ⬇") : ""%>
                                        </a></th>

                                    <th><a href="Main.jsp?sort=familydata&order=<%= ("familydata".equals(sortField) ? newOrder : "asc")%>">DATOS DE FAMILIA<%= "familydata".equals(sortField) ? ("asc".equals(order) ? " ⬆" : " ⬇") : ""%></a></th>
                                        <% if (!role.equals("user")) { %>
                                    <th>Actualizar</th>
                                        <% } %>
                                        <% if (role.equals("admin")) { %>
                                    <th>Eliminar</th>
                                        <% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Student student : students) {%>
                                <tr>
                                    <td><%= student.getId()%></td>
                                    <td><%= student.getName()%></td>
                                    <td><%= student.getSurnames()%></td>
                                    <td><%= student.getAge()%></td>
                                    <td><%= student.getAddress()%></td>
                                    <td><%= student.getYear()%></td>
                                    <td><%= student.isConsentimiento() ? "Sí" : "No"%></td>
                                    <td><%= student.getFamilyData()%></td>
                                    <% if (!role.equals("user")) {%>
                                    <td>
                                        <form action="form.jsp" method="GET">
                                            <button type="submit" class="btn btn-warning">Actualizar</button>
                                            <input type="hidden" name="action" value="edit">
                                            <input type="hidden" name="id" value="<%= student.getId()%>">
                                        </form>
                                    </td>
                                    <% } %>
                                    <% if (role.equals("admin")) {%>
                                    <td>
                                        <form action="Main.jsp" method="GET">
                                            <button type="submit" class="btn btn-danger">Eliminar</button>
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= student.getId()%>">
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
                        <% }%>
                    </div>
                </div>
            </div>
        </div>
        <div id="loading" style="display: none;" class="hourglassBackground">
            <div class="hourglassContainer">

            </div>
        </div>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const sortLinks = document.querySelectorAll('a[href*="Main.jsp?sort"]');
                const loadingDiv = document.getElementById('loading');

                sortLinks.forEach(link => {
                    link.addEventListener('click', function (event) {
                        event.preventDefault();
                        loadingDiv.style.display = 'block';
                        const href = this.href;

                        setTimeout(() => {
                            window.location.href = href;
                        }, 500);
                    });
                });
            });
        </script>
    </body>
</html>
