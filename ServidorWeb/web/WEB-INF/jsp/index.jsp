<%@page import="Utility.GsonToUse"%>
<%@page import="Utility.Converter"%>
<%@page import="Utility.Sender"%>
<%@page import="com.google.gson.Gson"%>
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
<%@page import="java.util.ArrayList"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <%  
            String mensaje = (String)session.getAttribute("mensaje");
            
            //mensaje = "USUARIO AGREGADO CON EXITO";
            String buscar = request.getParameter("buscar");
            String plataforma = request.getParameter("plataforma");
            String categoria = request.getParameter("categoria");
            String pagina = request.getParameter("pagina");
            String nickname = request.getParameter("usuario");
            if (pagina == null)
                pagina = "1";
            int numero_pagina = -1;
            try {
                numero_pagina = Integer.parseInt(pagina);
            } catch (NumberFormatException ex) {
                numero_pagina = 1;
            }
            ArrayList<Espectaculo> espectaculos = Converter.to_Espectaculo_list(GsonToUse.gson.fromJson(Sender.post("/espectaculos/get_espectaculos_aceptados", new Object[] {} ), ArrayList.class));
            ArrayList<Paquete> paquetes = Converter.to_Paquete_list(GsonToUse.gson.fromJson(Sender.post("/plataformas/obtener_paquetes", new Object[] {} ), ArrayList.class));

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
                    ArrayList<String> categorias = (GsonToUse.gson.fromJson(Sender.post("/plataformas/obtener_categorias_espectaculo", new Object[] {espectaculo.getId()} ), ArrayList.class));
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

            int antes_de_separar_por_pagina1 = espectaculos.size();
            int antes_de_separar_por_pagina2 = paquetes.size();
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

            ArrayList<Espectaculo> otro_orden_espectaculos = (ArrayList<Espectaculo>)espectaculos.clone();
            ArrayList<Paquete> otro_orden_paquetes = (ArrayList<Paquete>)paquetes.clone();
            otro_orden_espectaculos.sort(new Comparator<Espectaculo>() {
                @Override
                public int compare(Espectaculo o1, Espectaculo o2) {
                    return o2.getNombre().toLowerCase().compareTo(o1.getNombre().toLowerCase()) > 0 ? -1:1;
                }
            });
            otro_orden_paquetes.sort(new Comparator<Paquete>() {
                @Override
                public int compare(Paquete o1, Paquete o2) {
                    return o2.getNombre().toLowerCase().compareTo(o1.getNombre().toLowerCase()) > 0 ? -1:1;
                }
            });
            String orden_final = "1";
            if (request.getParameter("orden") != null)
                orden_final = request.getParameter("orden");
