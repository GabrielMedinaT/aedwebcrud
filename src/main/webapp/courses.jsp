<%@ page import="Data.CourseManagement" %>
<%@ page import="Data.Course" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    CourseManagement courseManagement = new CourseManagement();
    List<Course> courses = courseManagement.getCourses();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Listado de Cursos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    </head>
    <body>
        <div class="container mt-5">
            <h1 class="text-center">Listado de Cursos</h1>
            <table class="table table-striped table-bordered mt-3">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nombre del Curso</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (courses != null && !courses.isEmpty()) { 
                           for (Course course : courses) { %>
                    <tr>
                        <td><%= course.getId() %></td>
                        <td>
                            <a href="subjectsByCourse.jsp?course_id=<%= course.getId() %>">
                                <%= course.getName() %>
                            </a>
                        </td>
                    </tr>
                    <% } 
                       } else { %>
                    <tr>
                        <td colspan="2" class="text-center">No hay cursos disponibles.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </body>
</html>
