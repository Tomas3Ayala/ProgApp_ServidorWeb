
<%@page import="org.springframework.context.support.ClassPathXmlApplicationContext"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="Persistencia.ConexionDB"%>
<%@page import="java.util.ArrayList"%>
<%@page import="logica.Fabrica"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Corono Tickets Uy</title>
    </head>

    <body>
        <%@ include file="/WEB-INF/jsp/cabezal.jsp"%>
        <%! String hola = "hola"; %>
        <%
            
            ArrayList<String> nicknames = Fabrica.getInstance().getInstanceControllerUsuario().obtener_nicknames_de_usuarios();
            for (String nick : nicknames) {
            %>
                <p><%= nick %></p>
            <%
            }

        %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>

