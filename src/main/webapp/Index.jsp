<%@ page import="Data.StudentManagement" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
 
    StudentManagement manager = new StudentManagement();
    List<Map<String, Object>> students = manager.readStudents();
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
<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <h1 class="text-center">Gestión de Alumnos - IES El Rincón</h1>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>NOMBRE</th>
                        <th>APELLIDOS</th>
                        <th>EDAD</th>
                        <th>DIRECCIÓN</th>
                        <th>CURSO</th>
                        <th>DATOS DE LA FAMILIA</th>
                        <th>Actualizar</th>
                        <th>Eliminar</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> student : students) { %>
                        <tr>
                            <td><%= student.get("id") %></td>
                            <td><%= student.get("name") %></td>
                            <td><%= student.get("surname") %></td>
                            <td><%= student.get("age") %></td>
                            <td><%= student.get("address") %></td>
                            <td><%= student.get("year") %></td>
                            <td><%= student.get("familyData") %></td>
                            <td>
                                <form action="update.jsp" method="get">
                                    <input type="hidden" name="id" value="<%= student.get("id") %>">
                                    <button type="submit" class="btn btn-warning">Actualizar</button>
                                </form>
                            </td>
                            <td>
                                <form action="Index.jsp" method="GET">
                                    <button type="submit" class="btn btn-danger">Eliminar</button>
                                    <input type="hidden" name="id" value="<%= student.get("id") %>">      
                                </form>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
                <button class="btn btn-primary btn-lg btn-block">Añadir</button>
        </div>
    </div>
</div>
</body>
</html>
