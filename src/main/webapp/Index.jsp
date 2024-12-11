<%-- 
    Document   : index.jsp
    Created on : 10 dic 2024, 9:03:13
    Author     : Gabriel
--%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center vh-100">
    <div class="card shadow-sm" style="width: 400px;">
        <div class="card-header bg-primary text-white text-center">
            <h4>Login de Administrador</h4>
        </div>
        <div class="card-body">
            <p class="text-center text-muted mb-4">Ingrese sus credenciales para acceder al sistema.</p>
            <form action="LoginServlet" method="POST">
                <div class="mb-3">
                    <label for="name" class="form-label">Usuario:</label>
                    <input type="text" class="form-control" id="name" name="name" placeholder="Ingresa tu usuario" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Contraseña:</label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Ingresa tu contraseña" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Login</button>
            </form>
            <% 
                // Mostrar mensaje de error si existe
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) { 
            %>
            <div class="alert alert-danger mt-3" role="alert">
                <%= errorMessage %>
            </div>
            <% } %>
        </div>
        <div class="card-footer text-center text-muted">
            &copy; 2024 Gabriel - Todos los derechos reservados
        </div>
    </div>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
