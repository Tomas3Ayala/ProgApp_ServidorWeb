<%@page import="Utility.GsonToUse"%>
<%@page import="logica.clases.Paquete"%>
<%@page import="logica.clases.Registro_funcion"%>
<%@page import="logica.clases.Espectador"%>
<%@page import="java.util.Base64"%>
<%@page import="java.time.ZoneId"%>
<%@page import="logica.clases.Artista"%>
<%@page import="java.time.format.DateTimeParseException"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.Period"%>
<%@page import="java.time.LocalDate"%>
<%@page import="logica.Fabrica"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Utility.Converter"%>
<%@page import="Utility.Sender"%>
<%@page import="com.google.gson.Gson"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    <%
        int id_espec = Integer.parseInt(request.getParameter("espectaculo"));
        int id_func = Integer.parseInt(request.getParameter("funcion"));
        ArrayList<String> paquetes_asociados = (GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_nombres_de_paquetes_asociados_a_espectaculo", new Object[] {id_espec} ), ArrayList.class));
        ArrayList<Registro_funcion> registros = Converter.to_Registro_funcion_list(GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_registros_de_espectador", new Object[] {((Usuario) session.getAttribute("usuario")).getId()} ), ArrayList.class));
        int nregistros = 0;
        for (Registro_funcion registro : registros) {
            if (registro.getCosto() != 0)
                nregistros++;
        }
    %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registrarse</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript">
            var costo_original = <%= (GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_espectaculo", new Object[] {id_espec} ), Espectaculo.class)).getCosto() %>;
            const costos = {
                "":0,
                <% for (String nombre : paquetes_asociados) {
                    Paquete paquete = (GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_info_paquete", new Object[] {nombre} ), Paquete.class));
                %>
                    "<%= nombre %>":<%= paquete.getDescuento() %>,
                <% } %>
            };
            var costo = costo_original;
            var paquete = "";
            const registros_utilizados = [];
            var canjear = false;
            var tcanje = {
                <% for (Registro_funcion registro : registros) { %>
                    <% if (registro.getCosto() != 0) {%>
                        "<%= registro.getFecha_registro() %> - <%= (GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_funcion_por_id", new Object[] {registro.getId_funcion()} ), Funcion.class)).getNombre()  %>": <%= registro.getId_funcion() %>,
                    <% } %>
                <% } %>
            };
            
            function obtener_registro(s) {
                return tcanje[s];
            }

            $( document ).ready(function() {
                $('#canjear').hide();
                $("#paquete").change(() => {
                    costo = costo_original * (1 - costos[$("#paquete").val()] / 100);
                    $("#costo").text("Costo final: $" + costo);
                    paquete = $("#paquete").val();
                });

                $("#form").on("formdata", (e) => {
                    const formData = e.originalEvent.formData; 
                    formData.set("paquete", paquete);
                    if (canjear) {
                        formData.set("canje1", obtener_registro(registros_utilizados[0]));
                        formData.set("canje2", obtener_registro(registros_utilizados[1]));
                        formData.set("canje3", obtener_registro(registros_utilizados[2]));
                    }
                    else {
                        formData.set("canje1", -1);
                        formData.set("canje2", -1);
                        formData.set("canje3", -1);
                    }
                });
                
                $('.list-group-item').click(function() {
                    if ($(this).hasClass('active')) {
                        $(this).removeClass('active');
                        registros_utilizados.splice(registros_utilizados.indexOf($(this).text()), 1);
                        $('#canjear').hide();
                        canjear = false;
                    }
                    else if (registros_utilizados.length < 3) {
                        $(this).addClass('active');
                        registros_utilizados.push($(this).text());

                        console.log(registros_utilizados);
                        if (registros_utilizados.length === 3) {
                            $('#canjear').show();
                            canjear = true;
                            console.log(obtener_registro(registros_utilizados[0]));
                            console.log(obtener_registro(registros_utilizados[1]));
                            console.log(obtener_registro(registros_utilizados[2]));
                        }
                    }
                });
            });
        </script>
    </head>
    <body>
        <%@ include file="/WEB-INF/jsp/cabezal.jsp"%>
        <div class="container">
            <h1>Registro a función de espectáculo</h1>
            <form id="form" class="needs-validation" method='post' novalidate>
                <div class="mb-3 por-descuento">
                    <label class="form-label">Seleccione un paquete asociado al espectáculo de ésta función</label>
                    <select class="form-select" name="paquete" id="paquete" required>
                        <option value="">Ningún paquete seleccionado</option>
                        <% for (String paquete : paquetes_asociados) {%>
                            <option><%= paquete %></option>
                        <% } %>
                    </select>
                </div>
                <% if (nregistros >= 3) { %>
                    <div class="mb-3 por-descuento">
                        <label class="form-label">Seleccione 3 registros para canjear</label>
                        <ul class="list-group">
                            <% for (Registro_funcion registro : registros) { %>
                                <% if (registro.getCosto() != 0) {%>
                                    <li class="list-group-item"><%= registro.getFecha_registro() %> - <%= (GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_funcion_por_id", new Object[] {registro.getId_funcion()} ), Funcion.class)).getNombre()  %></li>
                                <% } %>
                            <% } %>
                        </ul>
                    </div>
                <% } %>
                <button type="submit" class="btn btn-primary" id="canjear">Canjear</button>
                <div class="mb-3 por-descuento">
                    <label class="form-label" id="costo">Costo final: $<%= (GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_espectaculo", new Object[] {id_espec} ), Espectaculo.class)).getCosto() %></label>
                </div>
                <div class="mb-3 por-no-descuento" style="display: none;">
                    <label class="form-label" id="costo">Costo final: <i>$0</i></label>
                </div>
                <button type="submit" class="btn btn-primary" id="registrarse">Registrarse a función</button>
            </form>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>
