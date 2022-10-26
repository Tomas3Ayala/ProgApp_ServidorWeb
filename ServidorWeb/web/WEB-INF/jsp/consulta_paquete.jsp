<%-- 
    Document   : consulta_paquete
    Created on : 24/10/2022, 11:46:04 PM
    Author     : 59892
--%>

<%@page import="logica.clases.Paquete"%>
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
        int id_paqu = Integer.parseInt(request.getParameter("paquete"));
        Paquete paquete = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_info_paquetes(id_paqu);
        ArrayList<Espectaculo> espectaculos = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_espectaculos_aceptados_de_paquete(id_paqu);
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Info de Paquetes</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript"> </script>
    </head>
    <body>
        <%@ include file="/WEB-INF/jsp/cabezal.jsp"%>
        <div class="container">
            <center><h1>Paquete <%= paquete.getNombre() %></h1></center>
            <div class="modal-body row">
                <div class="hstack gap-3">
                    <figure class="figure">
                        <img src="/ServidorWeb/imagen?paquete=<%= id_paqu %>" class="figure-img img-fluid rounded" width="300">
                        <figcaption class="figure-caption"></figcaption>
                    </figure>
                    <div>
                        <p>Nombre: <%= paquete.getNombre() %></p>
                        <p>Descripcion: <%= paquete.getDescripcion() %></p>
                        <p>Fecha de inicio: <%= paquete.getFecha_inicio() %></p>
                        <p>Fecha de fin: <%= paquete.getFecha_fin() %></p>
                        <p>Descuento: <%= paquete.getDescuento() %></p>
                        <p>ID: <%= paquete.getId() %></p>

                        <% if (espectaculos.size() > 0) { %>
                            <span>
                                Categorias:
                                <% for (Espectaculo espectaculo : espectaculos) { %>
                                    <% ArrayList<String> categorias = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_categorias_espectaculo(espectaculo.getId()); %>
                                    <% for (String categoria : categorias) {
                                        if (categoria != categorias.get(0)) { %>
                                            ,
                                        <% } %>
                                        <%=categoria%>
                                    <% } %>
                                <% } %>
                            </span><br>
                        <% } %>
                    </div>
                </div>
            </div>
            <% if (espectaculos.size() > 0) { %>
                <h3>Espectaculos asociados</h3>
                <ul class="list-group">
                    <% for (Espectaculo espectaculo3 : espectaculos) { %>
                        <li class="list-group-item">
                            <div class="hstack gap-3">
                                <img src="/ServidorWeb/imagen?nick=<%= espectaculo3.getId()%>" class="figure-img img-fluid rounded" width="30">
                                <span><%= espectaculo3.getNombre() %></span>
                                <a href="/ServidorWeb/consulta_espectaculo?espectaculo=<%= espectaculo3.getId() %>">Consultar espectaculo</a>
                            </div>
                        </li>
                    <% } %>
                </ul>
            <% } %>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>
