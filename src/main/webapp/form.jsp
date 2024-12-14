<%@page import="Data.Student"%>
<%@page import="Data.Teacher"%>
<%@page import="Data.StudentManagement"%>
<%@page import="Data.TeacherManagement"%>
<%@page import="Data.SubjectManagement"%>
<%@page import="Data.Subject"%>
<%@page import="java.util.Objects"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificar si el usuario está logueado
    Object loggedIn = session.getAttribute("loggedInUser");
    String role = (String) session.getAttribute("userRole");
    if (Objects.isNull(loggedIn)) {
        response.sendRedirect("Index.jsp");
        return;
    }

    // Obtener el parámetro source para determinar si es un formulario de estudiantes o profesores
    String source = request.getParameter("source");
    if (source == null || (!source.equals("Main.jsp") && !source.equals("teachers.jsp"))) {
        out.println("<h1>Error: No se especificó una fuente válida (Main.jsp o teachers.jsp).</h1>");
        return;
    }

    // Gestión de datos
    StudentManagement sm = new StudentManagement();
    TeacherManagement tm = new TeacherManagement();
    SubjectManagement subm = new SubjectManagement();
    Student student = null;
    Teacher teacher = null;

    if ("edit".equals(request.getParameter("action"))) {
        int id = Integer.parseInt(request.getParameter("id"));
        if (source.equals("Main.jsp")) {
            student = sm.select(id); // Recuperar estudiante
        } else if (source.equals("teachers.jsp")) {
            teacher = tm.select(id); // Recuperar profesor
        }
    }

    // Obtener asignaturas actuales y disponibles solo si es profesor
    List<Subject> currentSubjects = source.equals("teachers.jsp") && teacher != null 
                                    ? subm.getSubjectsByTeacher(teacher.getId()) 
                                    : null;
    List<Subject> allSubjects = source.equals("teachers.jsp") ? subm.getAllSubjects() : null;
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <title>Formulario <%= source.equals("teachers.jsp") ? "Profesor" : "Alumno" %></title>
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
    </head>
    <body>
        <div class="container mt-5">
            <h1 class="text-center">
                <%= "insert".equals(request.getParameter("action")) ? "Añadir " : "Editar " %>
                <%= source.equals("teachers.jsp") ? "Profesor" : "Alumno" %>
            </h1>

            <form action="<%= source.equals("teachers.jsp") ? "teachers.jsp" : "Main.jsp" %>" method="POST">
                <input type="hidden" name="action" value="<%= request.getParameter("action") != null ? request.getParameter("action") : "insert" %>">
                <input type="hidden" name="source" value="<%= source %>">
                <% if (request.getParameter("id") != null) { %>
                <input type="hidden" name="id" value="<%= request.getParameter("id") %>">
                <% } %>

                <!-- Campos comunes para ambos -->
                <div class="mb-3">
                    <label for="name" class="form-label"><%= source.equals("teachers.jsp") ? "Nombre del Profesor" : "Nombre del Alumno" %></label>
                    <input type="text" class="form-control" id="name" name="<%= source.equals("teachers.jsp") ? "first_name" : "name" %>"
                           value="<%= source.equals("teachers.jsp") && teacher != null ? teacher.getFirstName() : (student != null ? student.getName() : "") %>" required>
                </div>

                <div class="mb-3">
                    <label for="surname" class="form-label">Apellidos</label>
                    <input type="text" class="form-control" id="surname" name="<%= source.equals("teachers.jsp") ? "last_name" : "surname" %>"
                           value="<%= source.equals("teachers.jsp") && teacher != null ? teacher.getLastName() : (student != null ? student.getSurnames() : "") %>" required>
                </div>

                <% if (source.equals("Main.jsp")) { %>
                <!-- Campos exclusivos para estudiantes -->
                <div class="mb-3">
                    <label for="age" class="form-label">Edad</label>
                    <input type="number" class="form-control" id="age" name="age"
                           value="<%= student != null ? student.getAge() : "" %>" required>
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">Dirección</label>
                    <input type="text" class="form-control" id="address" name="address"
                           value="<%= student != null ? student.getAddress() : "" %>" required>
                </div>

                <div class="mb-3">
                    <label for="year" class="form-label">Curso</label>
                    <input type="text" class="form-control" id="year" name="year"
                           value="<%= student != null ? student.getYear() : "" %>" required>
                </div>

                <div class="mb-3">
                    <label for="familyData" class="form-label">Datos de la Familia</label>
                    <textarea class="form-control" id="familyData" name="familyData" rows="3" required><%= student != null ? student.getFamilyData() : "" %></textarea>
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
                <% } else if (source.equals("teachers.jsp")) { %>
                <!-- Campos exclusivos para profesores -->
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email"
                           value="<%= teacher != null ? teacher.getEmail() : "" %>" required>
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label">Teléfono</label>
                    <input type="text" class="form-control" id="phone" name="phone"
                           value="<%= teacher != null ? teacher.getPhone() : "" %>" required>
                </div>

                <!-- Asignaturas -->
                <h3>Asignaturas</h3>
                <% if (currentSubjects != null && !currentSubjects.isEmpty()) { %>
                <ul>
                    <% for (Subject subject : currentSubjects) { %>
                    <li><%= subject.getName() %></li>
                    <% } %>
                </ul>
                <% } else { %>
                <p>No tiene asignaturas asignadas.</p>
                <% } %>

                <div class="mb-3">
                    <label for="assignSubject" class="form-label">Asignar nueva asignatura</label>
                    <select class="form-select" id="assignSubject" name="assign_subject">
                        <option value="">Seleccione una asignatura</option>
                        <% for (Subject subject : allSubjects) { %>
                        <option value="<%= subject.getId() %>"><%= subject.getName() %></option>
                        <% } %>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="removeSubject" class="form-label">Dar de baja asignatura</label>
                    <select class="form-select" id="removeSubject" name="remove_subject">
                        <option value="">Seleccione una asignatura</option>
                        <% for (Subject subject : currentSubjects) { %>
                        <option value="<%= subject.getId() %>"><%= subject.getName() %></option>
                        <% } %>
                    </select>
                </div>
                <% } %>

                <div class="d-grid gap-2">
                    <button type="submit" class="<%= "edit".equals(request.getParameter("action")) ? "btn btn-warning" : "btn btn-primary" %>">
                        <%= "edit".equals(request.getParameter("action")) ? "Actualizar" : "Insertar" %>
                    </button>
                </div>
            </form>
        </div>
    </body>
</html>
