<%@ page import="Data.SubjectManagement" %>
<%@ page import="Data.Subject" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificar si el usuario está logueado y tiene el rol 'super'
    Object loggedIn = session.getAttribute("loggedInUser");
    String role = (String) session.getAttribute("userRole");

    if (loggedIn == null || !"super".equals(role)) {
        // Redirigir o mostrar un mensaje si el usuario no tiene acceso
        response.sendRedirect("Main.jsp");
        return;
    }

    // Obtener el ID del curso desde el parámetro de la URL
    String courseIdParam = request.getParameter("course_id");
    int courseId = courseIdParam != null ? Integer.parseInt(courseIdParam) : -1;

    List<Subject> subjects = null;

    if (courseId != -1) {
        // Consulta las materias asociadas al curso junto con sus profesores
        SubjectManagement subjectManagement = new SubjectManagement();
        subjects = subjectManagement.getSubjectsByCourseWithTeachers(courseId); // Método implementado
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Asignaturas del Curso</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    </head>
    <body>
        <div class="container mt-5">
            <h1 class="text-center">Asignaturas del Curso</h1>
            <% if (subjects != null && !subjects.isEmpty()) { %>
            <table class="table table-striped table-bordered mt-3">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nombre de la Asignatura</th>
                        <th>Profesor</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Subject subject : subjects) { %>
                    <tr>
                        <td><%= subject.getId() %></td>
                        <td><%= subject.getName() %></td>
                        <td><%= subject.getTeacherName() %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <p class="text-center mt-5">No hay asignaturas asociadas a este curso.</p>
            <% } %>
        </div>
    </body>
</html>