//            System.out.println(orden_final);
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Corono Tickets Uy</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script>
            var orden_final = null;
            function cambio_orden(v) {
                if (v === null)
                    v = $('#orden').val();
                if ($('#orden').val() === "1") {
                    $('#espectaculos_anio').show();
                    $('#espectaculos_nanio').hide();
                    $('#paquetes_anio').show();
                    $('#paquetes_nanio').hide();
                }
                else {
                    $('#espectaculos_anio').hide();
                    $('#espectaculos_nanio').show();
                    $('#paquetes_anio').hide();
                    $('#paquetes_nanio').show();
                }
                orden_final = $('#orden').val();
            }
            $(document).ready(function () {
                cambio_orden(<%= orden_final %>);
                 if (<%= mensaje != null %>){ 
                $(".toast").toast("show");
                }
            })
        </script>
    </head>

    <body>
        <%@ include file="/WEB-INF/jsp/cabezal.jsp"%>
        <div class="toast align-items-center text-white  border-0" aria-live="assertive" aria-atomic="true"  style="position: relative; position: absolute; topcenter: 0;min-height: 70px; background-color: green">
            <div class="d-flex">
                <div class="toast-body">
                    <strong> <%= mensaje %> </strong>
                </div>
                <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast" aria-label="Close" ></button>
            </div>
        </div>
        <div class="container">
            <br>
            <div class="hstack gap-3">
                <span>Orden: </span>
                <select class="form-select" id="orden" onchange="cambio_orden();" required>
                    <option value="1" <%= orden_final.equals("1") ? "selected":"" %>>Año (descendente)</option>
                    <option value="2" <%= orden_final.equals("2") ? "selected":"" %>>Alfabeticamente</option>
                </select>
            </div>
            <div class="mb-3 row">
                <ul class="list-group col">
                    <h3>Espectáculos <%= antes_de_separar_por_pagina1 > 0 ? "(" + antes_de_separar_por_pagina1 + ")":"" %></h3>
                    <div id="espectaculos_anio">
                        <% for (Espectaculo espectaculo : espectaculos) { %>
                            <li class="list-group-item">
                                <div class="hstack gap-3">
                                    <img src="/ServidorWeb/imagen?espectaculo=<%= espectaculo.getId()%>" class="figure-img img-fluid rounded" width="130">
                                    <span><b><%= espectaculo.getNombre() %></b><br><%= espectaculo.getDescripcion() %><br><a href="/ServidorWeb/consulta_espectaculo?espectaculo=<%= espectaculo.getId() %>">Leer más...</a></span>
                                </div>
                            </li>
                        <% } %>
                    </div>
                    <div id="espectaculos_nanio" style="display : none;">
                        <% for (Espectaculo espectaculo : otro_orden_espectaculos) { %>
                            <li class="list-group-item">
                                <div class="hstack gap-3">
                                    <img src="/ServidorWeb/imagen?espectaculo=<%= espectaculo.getId()%>" class="figure-img img-fluid rounded" width="130">
                                    <span><b><%= espectaculo.getNombre() %></b><br><%= espectaculo.getDescripcion() %><br><a href="/ServidorWeb/consulta_espectaculo?espectaculo=<%= espectaculo.getId() %>">Leer más...</a></span>
                                </div>
                            </li>
                        <% } %>
                    </div>
                </ul>
                <ul class="list-group col">
                    <h3>Paquetes <%= antes_de_separar_por_pagina2 > 0 ? "(" + antes_de_separar_por_pagina2 + ")":"" %></h3>
                    <div id="paquetes_anio">
                        <% for (Paquete paquete : paquetes) { %>
                            <li class="list-group-item">
                                <div class="hstack gap-3">
                                    <img src="/ServidorWeb/imagen?paquete=<%= paquete.getNombre() %>" class="figure-img img-fluid rounded" width="130">
                                    <span><b><%= paquete.getNombre() %></b><br><%= paquete.getDescripcion() %><br><a href="/ServidorWeb/consulta_paquete?paquete=<%= paquete.getId() %>">Leer más...</a></span>
                                </div>
                            </li>
                        <% } %>
                    </div>
                    <div id="paquetes_nanio" style="display : none;">
                        <% for (Paquete paquete : otro_orden_paquetes) { %>
                            <li class="list-group-item">
                                <div class="hstack gap-3">
                                    <img src="/ServidorWeb/imagen?paquete=<%= paquete.getNombre() %>" class="figure-img img-fluid rounded" width="130">
                                    <span><b><%= paquete.getNombre() %></b><br><%= paquete.getDescripcion() %><br><a href="/ServidorWeb/consulta_paquete?paquete=<%= paquete.getId() %>">Leer más...</a></span>
                                </div>
                            </li>
                        <% } %>
                    </div>
                </ul>
            </div>
            <% if (ultima_pagina != 1) { %>
                <center><h4>
                    <% if (numero_pagina - 1 >= 1) { %>
                        <button onclick="ir_a_pagina(<%= numero_pagina - 1 %>);"><-</button>
                    <% } %>
                    <%= numero_pagina %>
                    <% if (numero_pagina + 1 <= ultima_pagina) { %>
                        <button onclick="ir_a_pagina(<%= numero_pagina + 1 %>);">-></button>
                    <% } %>
                </h4></center>
            <% } %>
        </div>
        <% session.setAttribute("mensaje", null); %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>

