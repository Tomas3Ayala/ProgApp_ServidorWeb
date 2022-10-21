<%@page import="logica.clases.Espectador"%>
<%@page import="logica.clases.Artista"%>
<%@page import="logica.Fabrica"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            String auto_fill_nickname = "";
            String nick_error = "Este campo es obligatorio";
            String pass_error = "Este campo es obligatorio";
            if (request.getMethod() == "POST") {
                String nickname = request.getParameter("nickname");
                String pass = request.getParameter("pass");
                boolean existe_usuario = false;
                if (Fabrica.getInstance().getInstanceControllerUsuario().existe_nickname_de_usuario(nickname)) {
                    existe_usuario = true;
                }
                else if (Fabrica.getInstance().getInstanceControllerUsuario().existe_correo_de_usuario(nickname)) {
                    existe_usuario = true;
                    nickname = Fabrica.getInstance().getInstanceControllerUsuario().obtener_nickname_de_correo(nickname);
                }
                else {
                    nick_error = "Nickname o correo no encontrado";
                }
                if (existe_usuario) {
                    Artista artista = Fabrica.getInstance().getInstanceControllerUsuario().obtener_artista_de_nickname(nickname);
                    if (artista == null) {
                        Espectador espectador = Fabrica.getInstance().getInstanceControllerUsuario().obtener_espectador_de_nickname(nickname);
                        if (espectador.getContrasenia().equals(pass)) {
                            session.setAttribute("tipo", "espectador");
                            session.setAttribute("usuario", (Usuario)espectador);
                            %><meta http-equiv="Refresh" content="0; url='/ServidorWeb'" /><%
                        }
                        else {
                            auto_fill_nickname = request.getParameter("nickname");
                            pass_error = "Contraseña incorrecta";
                        }
                    }
                    else {
                        if (artista.getContrasenia().equals(pass)) {
                            session.setAttribute("tipo", "artista");
                            session.setAttribute("usuario", (Usuario)artista);
                            %><meta http-equiv="Refresh" content="0; url='/ServidorWeb'" /><%
                        }
                        else {
                            auto_fill_nickname = request.getParameter("nickname");
                            pass_error = "Contraseña incorrecta";
                        }
                    }
                }
            }
            else if (session.getAttribute("tipo") != null)
                %><meta http-equiv="Refresh" content="0; url='/ServidorWeb'" /><%
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Inicio sesion</title>
    </head>
    <body>
        <%@ include file="/WEB-INF/jsp/cabezal.jsp"%>
        <div class="container">
            <form class="was-validated" method='post' novalidate>
                <div class="mb-3">
                    <label class="form-label">Correo electrónico o nickname</label>
                    <input class="form-control" name='nickname' type='text' value="<%= auto_fill_nickname %>" required>
                    <div class="invalid-feedback"><%= nick_error %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Contraseña</label>
                    <input class="form-control" name='pass' type='password' required>
                    <div class="invalid-feedback"><%= pass_error %></div>
                </div>
                <button type="submit" class="btn btn-primary">Iniciar sesión</button>
            </form>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>
