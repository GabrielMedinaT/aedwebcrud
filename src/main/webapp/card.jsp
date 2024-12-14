<%@page import="java.util.Objects"%>
<%@page import="Data.Student"%>
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

.student-photo {
    width: 150px;
    height: 150px;
    border-radius: 20%;
    border: 2px solid #ddd;
}

        </style>
    </head>
    <body>
        <div class="student-card">
            <!-- Mostrar foto solo si consentimiento es "Sí" -->
            <% if (student.isConsentimiento()) { %>
<div class="student-photo-container">
    <img class="student-photo" src="https://www.optimaley.com/wp-content/uploads/2014/09/foto-perfil-generica.jpg"/>
    </svg>
</div>


            <% } %>

            <!-- Nombre del estudiante -->
            <h2><%= student.getName()%> <%= student.getSurnames()%></h2>

            <!-- Detalles del estudiante -->
            <div class="student-details">
                <p><strong>Edad:</strong> <%= student.getAge()%> años</p>
                <p><strong>Dirección:</strong> <%= student.getAddress()%></p>
                <p><strong>Curso:</strong> <%= student.getYear()%></p>
                <p><strong>Datos Familiares:</strong> <%= student.getFamilyData()%></p>
                <p><strong>Consentimiento:</strong> <%= student.isConsentimiento() ? "Sí" : "No"%></p>
            </div>
        </div>
    </body>
</html>
