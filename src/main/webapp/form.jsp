<%@page import="java.util.Objects"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <title>Formulario Alumno</title>
    </head>
    <body>
        <div class="container mt-5">
            <!-- Mensaje de éxito o error -->
            <% String message = (String) request.getAttribute("message");
                String status = (String) request.getAttribute("status");
            %>
            <% if (message != null && status != null) {%>
            <div class="alert <%= status.equals("success") ? "alert-success" : "alert-danger"%>" role="alert">
                <%= message%>
            </div>
            <% }%>

            <!-- Título del formulario -->
            <div class="row">
                <div class="col-12">
                    <h1 class="text-center">
                        <%= "insert".equals(request.getParameter("action")) ? "Añadir Alumno" : "Editar Alumno"%>
                    </h1>
                </div>
            </div>

            <!-- Formulario -->
            <div class="row">
                <div class="col-12">
                    <form action="Main.jsp" method="POST">
                        <input type="hidden" name="action" value="<%= request.getParameter("action") != null ? request.getParameter("action") : "insert"%>">

                        <% if (request.getParameter("id") != null) {%>
                        <input type="hidden" name="id" value="<%= request.getParameter("id")%>">
                        <% }%>

                        <div class="mb-3">
                            <label for="name" class="form-label">Nombre</label>
                            <input type="text" class="form-control" id="name" name="name" 
                                   value="<%= request.getParameter("name") != null ? request.getParameter("name") : ""%>" 
                                   <%= "teacher".equals(role) ? "disabled" : "" %> required>
                            <% if ("teacher".equals(role)) { %>
                            <small class="text-danger">Contacte con el administrador para modificar este campo.</small>
                            <% } %>
                        </div>

                        <div class="mb-3">
                            <label for="surname" class="form-label">Apellidos</label>
                            <input type="text" class="form-control" id="surname" name="surname" 
                                   value="<%= request.getParameter("surname") != null ? request.getParameter("surname") : ""%>" 
                                   <%= "teacher".equals(role) ? "disabled" : "" %> required>
                            <% if ("teacher".equals(role)) { %>
                            <small class="text-danger">Contacte con el administrador para modificar este campo.</small>
                            <% } %>
                        </div>

                        <div class="mb-3">
                            <label for="age" class="form-label">Edad</label>
                            <input type="number" class="form-control" id="age" name="age" 
                                   value="<%= request.getParameter("age") != null ? request.getParameter("age") : ""%>" required>
                        </div>

                        <div class="mb-3">
                            <label for="address" class="form-label">Dirección</label>
                            <input type="text" class="form-control" id="address" name="address" 
                                   value="<%= request.getParameter("address") != null ? request.getParameter("address") : ""%>" required>
                        </div>

                        <div class="mb-3">
                            <label for="year" class="form-label">Curso</label>
                            <input type="text" class="form-control" id="year" name="year" 
                                   value="<%= request.getParameter("year") != null ? request.getParameter("year") : ""%>" required>
                        </div>

                        <div class="mb-3">
                            <label for="familyData" class="form-label">Datos de la Familia</label>
                            <textarea class="form-control" id="familyData" name="familyData" rows="3" required><%= request.getParameter("familyData") != null ? request.getParameter("familyData") : ""%></textarea>
                        </div>

                        <div class="d-grid gap-2">
                            <button 
                                type="submit" 
                                class="<%= request.getParameter("action") != null && request.getParameter("action").equals("edit") ? "btn btn-warning" : "btn btn-primary"%>">
                                <%= request.getParameter("action") != null && request.getParameter("action").equals("edit") ? "Actualizar" : "Insertar"%>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
