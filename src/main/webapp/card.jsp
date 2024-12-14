<%@page import="java.util.Objects"%>
<%@page import="Data.Student"%>
<%@page import="java.util.List"%>
<%@page import="Data.Subject"%>
<%@page import="Data.SubjectManagement"%>
<%@page import="Data.Course"%>
<%@page import="Data.StudentManagement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Obtener los datos del estudiante
    StudentManagement sm = new StudentManagement();
    int studentId = Integer.parseInt(request.getParameter("id")); // Obtener el ID del estudiante desde el parámetro
    Student student = sm.select(studentId); // Recuperar los datos del estudiante

    // Verificar si el usuario está logueado
    Object loggedIn = session.getAttribute("loggedInUser");
    String role = (String) session.getAttribute("userRole");

    if (Objects.isNull(loggedIn)) {
        // Redirigir al login si no está logueado
        response.sendRedirect("index.jsp");
        return; // Detener ejecución del resto del código
    }

    // Obtener las asignaturas del estudiante
    SubjectManagement subjectManagement = new SubjectManagement();
    List<Subject> subjects = subjectManagement.getSubjectsByStudent(studentId);

    // Obtener el curso del estudiante
    List<Course> courses = sm.getCoursesByStudent(studentId);
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <title>Perfil del Estudiante</title>
        <style>
            .student-card {
                max-width: 400px;
                margin: 50px auto;
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                background-color: #f9f9f9;
                text-align: center;
            }
            .student-photo {
                width: 150px;
                height: 150px;
                border-radius: 20%;
                margin-bottom: 15px;
                object-fit: cover;
                border: 2px solid #ddd;
            }
            .student-details {
                text-align: left;
                margin-top: 15px;
            }
            .student-details p {
                margin: 5px 0;
            }
            .student-photo-container {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-bottom: 15px;
            }
            button {
                padding: 12.5px 30px;
                border: 0;
                border-radius: 100px;
                background-color: #2ba8fb;
                color: #ffffff;
                font-weight: Bold;
                transition: all 0.5s;
                -webkit-transition: all 0.5s;
            }
            button:hover {
                background-color: #6fc5ff;
                box-shadow: 0 0 20px #6fc5ff50;
                transform: scale(1.1);
            }
            button:active {
                background-color: #3d94cf;
                transition: all 0.25s;
                -webkit-transition: all 0.25s;
                box-shadow: none;
                transform: scale(0.98);
            }
        </style>
    </head>
    <body>
        <div class="student-card">
            <!-- Mostrar foto solo si consentimiento es "Sí" -->
            <% if (student.isConsentimiento()) { %>
            <div class="student-photo-container">
                <img class="student-photo" src="https://www.optimaley.com/wp-content/uploads/2014/09/foto-perfil-generica.jpg"/>
            </div>
            <% }%>

            <!-- Nombre del estudiante -->
            <h2><%= student.getName()%> <%= student.getSurnames()%></h2>

            <!-- Detalles del estudiante -->
            <div class="student-details">
                <p><strong>Edad:</strong> <%= student.getAge()%> años</p>
                <p><strong>Dirección:</strong> <%= student.getAddress()%></p>
                <p><strong>Datos Familiares:</strong> <%= student.getFamilyData()%></p>
                <p><strong>Consentimiento:</strong> <%= student.isConsentimiento() ? "Sí" : "No"%></p>
            </div>

            <!-- Sección del curso -->
            <div class="student-details mt-4">
                <h3>
                    <a href="courses.jsp"> 
                        Curso
                    </a>
                </h3> 

                <% if (courses != null && !courses.isEmpty()) { %>
                <ul>
                    <% for (Course course : courses) {%>
                    <li><%= course.getName()%></li>
                        <% } %>
                </ul>
                <% } else { %>
                <p>El estudiante no está asociado a ningún curso.</p>
                <% } %>
            </div>

            <!-- Sección de asignaturas -->
            <div class="student-details mt-4">
                <h3>Asignaturas</h3>
                <% if (subjects != null && !subjects.isEmpty()) { %>
                <ul>
                    <% for (Subject subject : subjects) {%>
                    <li><%= subject.getName()%></li>
                        <% } %>
                </ul>
                <% } else { %>
                <p>El estudiante no está matriculado en ninguna asignatura.</p>
                <% if ("super".equals(role)) {%>
                <!-- Botón de matriculación solo visible para rol 'super' -->
                <form action="enrollStudent.jsp" method="GET">
                    <input type="hidden" name="id" value="<%= studentId%>">
                    <button class="btn btn-success" type="submit">Matricularse</button>
                </form>
                <% } %>
                <% }%>
            </div>

            <form action="Main.jsp" method="get">
                <button type="submit">Volver</button>
            </form>
        </div>
    </body>
</html>
