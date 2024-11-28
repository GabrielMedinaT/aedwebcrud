<%-- 
    Document   : informacioncliente
    Created on : 13 nov 2024, 12:33:46
    Author     : gabriel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Información cliente</title>
    </head>
    <body>
        <ul>
            <li>El metodo con el que fue hecha la petición es : <%=request.getMethod()%> </li>
            <li>La direccion remota es: <%=request.getRemoteAddr()%>  </li>
            <li>Dirección del servidor:<%=request.getLocalAddr()%> </li>
            <li>Puerto remoto: <%=request.getRemotePort()%> </li>

        </ul>
    </body>
</html>
