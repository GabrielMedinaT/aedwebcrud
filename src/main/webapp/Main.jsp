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
            /* From Uiverse.io by vinodjangid07 */
            .Btn {
                display: flex;
                align-items: center;
                justify-content: flex-start;
                width: 45px;
                height: 45px;
                border: none;
                border-radius: 50%;
                cursor: pointer;
                position: relative;
                overflow: hidden;
                transition-duration: .3s;
                box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.199);
                background-color: rgb(255, 65, 65);
            }

            /* plus sign */
            .sign {
                width: 100%;
                transition-duration: .3s;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .sign svg {
                width: 17px;
            }

            .sign svg path {
                fill: white;
            }
            /* text */
            .text {
                position: absolute;
                right: 0%;
                width: 0%;
                opacity: 0;
                color: white;
                font-size: 1em;
                font-weight: 600;
                transition-duration: .3s;
            }
            /* hover effect on button width */
            .Btn:hover {
                width: 125px;
                border-radius: 40px;
                transition-duration: .3s;
            }

            .Btn:hover .sign {
                width: 30%;
                transition-duration: .3s;
                padding-left: 20px;
            }
            /* hover effect button's text */
            .Btn:hover .text {
                opacity: 1;
                width: 70%;
                transition-duration: .3s;
                padding-right: 10px;
            }
            /* button click effect*/
            .Btn:active {
                transform: translate(2px ,2px);
            }
            #tabla {
                box-shadow: 0 4px 8px rgba(0.2, 0.2, 0.2, 0.2);
                height: 100%;
                border-radius:  12px;
            }
            #tabla tr {
                cursor: pointer;
                transition: all 0.5s;
            }
            #tabla tr:hover {
                transform: scale(1.01);

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
                    <button class="Btn" type="submit">
                        <div class="sign">
                            <svg viewBox="0 0 512 512">
                            <path d="M377.9 105.9L500.7 228.7c7.2 7.2 11.3 17.1 11.3 27.3s-4.1 20.1-11.3 27.3L377.9 406.1c-6.4 6.4-15 9.9-24 9.9c-18.7 0-33.9-15.2-33.9-33.9l0-62.1-128 0c-17.7 0-32-14.3-32-32l0-64c0-17.7 14.3-32 32-32l128 0 0-62.1c0-18.7 15.2-33.9 33.9-33.9c9 0 17.6 3.6 24 9.9zM160 96L96 96c-17.7 0-32 14.3-32 32l0 256c0 17.7 14.3 32 32 32l64 0c17.7 0 32 14.3 32 32s-14.3 32-32 32l-64 0c-53 0-96-43-96-96L0 128C0 75 43 32 96 32l64 0c17.7 0 32 14.3 32 32s-14.3 32-32 32z"></path>
                            </svg>
                        </div>
                        <div class="text">Salir (<%= loggedIn%>)</div>
                    </button>
                </form>
            </div>

            <h1 class="text-center">Gestión de Estudiantes</h1>
            <div class="container-fluid" >
                <div class="row">
                    <div class="col-12">
                        <table class="table table-success table-striped" id="tabla">
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
                                    <td>
                                        <form action="card.jsp" method="POST" style="display: inline;">
                                            <input type="hidden" name="id" value="<%= student.getId()%>">
                                            <button type="submit" class="btn btn-link" style="padding: 0; border: none; background: none;">
                                                <%= student.getId()%>
                                            </button>
                                        </form>
                                    </td>


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
