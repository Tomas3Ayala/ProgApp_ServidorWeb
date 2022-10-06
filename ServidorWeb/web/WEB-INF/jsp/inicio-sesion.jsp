<%@page import="logica.clases.Espectador"%>
<%@page import="logica.clases.Artista"%>
<%@page import="logica.Fabrica"%>
<%@ include file="/WEB-INF/jsp/cabezal.jsp"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Inicio sesion</title>
    </head>
    <body>
        <%
            if (request.getMethod() == "POST") {
                String nickname = request.getParameter("nickname");
                if (Fabrica.getInstance().getInstanceControllerUsuario().existe_nickname_de_usuario(nickname)) {
                    Artista artista = Fabrica.getInstance().getInstanceControllerUsuario().obtener_artista_de_nickname(nickname);
                    if (artista == null) {
                        Espectador espectador = Fabrica.getInstance().getInstanceControllerUsuario().obtener_espectador_de_nickname(nickname);
                        session.setAttribute("tipo", "espectador");
                        session.setAttribute("usuario", (Usuario)espectador);
                    }
                    else {
                        session.setAttribute("tipo", "artista");
                        session.setAttribute("usuario", (Usuario)artista);
                    }
                }
            }
        %>

        <form method='post'>
            <input type='text' name='nickname' placeholder='Nickname del usuario o email'> <br>
            <input type='password' name='pass' placeholder='Contraseña'> <br>
            <input type="submit" value="Iniciar sesión">
        </form>
        <h1><%= request.getParameter("nickname") %></h1>
        <h1><%= request.getParameter("pass") %></h1>
    </body>
</html>
