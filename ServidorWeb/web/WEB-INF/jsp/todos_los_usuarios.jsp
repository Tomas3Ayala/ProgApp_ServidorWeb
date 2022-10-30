<%-- 
    Document   : consulta_funcion
    Created on : 22-oct-2022, 17:50:09
    Author     : Tomas
--%>

<%@page import="logica.enums.EstadoEspectaculo"%>
<%@page import="logica.clases.Espectaculo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="logica.clases.Artista"%>
<%@page import="logica.clases.Funcion"%>
<%@page import="logica.Fabrica"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        ArrayList<String> usuarios = Fabrica.getInstance().getInstanceControllerUsuario().obtener_nicknames_de_usuarios();
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Función de espectaculo</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript"> </script>
    </head>
    <body>
        <%@ include file="/WEB-INF/jsp/cabezal.jsp"%>
        <div class="container">
            <h3>
                <% if (usuarios.size() > 0) { %>
                    Usuarios registrados
                <% } else { %>
                    No hay usuarios registrados aún
                <% } %>
            </h3>
            <ul class="list-group">
                <% for (String nickname : usuarios) { %>
                    <a href="/ServidorWeb/consulta_usuario?usuario=<%= nickname %>">
                        <li class="list-group-item">
                            <div class="hstack gap-3">
                                <img src="/ServidorWeb/imagen?nick=<%= nickname %>" class="figure-img img-fluid rounded" width="130">
                                <span><%= nickname %></span>
                            </div>
                        </li>
                    </a>
                <% } %>
            </ul>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>
