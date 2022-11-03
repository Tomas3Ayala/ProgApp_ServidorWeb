<%-- 
    Document   : consulta_funcion
    Created on : 22-oct-2022, 17:50:09
    Author     : Tomas
--%>

<%@page import="logica.clases.Paquete"%>
<%@page import="logica.clases.Registro_funcion"%>
<%@page import="logica.clases.Espectador"%>
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
        ArrayList<Espectaculo> espectaculos = new ArrayList<Espectaculo>();
        ArrayList<Registro_funcion> registros_a_funciones = new ArrayList<Registro_funcion>();
        ArrayList<Paquete> paquetes = new ArrayList<Paquete>();
        
        String nickname = request.getParameter("usuario");
        String tipo = "artista";
        Usuario usuario = null;
        Artista artista = Fabrica.getInstance().getInstanceControllerUsuario().obtener_artista_de_nickname(nickname);
        if (artista == null) {
            Espectador espectador = Fabrica.getInstance().getInstanceControllerUsuario().obtener_espectador_de_nickname(nickname);
            usuario = espectador;
            tipo = "espectador";
            // cosas de espectador
            registros_a_funciones = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_todos_los_registros_de_espectador(usuario.getId());
            if (session.getAttribute("tipo") != null && session.getAttribute("tipo").equals("espectador") && usuario.getId() == ((Usuario)session.getAttribute("usuario")).getId())
                paquetes = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_paquetes_comprados_por_espectador(nickname);
        }
        else
        {
            usuario = artista;
            // cosas de artista
            espectaculos = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_espectaculos_de_artista(nickname);
            if (session.getAttribute("tipo") == null || !session.getAttribute("tipo").equals("artista") || usuario.getId() != ((Usuario)session.getAttribute("usuario")).getId())
            {
                ArrayList<Espectaculo> espectaculos_rem = new ArrayList<Espectaculo>();
                for (Espectaculo espectaculo : espectaculos) {
                    if (espectaculo.getEstado() != EstadoEspectaculo.ACEPTADO)
                        espectaculos_rem.add(espectaculo);
                }
                for (Espectaculo espectaculo : espectaculos_rem)
                    espectaculos.remove(espectaculo);
            }
        }
        String log_nickname = null;
        if (session.getAttribute("usuario") != null)
            log_nickname = ((Usuario)session.getAttribute("usuario")).getNickname();
        
        ArrayList<String> seguidores = Fabrica.getInstance().getInstanceControllerUsuario().obtener_nicknames_de_usuarios_que_siguen_a(nickname);
        ArrayList<String> seguidos = Fabrica.getInstance().getInstanceControllerUsuario().obtener_nicknames_de_usuarios_a_los_que_sigue(nickname);
        boolean coma = false;
        String seguidores_text = "";
        for (String seguidor : seguidores) {
            if (coma)
                seguidores_text += ", ";
            else
                coma = true;
            seguidores_text += "<a href='/ServidorWeb/consulta_usuario?usuario=" + seguidor + "'>" + seguidor + "</a>";
        }
        String seguidos_text = "";
        coma = false;
        for (String seguido : seguidos) {
            if (coma)
                seguidos_text += ", ";
            else
                coma = true;
            seguidos_text += "<a href='/ServidorWeb/consulta_usuario?usuario=" + seguido + "'>" + seguido + "</a>";
        }
