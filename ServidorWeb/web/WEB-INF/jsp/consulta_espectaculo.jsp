<%-- 
    Document   : consulta_funcion
    Created on : 22-oct-2022, 17:50:09
    Author     : Tomas
--%>

<%@page import="logica.clases.Paquete"%>
<%@page import="logica.clases.Categoria"%>
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
        int id_espec = Integer.parseInt(request.getParameter("espectaculo"));
        Espectaculo espectaculo = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_espectaculo(id_espec);
        ArrayList<String> categorias = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_categorias_espectaculo(id_espec);
        ArrayList<Funcion> funciones = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_funciones_de_espectaculo(id_espec);
        ArrayList<String> paquetes = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_nombres_de_paquetes_asociados_a_espectaculo(id_espec);
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
            <center><h1>Espectáculo <%= espectaculo.getNombre() %></h1></center>
            <div class="modal-body row">
                <div class="hstack gap-3">
                    <figure class="figure">
                        <img src="/ServidorWeb/imagen?espectaculo=<%= id_espec %>" class="figure-img img-fluid rounded" width="300">
                        <figcaption class="figure-caption"></figcaption>
                    </figure>
                    <div>
                        <span>Nombre: <%= espectaculo.getNombre() %></span><br>
                        <span>Descripción: <%= espectaculo.getDescripcion() %></span><br>
                        <span>Minutos de duración: <%= espectaculo.getDuracion() %></span><br>
                        <span>Mínimo de espectadores: <%= espectaculo.getMin_espectador() %></span><br>
                        <span>Máximo de espectadores: <%= espectaculo.getMax_espectador() %></span><br>
                        <span>Url: <a href="http://<%= espectaculo.getUrl() %>"><%= espectaculo.getUrl() %></a></span><br>
                        <span>Costo: $<%= espectaculo.getCosto() %></span><br>
                        <span>Fecha en la que se registró el espectáculo: <%= espectaculo.getFecha_registro() %></span><br>
                        <span>Artista organizador: <%= Fabrica.getInstance().getInstanceControllerUsuario().obtener_artista_de_id(espectaculo.getId_artista()).getNickname() %></span><br>
                        <span>Plataforma: <%= espectaculo.getPlataforma() %></span><br>
                        <% if (categorias.size() > 0) { %>
                            <span>
                                Categorias:
                                <% for (String categoria : categorias) {
                                    if (categoria != categorias.get(0)) { %>
                                        ,
                                    <% } %>
                                    <%=categoria%>
                                <% } %>
                            </span><br>
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="hstack gap-3">
                <div>
                    <% if (funciones.size() > 0) { %>
                        <h3>Funciones</h3>
                        <ul class="list-group">
                            <% for (Funcion funcion : funciones) { %>
                                <a href="/ServidorWeb/consulta_funcion?funcion=<%= funcion.getId() %>">
                                    <li class="list-group-item">
                                    <div class="hstack gap-3">
                                        <img src="/ServidorWeb/imagen?funcion=<%= funcion.getId() %>" class="figure-img img-fluid rounded" width="30">
                                        <span><%= funcion.getNombre() %></span>
                                    </div>
                                    </li>
                                </a>
                            <% } %>
                        </ul>
                    <% } %>
                </div>
                <div>
                    <% if (paquetes.size() > 0) { %>
                        <h3>Paquetes</h3>
                        <ul class="list-group">
                            <% for (String paquete : paquetes) { %>
                                <li class="list-group-item">
                                    <div class="hstack gap-3">
                                        <img src="/ServidorWeb/imagen?paquete=<%= paquete %>" class="figure-img img-fluid rounded" width="30">
                                        <span><%= paquete %></span>
                                    </div>
                                </li>
                            <% } %>
                        </ul>
                    <% } %>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>