<%-- 
    Document   : consulta_funcion
    Created on : 22-oct-2022, 17:50:09
    Author     : Tomas
--%>
<%@page import="DTOs.EspectaculoDto"%>
<%@page import="DTOs.FuncionDto"%>
<%@page import="Utility.GsonToUse"%>
<%@page import="enums.EstadoEspectaculo"%>
<%@page import="logica.clases.Espectaculo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="logica.clases.Artista"%>
<%@page import="logica.clases.Funcion"%>
<%@page import="Utility.Converter"%>
<%@page import="Utility.Sender"%>
<%@page import="com.google.gson.Gson"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        int id_func = Integer.parseInt(request.getParameter("funcion"));
        Funcion funcion = FuncionDto.toFuncion(GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_funcion_por_id", new Object[] {id_func} ), FuncionDto.class));
        ArrayList<Artista> artistas_invitados = Converter.to_Artista_list(GsonToUse.gson.fromJson(Sender.post("/users/obtener_artistas_invitados", new Object[] {id_func} ), ArrayList.class));
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
            <center><h1> <%= funcion.getNombre() %></h1></center>
            <div class="modal-body row">
                <div class="hstack gap-3">
                    <figure class="figure">
                        <img src="/ServidorWeb/imagen?funcion=<%= id_func %>" class="figure-img img-fluid rounded" width="200">
                        <figcaption class="figure-caption"></figcaption>
                    </figure>
                    <div>
                        
                        <p> <strong>Fecha de la función <%= Converter.formatear_date(funcion.getFecha()) %> </strong></p>
                        <p> <strong>Hora de inicio: <%= funcion.getHora_inicio() %> hs. </strong></p>
                     <!--   <p>Fecha en la que se registro en el sistema:  funcion.getFecha_registro() %></p> -->
                        <% if (session.getAttribute("tipo") != null && session.getAttribute("tipo").equals("espectador")) {
                            Espectaculo espectaculo = EspectaculoDto.toEspectaculo(GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_espectaculo_de_funcion", new Object[] {id_func} ), EspectaculoDto.class));
                        %>
                            <% if (espectaculo.getEstado() == EstadoEspectaculo.ACEPTADO && !(GsonToUse.gson.fromJson(Sender.post("/users/esta_usuario_registrado_a_funcion", new Object[] {((Usuario) session.getAttribute("usuario")).getId(),  id_func} ), boolean.class))) { %>
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
