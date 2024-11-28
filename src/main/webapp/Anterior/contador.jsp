<%-- 
    Document   : contador
    Created on : 13 nov 2024, 13:01:02
    Author     : gabriel
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Contador de visitas</title>
    </head>
<%
    int contador=0;
    var valorContador = request.getParameter("contador");
        contador = (valorContador != null) ? Integer.parseInt(request.getParameter("contador")) : 0;

     
%>

  
        <% if (contador == 0){
             contador=1;
        %>
        <h1>Es tu primera visita <h1>
               
           <% }else {%>
               <h1>Es tu visita número : <%=contador%></h1>
               
               <%  contador=contador+1;
                   }
            %>
        
        <br><!-- me cae mal el netbeans -->
        <a href="contador.jsp?contador=<%=contador%>"> LINK </a>
    

