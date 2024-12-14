<%-- 
    Document   : enrollStudent
    Created on : 14 dic 2024, 15:52:16
    Author     : Gabriel
--%>

<%@ page import="Data.CourseManagement" %>
<%@ page import="Data.Course" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    int studentId = Integer.parseInt(request.getParameter("id")); // ID del estudiante
    CourseManagement cm = new CourseManagement();
    List<Course> courses = cm.getCourses(); // Obtener todos los cursos
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Matricular Alumno</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    </head>
    <body>
        <div class="container mt-5">
            <h1 class="text-center">Matricular Alumno en un Curso</h1>
            <form action="EnrollStudentServlet" method="POST">
                <input type="hidden" name="student_id" value="<%= studentId %>">
                <div class="mb-3">
                    <label for="course" class="form-label">Seleccionar Curso</label>
                    <select id="course" name="course_id" class="form-select" required>
                        <% for (Course course : courses) { %>
                        <option value="<%= course.getId() %>"><%= course.getName() %></option>
                        <% } %>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Matricular</button>
            </form>
        </div>
    </body>
</html>
