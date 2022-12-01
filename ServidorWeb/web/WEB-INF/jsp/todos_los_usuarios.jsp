<%-- 
    Document   : consulta_funcion
    Created on : 22-oct-2022, 17:50:09
    Author     : Tomas
--%>
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
        ArrayList<Usuario> usuarios = Converter.to_Usuario_list(GsonToUse.gson.fromJson(Sender.post("/users/obtener_usuarios", new Object[] {}), ArrayList.class));
        String pagina = request.getParameter("pagina");
        if (pagina == null)
            pagina = "1";

        int numero_pagina = -1;
        try {
            numero_pagina = Integer.parseInt(pagina);
        } catch (NumberFormatException ex) {
            numero_pagina = 1;
        }
        int elems_pagina = 12; // elementos por pagina
        int ultima_pagina = 1;
        if (usuarios.size() > elems_pagina) {
            ultima_pagina = (int)Math.ceil(usuarios.size() / (double)elems_pagina);
            numero_pagina--; // esto es para que la primera pagina sea 0
            int pagina_inicio = numero_pagina * elems_pagina;
            int pagina_fin = numero_pagina * elems_pagina + elems_pagina;
            if (pagina_inicio > usuarios.size() - elems_pagina)
                pagina_inicio = usuarios.size() - elems_pagina;

            ArrayList<Usuario> usuarios_rem = new ArrayList<>();
            usuarios_rem.clear();
            for (int i = 0; i < usuarios.size(); i++) {
                if (i < pagina_inicio || i > pagina_fin)
                    usuarios_rem.add(usuarios.get(i));
            }
            for (Usuario usuario : usuarios_rem)
                usuarios.remove(usuario);
            numero_pagina++;
        }
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Usuarios</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript">
            //
        </script>
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
                <% for (Usuario usuario : usuarios) { 
                
                 %>
                    <a href="/ServidorWeb/consulta_usuario?usuario=<%= usuario.getNickname() %>">
                        <li class="list-group-item">
                            <div class="hstack gap-3">
                                <img src="/ServidorWeb/imagen?nick=<%= usuario.getNickname() %>" class="figure-img img-fluid rounded" width="130">
                                <span><%= usuario.getNickname() %></span>
                                <span><%= usuario.getNombre()%></span>
                                <span><%= usuario.getApellido()%></span>
                                <span><%= usuario.getCorreo()%></span> 
                                <span><%= Converter.formatear_date(usuario.getNacimiento()) %></span>
                            </div>
                        </li>
                    </a>
                <% } %>
            </ul>
            <% if (ultima_pagina != 1) { %>
                <center><h4>
                    <% if (numero_pagina - 1 >= 1) { %>
                        <a href="?pagina=<%= numero_pagina - 1 %>"><button><-</button></a>
                    <% } %>
                    <%= numero_pagina %>
                    <% if (numero_pagina + 1 <= ultima_pagina) { %>
                        <a href="?pagina=<%= numero_pagina + 1 %>"><button>-></button></a>
                    <% } %>
                </h4></center>
            <% } %>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>
