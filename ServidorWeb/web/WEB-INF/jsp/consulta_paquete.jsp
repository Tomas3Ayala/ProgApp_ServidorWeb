<%-- 
    Document   : consulta_paquete
    Created on : 24/10/2022, 11:46:04 PM
    Author     : 59892
--%>

<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="logica.clases.Paquete"%>
<%@page import="logica.enums.EstadoEspectaculo"%>
<%@page import="logica.clases.Espectaculo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="logica.clases.Artista"%>
<%@page import="logica.clases.Espectador"%>
<%@page import="logica.clases.Funcion"%>
<%@page import="logica.Fabrica"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
     <%
        int id_paqu = Integer.parseInt(request.getParameter("paquete"));
        Paquete paquete = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_info_paquetes(id_paqu);
        ArrayList<Espectaculo> espectaculos = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_espectaculos_aceptados_de_paquete(id_paqu);
        ArrayList<Paquete> paquetes = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_paquetes();
   
        
        String categorias_str = "";
        Set<String> categorias_a_mostrar = new HashSet<String>();
        for (Espectaculo espectaculo : espectaculos) {
            ArrayList<String> categorias = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_categorias_espectaculo(espectaculo.getId());
            for (String categoria : categorias)
                categorias_a_mostrar.add(categoria);
        }
        boolean coma = false;
        for (String categoria : categorias_a_mostrar) {
            if (coma)
                categorias_str += ", ";
            else
                coma = true;
            categorias_str += categoria;
        }
        if (!categorias_str.isEmpty())
            categorias_str = "Categorias: " + categorias_str;

        ArrayList<Espectaculo> espectaculos_no_en_paquete = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_espectaculos_aceptados_no_de_paquete(id_paqu);
     %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Info de Paquetes</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript">

            function cambio_plata(e) {
                console.log(e.val());
                <% for (Espectaculo espectaculo : espectaculos_no_en_paquete) { %>
                    if (e.val() === "<%= espectaculo.getPlataforma() %>")
                        $('#espectaculo-<%= espectaculo.getId() %>').show();
                    else
                        $('#espectaculo-<%= espectaculo.getId() %>').hide();
                <% } %>
            }
            function agregar_a_paquete(espectaculo) {
                $.ajax({
                    url: "/ServidorWeb/agregar_a_paquete",
                    type: "GET",
                    data: {"paquete" : <%= id_paqu %>, "espectaculo" : espectaculo },
                    success: function(data)
                    {
                        location.reload();
                    }
                });
                $.ajax({
                    url: "/ServidorWeb/agregar_a_paquete",
                    type: "GET",
                    data: {"paquete" : <%= id_paqu %>, "espectaculo" : espectaculo },
                    success: function(data)
                    {
                        location.reload();
                    }
                });
            }
             function comprar_paquete() {
                $.ajax({
                    url: "/ServidorWeb/comprar_paquete",
                    type: "GET",
                    data: {"paquete" : <%= id_paqu %> },
                    success: function(data)
                    {
                        location.reload();
                    }
                });
                $.ajax({
                    url: "/ServidorWeb/comprar_paquete",
                    type: "GET",
                    data: {"paquete" : <%= id_paqu %> },
                    success: function(data)
                    {
                        location.reload();
                    }
                });           
            }
        </script>
    </head>
    <body>
        <%@ include file="/WEB-INF/jsp/cabezal.jsp"%>
        <div class="container">
           <% if (session.getAttribute("tipo") != null && session.getAttribute("tipo").equals("espectador")) { %> 
            <center><h1>Paquete <%= paquete.getNombre()%></h1>  <% if (Fabrica.getInstance().getInstanceControllerUsuario().paquete_comprado(((Usuario) session.getAttribute("usuario")).getId(), paquete.getId())) { %>
                <div style="align-content:center">
                    <h2 style="align-content:center; color: brown ">Adquirido</h2>       
                </div>
                <% }%></center>
            <% }%>
            <div class="modal-body row">
                <div class="hstack gap-3">
                    <figure class="figure">
                        <img src="/ServidorWeb/imagen?paquete=<%= paquete.getNombre() %>" class="figure-img img-fluid rounded" width="300">
                        <figcaption class="figure-caption"></figcaption>
                    </figure>
                    <div>
                        <p>Nombre: <%= paquete.getNombre() %></p>
                        <p>Descripcion: <%= paquete.getDescripcion() %></p>
                        <p>Fecha de inicio: <%= paquete.getFecha_inicio() %></p>
                        <p>Fecha de fin: <%= paquete.getFecha_fin() %></p>
                        <p>Descuento: <%= paquete.getDescuento() %></p>

                        <span> <%= categorias_str %> </span>
                    </div>
                </div>
            </div>
            <h3>
                <% if (espectaculos.size() > 0) { %>
                Espectaculos asociados
                <% } else { %>
                El paquete no tiene espectáculos asociados
                <% } %>
            </h3>
            <ul class="list-group">
                <% for (Espectaculo espectaculo3 : espectaculos) { %>
                    <li class="list-group-item">
                        <div class="hstack gap-3">
                            <img src="/ServidorWeb/imagen?espectaculo=<%= espectaculo3.getId()%>" class="figure-img img-fluid rounded" width="30">
                            <span><%= espectaculo3.getNombre() %></span>
                            <a href="/ServidorWeb/consulta_espectaculo?espectaculo=<%= espectaculo3.getId() %>">Consultar espectaculo</a>
                        </div>
                    </li>
                <% } %>
            </ul>
            <br>
            <br>
            <% if (session.getAttribute("tipo") != null && session.getAttribute("tipo").equals("espectador")) { %>
                <% if (!Fabrica.getInstance().getInstanceControllerUsuario().paquete_comprado(((Usuario) session.getAttribute("usuario")).getId(), paquete.getId())) {%>
                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <button class="btn btn-primary" data-bs-toggle="collapse" onclick="comprar_paquete(<%= paquete.getId()%>)">Comprar paquete</button>       
                </div>
                <% } %>  
            <% } %> 
            <% if (session.getAttribute("tipo") != null && session.getAttribute("tipo").equals("artista")) { %>
                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <button type="button" class="btn btn-primary" data-bs-toggle="collapse" data-bs-target="#areaAgregarEspectaculo" aria-expanded="false" aria-controls="areaAgregarEspectaculo">
                        Agregar espectáculo
                    </button>
                </div>
                <br>
                <div class="collapse" id="areaAgregarEspectaculo">
                    <div class="card card-body">
                        <h3>Seleccione espectáculo a agregar</h3>
                        <div class="nav-item dropdown">
                            <label class="form-label">Filtrar por plataforma: </label>
                            <select class="form-select" name="plataforma" id="plataforma" onchange="cambio_plata($(this))" required>
                                <option value="">Plataforma</option>
                                <% for (String ___plat : Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_plataformas_disponibles()) { %>
                                    <option><%= ___plat %></option>
                                <% } %>
                            </select>
                        </div>
                        <br>
                        <% for (Espectaculo espectaculo : espectaculos_no_en_paquete) { %>
                            <li class="list-group-item" id="espectaculo-<%= espectaculo.getId() %>">
                                <div class="hstack gap-3">
                                    <img src="/ServidorWeb/imagen?espectaculo=<%= espectaculo.getId() %>" class="figure-img img-fluid rounded" width="130">
                                    <span><b><%= espectaculo.getNombre() %></b><br><%= espectaculo.getDescripcion() %><br><button class="btn btn-primary" onclick="agregar_a_paquete(<%= espectaculo.getId() %>)">Agregar</button></span>
                                </div>
                            </li>
                        <% } %>
                    </div>
                </div>
            <% } %>   
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>

