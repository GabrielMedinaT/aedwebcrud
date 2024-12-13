<%@page import="Data.Student"%>
<%@page import="Data.StudentManagement"%>
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
<%
    StudentManagement sm = new StudentManagement();
    Student student = null;

    // Verificar si se está editando
    if ("edit".equals(request.getParameter("action"))) {
        int id = Integer.parseInt(request.getParameter("id"));
        student = sm.select(id); // Recuperar el estudiante por su ID
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <style>/* From Uiverse.io by vishnupprajapat */
            .checkbox-wrapper-46 input[type="checkbox"] {
                display: none;
                visibility: hidden;
            }

            .checkbox-wrapper-46 .cbx {
                margin: auto;
                -webkit-user-select: none;
                user-select: none;
                cursor: pointer;
            }
            .checkbox-wrapper-46 .cbx span {
                display: inline-block;
                vertical-align: middle;
                transform: translate3d(0, 0, 0);
            }
            .checkbox-wrapper-46 .cbx span:first-child {
                position: relative;
                width: 18px;
                height: 18px;
                border-radius: 3px;
                transform: scale(1);
                vertical-align: middle;
                border: 1px solid #9098a9;
                transition: all 0.2s ease;
            }
            .checkbox-wrapper-46 .cbx span:first-child svg {
                position: absolute;
                top: 3px;
                left: 2px;
                fill: none;
                stroke: #ffffff;
                stroke-width: 2;
                stroke-linecap: round;
                stroke-linejoin: round;
                stroke-dasharray: 16px;
                stroke-dashoffset: 16px;
                transition: all 0.3s ease;
                transition-delay: 0.1s;
                transform: translate3d(0, 0, 0);
            }
            .checkbox-wrapper-46 .cbx span:first-child:before {
                content: "";
                width: 100%;
                height: 100%;
                background: #506eec;
                display: block;
                transform: scale(0);
                opacity: 1;
                border-radius: 50%;
            }
            .checkbox-wrapper-46 .cbx span:last-child {
                padding-left: 8px;
            }
            .checkbox-wrapper-46 .cbx:hover span:first-child {
                border-color: #506eec;
            }

            .checkbox-wrapper-46 .inp-cbx:checked + .cbx span:first-child {
                background: #506eec;
                border-color: #506eec;
                animation: wave-46 0.4s ease;
            }
            .checkbox-wrapper-46 .inp-cbx:checked + .cbx span:first-child svg {
                stroke-dashoffset: 0;
            }
            .checkbox-wrapper-46 .inp-cbx:checked + .cbx span:first-child:before {
                transform: scale(3.5);
                opacity: 0;
                transition: all 0.6s ease;
            }

            @keyframes wave-46 {
                50% {
                    transform: scale(0.9);
                }
            }
        </style>
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
            <form action="Main.jsp" method="POST"> <!-- Aquí envías los datos a Main.jsp -->
                <input type="hidden" name="action" value="<%= request.getParameter("action") != null ? request.getParameter("action") : "insert"%>">
                <% if (request.getParameter("id") != null) {%>
                <input type="hidden" name="id" value="<%= request.getParameter("id")%>">
                <% }%>

                <div class="mb-3">
                    <label for="name" class="form-label">Nombre</label>
                    <input type="text" class="form-control" id="name" name="name" 
                           value="<%= student != null ? student.getName() : ""%>" 
                           <%= "teacher".equals(role) ? "disabled" : ""%> required>
                </div>

                <div class="mb-3">
                    <label for="surname" class="form-label">Apellidos</label>
                    <input type="text" class="form-control" id="surname" name="surname" 
                           value="<%= student != null ? student.getSurnames() : ""%>" 
                           <%= "teacher".equals(role) ? "disabled" : ""%> required>
                </div>

                <div class="mb-3">
                    <label for="age" class="form-label">Edad</label>
                    <input type="number" class="form-control" id="age" name="age" 
                           value="<%= student != null ? student.getAge() : ""%>" required>
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">Dirección</label>
                    <input type="text" class="form-control" id="address" name="address" 
                           value="<%= student != null ? student.getAddress() : ""%>" required>
                </div>

                <div class="mb-3">
                    <label for="year" class="form-label">Curso</label>
                    <input type="text" class="form-control" id="year" name="year" 
                           value="<%= student != null ? student.getYear() : ""%>" required>
                </div>

                <div class="mb-3">
                    <label for="familyData" class="form-label">Datos de la Familia</label>
                    <textarea class="form-control" id="familyData" name="familyData" rows="3" required><%= student != null ? student.getFamilyData() : ""%></textarea>
                </div>

                <div class="checkbox-wrapper-46 mb-3 form-check">
                    <input type="checkbox" id="consentimiento" name="consentimiento" class="inp-cbx" 
                           <%= student != null && student.isConsentimiento() ? "checked" : ""%> />
                    <label for="consentimiento" class="cbx">
                        <span>
                            <svg viewBox="0 0 12 10" height="10px" width="12px">
                            <polyline points="1.5 6 4.5 9 10.5 1"></polyline>
                            </svg>
                        </span>
                        <span>Consentimiento</span>
                    </label>
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

    </body>
</html>
