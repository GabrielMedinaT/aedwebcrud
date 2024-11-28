<%-- 
    Document   : numeros.jsp
    Created on : 12 nov 2024, 10:36:26
    Author     : gabriel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%for (int i=0; i<1001; i++){%>
            <p><%=i%></p>
            <%}%>
        
    </body>
</html>
