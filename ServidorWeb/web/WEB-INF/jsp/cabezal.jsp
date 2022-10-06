<%@page import="logica.clases.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" type="text/css" href="style.css" />

    </head>
    <body>

        <header>
            <div id='cabezal'>
                <h1>CoronaTickets.uy</h1>
                <form>
                    <input type='text' placeholder='Buscar espectaculos/paquetes...'>
                    <button  id='search'>Buscar</button>
                </form>

                <% if (session.getAttribute("tipo") == null) { %>
                    <a href='/ServidorWeb/inicio-sesion'>Iniciar sesion</a>
                <% } else {%>
                    <p>Nickname del usuario: <%= ((Usuario)session.getAttribute("usuario")).getNickname() %></p>
                <% } %>

                <p>Registrar usuario</p>
            </div>
        </header>

    </body>
</html>