%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Usuario</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript">
            $(document).ready(() => {
                $('#seguir').click(() => {
//                    console.log($('#seguir').text());
//                    return;
                    if ($('#seguir').text() === "No seguir") {
                        console.log("carajo");
                        $.ajax({
                            url: "/ServidorWeb/seguir_a_usuario",
                            type: "GET",
                            data: {"seguir" : "no", "nick1" : "<%= log_nickname %>", "nick2" : "<%= nickname %>" },
                            success: function(data)
                            {
                                location.reload();
                            }
                        });
                        $('#seguir').text("Seguir");
                    }
                    else {
                        console.log("que mierda");
                        $.ajax({
                            url: "/ServidorWeb/seguir_a_usuario",
                            type: "GET",
                            data: {"seguir" : "si", "nick1" : "<%= log_nickname %>", "nick2" : "<%= nickname %>" },
                            success: function(data)
                            {
                                location.reload();
                            }
                        });
                        $('#seguir').text("No seguir");
                    }
                });
            });
        </script>
    </head>
    <body>
        <%@ include file="/WEB-INF/jsp/cabezal.jsp"%>
        <div class="container">
            <center><h1><%= tipo.equals("artista") ? "Artista":"Espectador" %> <%= usuario.getNickname() %></h1></center>
            <div class="modal-body row">
                <div class="hstack gap-3">
                    <figure class="figure">
                        <img src="/ServidorWeb/imagen?nick=<%= usuario.getNickname() %>" class="figure-img img-fluid rounded" width="300">
                        <figcaption class="figure-caption"></figcaption>
                    </figure>
                    <div>
                        <p>Nickname: <%= usuario.getNickname() %></p>
                        <p>Nombre: <%= usuario.getNombre() %></p>
                        <p>Apellido: <%= usuario.getApellido() %></p>
                        <p>Correo: <%= usuario.getCorreo() %></p>
                        <p>Fecha de nacimiento: <%= usuario.getNacimiento() %></p>

                        <% if (!seguidores.isEmpty()) { %>
                            <p>Seguidores: <%= seguidores_text %></p>
                        <% } %>
                        <% if (!seguidos.isEmpty()) { %>
                            <p>A los que sigue: <%= seguidos_text %></p>
                        <% } %>
                        <% if (session.getAttribute("tipo") != null && !log_nickname.equals(nickname)) { %>
                            <button class="btn btn-primary" id="seguir"><%= Fabrica.getInstance().getInstanceControllerUsuario().esta_siguiendo_a(log_nickname, nickname) ? "No seguir":"Seguir" %></button>
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="row">
                <% if (tipo == "artista") { %>
                    <div class="col">
                            <h3>
                            <% if (espectaculos.size() == 0) { %>
                            No registró ningún espectaculo
                            <% } else { %>
                            Espectaculos de los que es organizador
                            <% } %>
                            </h3>

                            <ul class="list-group">
                                <% for (Espectaculo espectaculo : espectaculos) { %>
                                    <a href="/ServidorWeb/consulta_espectaculo?espectaculo=<%= espectaculo.getId() %>">
                                        <li class="list-group-item">
                                            <div class="hstack gap-3">
                                                <img src="/ServidorWeb/imagen?espectaculo=<%= espectaculo.getId()%>" class="figure-img img-fluid rounded" width="30">
                                                <span><%= espectaculo.getNombre() %><br>Estado: <%= espectaculo.getEstado() %></span>
                                            </div>
                                        </li>
                                    </a>
                                <% } %>
                            </ul>
                    </div>
                <% } %>
                <% if (tipo == "espectador") { %>
                    <div class="col">
                        <h3>
                        <% if (registros_a_funciones.size() == 0) { %>
                        No se registró a ninguna función
                        <% } else { %>
                        Funciones a las que se registró
                        <% } %>
                        </h3>

                        <ul class="list-group">
                            <% for (Registro_funcion registro : registros_a_funciones) {
                                Funcion funcion = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_funcion_por_id(registro.getId_funcion());
                            %>
                                <a href="/ServidorWeb/consulta_funcion?funcion=<%= registro.getId_funcion() %>">
                                    <li class="list-group-item">
                                    <div class="hstack gap-3">
                                        <img src="/ServidorWeb/imagen?funcion=<%= funcion.getId() %>" class="figure-img img-fluid rounded" width="30">
                                        <span><%= funcion.getNombre() %></span>
                                    </div>
                                    </li>
                                </a>
                            <% } %>
                        </ul>
                    </div>
                <% } %>
                <% if (tipo == "espectador" && session.getAttribute("tipo") != null && ((Usuario)session.getAttribute("usuario")).getNickname().equals(nickname)) { %>
                    <div class="col">
                        <h3>
                        <% if (paquetes.size() == 0) { %>
                        No ha comprado ningún paquete
                        <% } else { %>
                        Paquetes comprados
                        <% } %>
                        </h3>

                        <ul class="list-group">
                            <% for (Paquete paquete : paquetes) { %>
                                <a href="/ServidorWeb/consulta_paquete?paquete=<%= paquete.getId() %>">
                                    <li class="list-group-item">
                                        <div class="hstack gap-3">
                                            <img src="/ServidorWeb/imagen?paquete=<%= paquete.getId() %>" class="figure-img img-fluid rounded" width="30">
                                            <span><%= paquete.getNombre() %></span>
                                        </div>
                                    </li>
                                </a>
                            <% } %>
                        </ul>
                    </div>
                <% } %>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>