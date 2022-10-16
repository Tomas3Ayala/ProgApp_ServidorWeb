<%@page import="logica.clases.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" type="text/css" href="style.css" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    </head>
    <body>
        <%
            if (request.getMethod() == "GET" && request.getParameter("cerrarsesion") != null) {
                session.setAttribute("tipo", null);
            }
        %>

        <header>
            <nav class="navbar bg-light">
                <div class="container-fluid">
                    <a class="navbar-brand" href='/ServidorWeb' id='cabezal-coronaticketsuy'>CoronaTickets.uy</a>
                    <form class="d-flex" role="search">
                        <input class="form-control me-2" type="search" placeholder="Buscar espectaculos/paquetes..." aria-label="Search">
                        <button class="btn btn-outline-success" type="submit">Buscar</button>
                    </form>
                    <% if (session.getAttribute("tipo") == null) { %>
                        <span class="text-end">
                            <a href="/ServidorWeb/inicio-sesion">Iniciar sesión</a>
                            <br>
                            <a href="/ServidorWeb/registrar_usuario">Registrarse</a>
                        </span>
                    <% } else {%>
                        <div class="hstack gap-3">
                            <div class="bg-light"><%= ((Usuario)session.getAttribute("usuario")).getNickname() %></div>
                            <div class="bg-light ms-auto">
                                <div class="dropdown">
                                    <img type="button" data-bs-toggle="dropdown" src="/ServidorWeb/imagen?nick=<%= ((Usuario)session.getAttribute("usuario")).getNickname() %>" class="dropdown-toggle img-fluid rounded-circle" width="45"/>
                                    <ul class="dropdown-menu pull-right">
                                        <li><a class="dropdown-item" href="/ServidorWeb/editar_usuario">Editar perfil</a></li>
                                        <li><a class="dropdown-item" href="?cerrarsesion">Cerrar sesión</a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="vr"></div>
                            <div class="bg-light"><a href="/ServidorWeb/registrar_usuario">Registrarse</a></div>
                        </div>
                    <% } %>
                </div>
            </nav>
        </header>

    </body>
</html>
