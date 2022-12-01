<%@page import="DTOs.EspectaculoDto"%>
<%@page import="Utility.GsonToUse"%>
<%@page import="enums.EstadoEspectaculo"%>
<%@page import="logica.clases.Espectaculo"%>
<%@page import="logica.clases.Categoria"%>
<%@page import="logica.clases.Plataforma"%>
<%@page import="java.util.Arrays"%>
<%@page import="logica.clases.Espectador"%>
<%@page import="java.util.Base64"%>
<%@page import="java.time.ZoneId"%>
<%@page import="logica.clases.Artista"%>
<%@page import="java.time.format.DateTimeParseException"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.Period"%>
<%@page import="java.time.LocalDate"%>
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
        ArrayList<String> grupo_categorias = new ArrayList<String>();
        HashMap<String, String> values = new HashMap<String, String>();
        HashMap<String, String> errors = new HashMap<String, String>();
        HashMap<String, Boolean> validez = new HashMap<String, Boolean>();
        if (request.getMethod().equals("POST")) {
            validez.put("plataforma", true);
            validez.put("nombre", true);
            validez.put("descripcion", true);
            validez.put("duracion", true);
            validez.put("minimo", true);
            validez.put("maximo", true);
            validez.put("link", true);
            validez.put("costo", true);
            validez.put("categorias", true);
            validez.put("imagen", true);

            String plataforma = request.getParameter("plataforma");
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            String duracion = request.getParameter("duracion");
            String minimo = request.getParameter("minimo");
            String maximo = request.getParameter("maximo");
            String link = request.getParameter("link");
            String costo = request.getParameter("costo");
            String categorias = request.getParameter("categorias");
            String imagen = request.getParameter("imagen");
            values.put("plataforma", plataforma);
            values.put("nombre", nombre);
            values.put("descripcion", descripcion);
            values.put("duracion", duracion);
            values.put("minimo", minimo);
            values.put("maximo", maximo);
            values.put("link", link);
            values.put("costo", costo);
            values.put("categorias", categorias);

//            System.out.println("====");
//            System.out.println(plataforma);
//            System.out.println(nombre);
//            System.out.println(descripcion);
//            System.out.println(duracion);
//            System.out.println(minimo);
//            System.out.println(maximo);
//            System.out.println(link);
//            System.out.println(costo);

            grupo_categorias = new ArrayList<String>(Arrays.asList(categorias.split(",")));
            if (grupo_categorias.size() == 1 && grupo_categorias.get(0).isEmpty())
                grupo_categorias.clear();
            boolean error = false;
            if (imagen.length() != 0) { // esto no es un error, ya que la imagen tiene que volver a introducirse si es que ocurre un error
                validez.put("imagen", false);
                errors.put("imagen", "Vuelva a introducir la imagén");

                if (!imagen.substring(0, 10).equals("data:image")) { // esto si es un error
                    errors.put("imagen", "El formato de la imagén no es de tipo imagén");
                    error = true;
                }
            }
            if (plataforma.isEmpty()) {
                validez.put("plataforma", false);
                errors.put("plataforma", "La plataforma es un campo obligatorio");
                error = true;
            }
            if (nombre.isEmpty()) {
                validez.put("nombre", false);
                errors.put("nombre", "El nombre es un campo obligatorio");
                error = true;
            }
            if ((GsonToUse.gson.fromJson(Sender.post("/espectaculos/chequear_si_nombre_de_espectaculo_esta_repetido_para_cierta_plataforma", new Object[] {nombre,  plataforma} ), boolean.class))) {
                validez.put("nombre", false);
                errors.put("nombre", "El nombre esta repetido para la plataforma seleccionada");
                error = true;
            }
            if (descripcion.isEmpty()) {
                validez.put("descripcion", false);
                errors.put("descripcion", "La descripción es un campo obligatorio");
                error = true;
            }
            Integer fduracion = 0, fminimo = 0, fmaximo = 0;
            if (duracion.isEmpty()) {
                validez.put("duracion", false);
                errors.put("duracion", "La duración es un campo obligatorio");
                error = true;
            }
            else
                fduracion = Math.round(Float.valueOf(duracion).floatValue());
            if (minimo.isEmpty()) {
                validez.put("minimo", false);
                errors.put("minimo", "La mínimo es un campo obligatorio");
                error = true;
            }
            else
                fminimo = Math.round(Float.valueOf(minimo).floatValue());
            if (fminimo < 0) {
                validez.put("minimo", false);
                errors.put("minimo", "El mínimo tiene que ser un número mayor a cero");
                error = true;
            }
            if (maximo.isEmpty()) {
                validez.put("maximo", false);
                errors.put("maximo", "La máximo es un campo obligatorio");
                error = true;
            }
            else
                fmaximo = Math.round(Float.valueOf(maximo).floatValue());
            if (fmaximo < 0) {
                validez.put("maximo", false);
                errors.put("maximo", "El máximo tiene que ser un número mayor a cero");
                error = true;
            }
            if (!minimo.isEmpty() && !maximo.isEmpty() && Math.round(Float.valueOf(minimo).floatValue()) >= Math.round(Float.valueOf(maximo).floatValue())) {
                validez.put("minimo", false);
                validez.put("maximo", false);
                errors.put("minimo", "El mínimo tiene que ser menor al máximo");
                error = true;
            }
            if (!link.matches(Sender.WEB_REGEX)) {
                validez.put("link", false);
                errors.put("link", "La URL debe tener un formato valido");
                error = true;
            }
            Integer fcosto = 0;
            if (costo.isEmpty()) {
                validez.put("costo", false);
                errors.put("costo", "El costo es un campo obligatorio");
                error = true;
            }
            else
                fcosto = Math.round(Float.valueOf(costo).floatValue());
            if (!costo.isEmpty() && Math.round(Float.valueOf(costo).floatValue()) < 0) {
                validez.put("costo", false);
                errors.put("costo", "El costo tiene que ser un número mayor a cero");
                error = true;
            }

            if (!error) {
                byte[] imageEspectaculo = null;
                if (!imagen.isEmpty()) {
                    String[] parts = imagen.split(",");
                    imageEspectaculo = Base64.getDecoder().decode(parts[1]);
                }
                Espectaculo espectaculo = new Espectaculo(plataforma, nombre, descripcion, fduracion, fminimo, fmaximo, link, fcosto, new java.util.Date(), ((Usuario)session.getAttribute("usuario")).getId(), EstadoEspectaculo.INGRESADO);

                if ((GsonToUse.gson.fromJson(Sender.post("/plataformas/crear_Espectaculo", new Object[] {new EspectaculoDto(espectaculo),  imageEspectaculo} ), boolean.class))) {
                     session.setAttribute("mensaje", "ESPECTACULO CREADO");
                
                    int idespec = (GsonToUse.gson.fromJson(Sender.post("/plataformas/obtener_idespectaculo", new Object[] {nombre,  plataforma} ), int.class));

                    for (String categoria : grupo_categorias) {
                        int idecatego = (GsonToUse.gson.fromJson(Sender.post("/plataformas/obtener_id_categoria", new Object[] {categoria} ), int.class));
                        Sender.post("/plataformas/insertar_en_categoria_espectaculo", new Object[] {idecatego,  idespec} );
                    }
                    %><meta http-equiv="Refresh" content="0; url='/ServidorWeb'" /><%
                } else {
                    System.out.println("error desconocido en alta espectaculo");
                }
            }
        }

        // Llenando el mapa de validez con is-valid y is-invalid
        HashMap<String, String> is_valids = new HashMap<String, String>();
        for (Map.Entry<String, Boolean> set : validez.entrySet()) {
            is_valids.put(set.getKey(), set.getValue() ? "is-valid":"is-invalid");
        }
    %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Alta de espectaculo</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript">
            var image_loaded = false;
            var image = null;
            function readFile(input) {
                image_loaded = true;
                let file = input.files[0];

                let reader = new FileReader();

                reader.readAsDataURL(file);

                reader.onload = function() {
                    console.log(reader.result);
                    image = reader.result;
                };

                reader.onerror = function() {
                    console.log(reader.error);
                };
            }
            
            function agregar_categoria() {
                if ($('#seleccion-categoria').val().length === 0)
                    return;
                let salir = false;
                $('#grupo-categorias li').each(function(){
                    console.log($(this).text());
                    if ($('#seleccion-categoria').val() === $(this).text())
                        salir = true;
                });
                if (salir)
                    return;

                $('#grupo-categorias').append(['<li class="list-group-item">', $('#seleccion-categoria').val(), '</li>'].join(''));
            }

            $( document ).ready(function() {

                // dandole click a un input del formulario le quito lo invalido y valido
                $(document).on("click", "input", function () {
                    $(this).removeClass("is-invalid");
                });
                $(document).on("click", "textarea", function () {
                    $(this).removeClass("is-invalid");
                });
                
                $("#form").on("formdata", (e) => {
                    const formData = e.originalEvent.formData; 

                    if (image_loaded) { // se fija si esta disponible
                        while (image === null); // espera a la que imagen este cargada
                        formData.set("imagen", image);
                    }

                    let categorias = "";
                    let primero = true;
                    $('#grupo-categorias li').each(function(){
                        if (primero)
                            primero = false;
                        else
                            categorias += ",";
                        categorias += $(this).text();
                    });
                    formData.set("categorias", categorias);

                });

            });
        </script>
    </head>
    <body>
        <%@ include file="/WEB-INF/jsp/cabezal.jsp"%>
        <div class="container">
            <form id="form" class="needs-validation" method='post' novalidate style="width: 60%; margin: 0 auto; background-color: lemonchiffon">
                <div class="mb-3">
                    <label class="form-label">Plataforma a través de la cual se ofrecerá el espectaculo</label>
                    <select class="form-select <%= is_valids.get("plataforma") %>" name="plataforma" id="plataforma" required>
                        <option value="">Plataforma</option>
                        <% for (Object plataforma : (GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_plataformas_disponibles", new Object[] {} ), ArrayList.class))) { %>
                            <option<%= (values.getOrDefault("plataforma", "").equals(plataforma)) ? " selected":"" %>><%= (String) plataforma %></option>
                        <% } %>
                    </select>
                    <div class="invalid-feedback"><%= errors.getOrDefault("plataforma", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nombre</label>
                    <input class="form-control <%= is_valids.get("nombre") %>" name='nombre' type='text' value="<%= values.getOrDefault("nombre", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("nombre", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Descripción</label>
                    <input class="form-control <%= is_valids.get("descripcion") %>" name='descripcion' type='text' value="<%= values.getOrDefault("descripcion", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("descripcion", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Duración</label>
                    <input class="form-control <%= is_valids.get("duracion") %>" name='duracion' type='number' step="1" pattern="\d+" value="<%= values.getOrDefault("duracion", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("duracion", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Espectadores mínimos</label>
                    <input class="form-control <%= is_valids.get("minimo") %>" name='minimo' type='number' step="1" pattern="\d+" value="<%= values.getOrDefault("minimo", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("minimo", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Espectadores máximos</label>
                    <input class="form-control <%= is_valids.get("maximo") %>" name='maximo' type='number' step="1" pattern="\d+" value="<%= values.getOrDefault("maximo", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("maximo", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">URL</label>
                    <input class="form-control <%= is_valids.get("link") %>" name='link' type='text' value="<%= values.getOrDefault("link", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("link", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Costo</label>
                    <input class="form-control <%= is_valids.get("costo") %>" name='costo' type='number' step="1" pattern="\d+" value="<%= values.getOrDefault("costo", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("costo", "") %></div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Categorias</label>
                    <div class="hstack gap-3">
                        <select class="form-select" id="seleccion-categoria">
                            <option value="" selected>Categoria</option>
                            <% for (Object categoria : Converter.to_Categoria_list(GsonToUse.gson.fromJson(Sender.post("/plataformas/obtener_categorias", new Object[] {} ), ArrayList.class))) { %>
                                <option><%= ((Categoria)categoria).getNombre() %></option>
                            <% } %>
                        </select>
                        <button type="button" class="btn btn-primary" onclick="agregar_categoria()">Agregar</button>
                    </div>
                </div>
                <div class="mb-3">
                    <ul class="list-group" id="grupo-categorias">
                        <% for (String categoria : grupo_categorias) { %>
                            <li class="list-group-item"><%= categoria %></li>
                        <% } %>
                    </ul>
                </div>
                <div class="mb-3">
                    <label class="form-label">Imagén de espectaculo</label>
                    <input class="form-control <%= is_valids.get("imagen") %>" name='imagen' accept="image/jpeg,image/gif,image/png,image/x-eps" type='file' id="file" onchange="readFile(this)">
                    <div class="invalid-feedback"><%= errors.getOrDefault("imagen", "") %></div>
                </div>
                <button type="submit" class="btn btn-primary" id="registrarse">Registrar espectaculo</button>
            </form>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>
