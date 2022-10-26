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
        ArrayList<Paquete> all_paquetes = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_paquetes();
        ArrayList<Espectaculo> espectaculos_paquetes = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_espectaculos_sin_plataforma(id_paqu);
        ArrayList <String> espectaculos = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_espectaculos_de_paquete(id_paqu);
       // ArrayList<Artista> artistas_invitados = Fabrica.getInstance().getInstanceControllerUsuario().obtener_artistas_invitados(id_func);
       ArrayList<String> lista = new ArrayList<>();
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
                         
                        <%for (int i = 0; i < espectaculos.size(); i++) {
                        int idespec = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_idespectaculo(espectaculos.get(i));
                        Espectaculo espectaculo = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_espectaculo(idespec);
                        ArrayList<String> cat = new ArrayList<>();
                            cat = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_categorias_espectaculo(idespec);

                            boolean existe = lista.contains(cat);
                            if (!existe){
                            for (int a = 0; a < cat.size(); a++){
                            lista.add(cat.get(a));%>
                            <p> Categorias: <%= cat.get(a) %> </p> 
                                }

                              }
                            }
                               
                    </div>
                </div>
            </div>
            <% if (espectaculos_paquetes.size() > 0) { %>
                <h3>Espectaculos asociados</h3>
                <ul class="list-group">
                    <% for (Espectaculo espectaculo3 : espectaculos_paquetes) { %>
                        <li class="list-group-item">
                            <div class="hstack gap-3">
                                <img src="/ServidorWeb/imagen?nick=<%= espectaculo3.getId()%>" class="figure-img img-fluid rounded" width="30">
                                <span><%= espectaculo3.getNombre() %></span>
                                 <a href="/ServidorWeb/consulta_espectaculo?espectaculo=<%= espectaculo3.getId() %>&espectaculo=<%= espectaculo3.getId() %>">Consultar espectaculo</a>
                            </div>
                        </li>
                    <% } %>
                </ul>
            <% } %>
            <div>
                 <% if (all_paquetes.size() > 0) { %>
                <h3>Artistas invitados</h3>
                <ul class="list-group">
                    <% for (Paquete paquet : all_paquetes) { %>
                        <li class="list-group-item">
                            <div class="hstack gap-3">
                                <img src="/ServidorWeb/imagen?nick=<%= paquet.getId() %>" class="figure-img img-fluid rounded" width="30">
                                <span><%= paquet.getNombre()%></span>
                            </div>
                        </li>
                    <% } %>
                </ul>
            <% } %>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>
