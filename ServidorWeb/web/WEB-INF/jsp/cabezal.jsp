<%@page import="Utility.GsonToUse"%>
<%@page import="java.util.ArrayList"%>
<%@page import="logica.clases.Categoria"%>
<%@page import="logica.clases.Usuario"%>
<%@page import="Utility.Converter"%>
<%@page import="Utility.Sender"%>
<%@page import="com.google.gson.Gson"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" type="text/css" href="style.css" />
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
        <script>
            var n_busqueda_pagina = null;
            function ir_a_pagina(n) {
                n_busqueda_pagina = n;
                $('#form-search').trigger('submit');
            }
            $( document ).ready(function() {
                $("#form-search").on("formdata", function(e) {
                    const formData = e.originalEvent.formData; 
//                    const formData = $('#form-search').formData;
                    formData.set("categoria", $('#categoria').val());
                    formData.set("plataforma", $('#plataforma').val());
                    formData.set("pagina", <%= request.getParameter("pagina") != null ? request.getParameter("pagina"):"1" %>);
                    if (n_busqueda_pagina !== null)
                        formData.set("pagina", n_busqueda_pagina);
                    formData.set("orden", orden_final);
    
//                    e.preventDefault();
//                    window.location.assign("/ServidorWeb/index.htm");
                });
                
                $("#categoria").val("<%= request.getParameter("categoria") != null ? request.getParameter("categoria"):"" %>");
                $("#plataforma").val("<%= request.getParameter("plataforma") != null ? request.getParameter("plataforma"):"" %>");
            });
            
            function cerrar_sesion() {
                $.ajax({
                    url: "/ServidorWeb/cerrar_sesion",
                    type: "GET",
                    success: function(data)
                    {
                        location.reload();
                    }
                });
                $.ajax({
                    url: "/ServidorWeb/cerrar_sesion",
                    type: "GET",
                    success: function(data)
                    {
                        location.reload();
                    }
                });
            }
        </script>
    </head>
    <body>

        <header>
            <nav class="navbar bg-light">
                <div class="container-fluid">
                    <a class="navbar-brand" href='/ServidorWeb' id='cabezal-coronaticketsuy'>CoronaTickets.uy</a>
                    <div class="hstack gap-3">
                        <form class="d-flex" role="search" id="form-search" action="/ServidorWeb/index.htm" method="GET">
                            <input class="form-control me-2" type="search" placeholder="Buscar espect??culos/paquetes..." name="buscar" value="<%= request.getParameter("buscar") != null ? request.getParameter("buscar"):"" %>" aria-label="Search">
                            <button class="btn btn-outline-success" type="submit">Buscar</button>
                        </form>
                        <div class="nav-item dropdown">
                            <!--<label class="form-label">Categor??a</label>-->
                            <select class="form-select" name="categoria" id="categoria" required>
                                <option value="">Categor??a</option>
                                <% for (Object ___cat : Converter.to_Categoria_list(GsonToUse.gson.fromJson(Sender.post("/plataformas/obtener_categorias", new Object[] {} ), ArrayList.class))) { %>
                                    <option><%= ((Categoria) ___cat).getNombre() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="nav-item dropdown">
                            <!--<label class="form-label">Categor??a</label>-->
                            <select class="form-select" name="plataforma" id="plataforma" required>
                                <option value="">Plataforma</option>
                                <% for (Object ___plat : (GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_plataformas_disponibles", new Object[] {} ), ArrayList.class))) { %>
                                    <option><%= (String) ___plat %></option>
                                <% } %>
                            </select>
                        </div>
                        <div>
                            <a class="dropdown-item" href="/ServidorWeb/todos_los_usuarios"><button class="btn btn-primary">Ver usuarios</button></a>
                        </div>
                    </div>
                    <% if (session.getAttribute("tipo") == null) { %>
                        <span class="text-end">
                            <a href="/ServidorWeb/inicio-sesion">Iniciar sesi??n</a>
                            <br>
                            <a href="/ServidorWeb/registrar_usuario">Registrarse</a>
                        </span>
                    <% } else {%>
                        <div class="hstack gap-3">
                            <div class="bg-light"><%= ((Usuario)session.getAttribute("usuario")).getNickname() %></div>
                            <div class="bg-light ms-auto">
                                <div class="nav-item dropdown">
                                    <img type="button" data-bs-toggle="dropdown" src="/ServidorWeb/imagen?nick=<%= ((Usuario)session.getAttribute("usuario")).getNickname() %>" class="dropdown-toggle img-fluid rounded-circle" width="45"/>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><a class="dropdown-item" href="/ServidorWeb/consulta_usuario?usuario=<%= ((Usuario)session.getAttribute("usuario")).getNickname() %>">Ver perfil</a></li>

                                        <% if (session.getAttribute("tipo") != null && session.getAttribute("tipo").equals("artista")) { %>
                                            <li><a class="dropdown-item" href="/ServidorWeb/crear_paquete">Alta paquete</a></li>
                                            <li><a class="dropdown-item" href="/ServidorWeb/alta_espectaculo">Alta espect??culo</a></li>
                                            <li><a class="dropdown-item" href="/ServidorWeb/alta_funcion">Alta funci??n</a></li>
                                        <% } %>
                                        <li><a class="dropdown-item" href="/ServidorWeb/editar_usuario">Editar perfil</a></li>
                                        <li onclick="cerrar_sesion()"><a class="dropdown-item" href="#">Cerrar sesi??n</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </nav>
        </header>

    </body>
</html>
