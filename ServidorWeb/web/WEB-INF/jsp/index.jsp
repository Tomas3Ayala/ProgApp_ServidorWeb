
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.function.Predicate"%>
<%@page import="logica.clases.Paquete"%>
<%@page import="logica.clases.Espectaculo"%>
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
        <%
            String buscar = request.getParameter("buscar");
            String plataforma = request.getParameter("plataforma");
            String categoria = request.getParameter("categoria");
            String pagina = request.getParameter("pagina");
            if (pagina == null)
                pagina = "1";
            int numero_pagina = -1;
            try {
                numero_pagina = Integer.parseInt(pagina);
            } catch (NumberFormatException ex) {
                numero_pagina = 1;
            }
            ArrayList<Espectaculo> espectaculos = Fabrica.getInstance().getInstanceControladorEspectaculo().get_espectaculos_aceptados();
            ArrayList<Paquete> paquetes = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_paquetes();

            ArrayList<Espectaculo> espectaculos_rem = new ArrayList<Espectaculo>();
            ArrayList<Paquete> paquetes_rem = new ArrayList<Paquete>();

            if (plataforma != null && !plataforma.isEmpty()) {
                espectaculos_rem.clear();
                for (Espectaculo espectaculo : espectaculos) {
                    if (!espectaculo.getPlataforma().equals(plataforma))
                        espectaculos_rem.add(espectaculo);
                }
                for (Espectaculo espectaculo : espectaculos_rem)
                    espectaculos.remove(espectaculo);
            }

            if (categoria != null && !categoria.isEmpty()) {
                espectaculos_rem.clear();
                for (Espectaculo espectaculo : espectaculos) {
                    ArrayList<String> categorias = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_categorias_espectaculo(espectaculo.getId());
                    if (!categorias.contains(categoria))
                        espectaculos_rem.add(espectaculo);
                }
                for (Espectaculo espectaculo : espectaculos_rem)
                    espectaculos.remove(espectaculo);
            }
            
            if (buscar != null) {
                espectaculos_rem.clear();
                for (Espectaculo espectaculo : espectaculos) {
                    if (!espectaculo.getNombre().contains(buscar) && !espectaculo.getDescripcion().contains(buscar) && !espectaculo.getFecha_registro().toString().contains(buscar))
                        espectaculos_rem.add(espectaculo);
                }
                for (Espectaculo espectaculo : espectaculos_rem)
                    espectaculos.remove(espectaculo);

                paquetes_rem.clear();
                for (Paquete paquete : paquetes) {
                    if (!paquete.getNombre().contains(buscar) && !paquete.getDescripcion().contains(buscar))
                        paquetes_rem.add(paquete);
                }
                for (Paquete paquete : paquetes_rem)
                    paquetes.remove(paquete);
            }
            
            espectaculos.sort(new Comparator<Espectaculo>() {
                @Override
                public int compare(Espectaculo o1, Espectaculo o2) {
                    long a = o2.getFecha_registro().getTime() - o1.getFecha_registro().getTime();
                    if (a < 0)
                        return -1;
                    else if (a > 0)
                        return 1;
                    else
                        return 0;
                }
            });
            paquetes.sort(new Comparator<Paquete>() {
                @Override
                public int compare(Paquete o1, Paquete o2) {
                    long a = o2.getFecha_inicio().getTime() - o1.getFecha_inicio().getTime();
                    if (a < 0)
                        return -1;
                    else if (a > 0)
                        return 1;
                    else
                        return 0;
                }
            });
            int elems_pagina = 12; // elementos por pagina
            int ultima_pagina = 1;
            if (espectaculos.size() > elems_pagina || paquetes.size() > elems_pagina) {
                ultima_pagina = (int)Math.ceil(Integer.max(espectaculos.size(), paquetes.size()) / (double)elems_pagina);
                numero_pagina--; // esto es para que la primera pagina sea 0
                int pagina_inicio = numero_pagina * elems_pagina;
                int pagina_fin = numero_pagina * elems_pagina + elems_pagina;
                if (pagina_inicio > espectaculos.size() - elems_pagina)
                    pagina_inicio = espectaculos.size() - elems_pagina;

                espectaculos_rem.clear();
                for (int i = 0; i < espectaculos.size(); i++) {
                    if (i < pagina_inicio || i > pagina_fin)
                        espectaculos_rem.add(espectaculos.get(i));
                }
                for (Espectaculo espectaculo : espectaculos_rem)
                    espectaculos.remove(espectaculo);

                pagina_inicio = numero_pagina * elems_pagina;
                if (pagina_inicio > paquetes.size() - elems_pagina)
                    pagina_inicio = paquetes.size() - elems_pagina;

                paquetes_rem.clear();
                for (int i = 0; i < paquetes.size(); i++) {
                    if (i < pagina_inicio || i > pagina_fin)
                        paquetes_rem.add(paquetes.get(i));
                }
                for (Paquete paquete : paquetes_rem)
                    paquetes.remove(paquete);
                numero_pagina++;
            }
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Corono Tickets Uy</title>
    </head>

    <body>
        <%@ include file="/WEB-INF/jsp/cabezal.jsp"%>

        <div class="container">
            <div class="mb-3 row">
                <ul class="list-group col">
                    <h3>Espectáculos</h3>
                    <% for (Espectaculo espectaculo : espectaculos) { %>
                        <li class="list-group-item">
                            <div class="hstack gap-3">
                                <img src="/ServidorWeb/imagen?espectaculo=<%= espectaculo.getId()%>" class="figure-img img-fluid rounded" width="130">
                                <span><b><%= espectaculo.getNombre() %></b><br><%= espectaculo.getDescripcion() %><br><a href="/ServidorWeb/consulta_espectaculo?espectaculo=<%= espectaculo.getId() %>">Leer más...</a></span>
                            </div>
                        </li>
                    <% } %>
                </ul>
                <ul class="list-group col">
                    <h3>Paquetes</h3>
                    <% for (Paquete paquete : paquetes) { %>
                        <% System.out.println("hola! " + paquete.getId()); %>
                        <li class="list-group-item">
                            <div class="hstack gap-3">
                                <img src="/ServidorWeb/imagen?paquete=<%= paquete.getId() %>" class="figure-img img-fluid rounded" width="130">
                                <span><b><%= paquete.getNombre() %></b><br><%= paquete.getDescripcion() %><br><a href="/ServidorWeb/consulta_paquete?paquete=<%= paquete.getId() %>">Leer más...</a></span>
                            </div>
                        </li>
                    <% } %>
                </ul>
            </div>
            <% if (ultima_pagina != 1) { %>
                <center><h4>
                    <% if (numero_pagina - 1 >= 1) { %>
                        <button onclick="ir_a_pagina(<%= numero_pagina - 1 %>);"><-</button>
                    <% } %>
                    <%= pagina %>
                    <% if (numero_pagina + 1 <= ultima_pagina) { %>
                        <button onclick="ir_a_pagina(<%= numero_pagina + 1 %>);">-></button>
                    <% } %>
                </h4></center>
            <% } %>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>

