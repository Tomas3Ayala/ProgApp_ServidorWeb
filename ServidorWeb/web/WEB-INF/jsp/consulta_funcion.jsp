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
        int id_func = Integer.parseInt(request.getParameter("funcion"));
        Funcion funcion = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_funcion_por_id(id_func);
        ArrayList<Artista> artistas_invitados = Fabrica.getInstance().getInstanceControllerUsuario().obtener_artistas_invitados(id_func);
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
            <center><h1>Funcion <%= funcion.getNombre() %></h1></center>
            <div class="modal-body row">
                <div class="hstack gap-3">
                    <figure class="figure">
                        <img src="/ServidorWeb/imagen?funcion=<%= id_func %>" class="figure-img img-fluid rounded" width="300">
                        <figcaption class="figure-caption"></figcaption>
                    </figure>
                    <div>
                        <p>Nombre: <%= funcion.getNombre() %></p>
                        <p>Fecha: <%= funcion.getFecha() %></p>
                        <p>Hora a la que empieza: <%= funcion.getHora_inicio() %></p>
                        <p>Fecha en la que se registro en el sistema: <%= funcion.getFecha_registro() %></p>
                        <% if (session.getAttribute("tipo") != null && session.getAttribute("tipo") == "espectador") {
                            Espectaculo espectaculo = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_espectaculo_de_funcion(id_func);
                        %>
                            <% if (espectaculo.getEstado() == EstadoEspectaculo.ACEPTADO && !Fabrica.getInstance().getInstanceControllerUsuario().esta_usuario_registrado_a_funcion(((Usuario) session.getAttribute("usuario")).getId(), id_func)) { %>
                                <a href="/ServidorWeb/registro_funcion_espectaculo?espectaculo=<%= espectaculo.getId() %>&funcion=<%= funcion.getId() %>">Registrarse a función</a>
                            <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
            <h3>
                <% if (artistas_invitados.size() > 0) { %>
                    Artistas invitados
                <% } else { %>
                    La función no contiene artistas invitados
                <% } %>
            </h3>
            <ul class="list-group">
                <% for (Artista artista : artistas_invitados) { %>
                    <a href="/ServidorWeb/consulta_usuario?usuario=<%= artista.getNickname() %>">
                        <li class="list-group-item">
                            <div class="hstack gap-3">
                                <img src="/ServidorWeb/imagen?nick=<%= artista.getNickname() %>" class="figure-img img-fluid rounded" width="30">
                                <span><%= artista.getNickname() %></span>
                            </div>
                        </li>
                    </a>
                <% } %>
            </ul>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>
