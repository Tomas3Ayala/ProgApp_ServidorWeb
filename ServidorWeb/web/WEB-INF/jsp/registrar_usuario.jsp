<%-- 
    Document   : registrar_usuario
    Created on : 13-oct-2022, 20:25:34
    Author     : Tomas
--%>

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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    <%
        boolean es_artista = false;
        HashMap<String, String> values = new HashMap<String, String>();
        HashMap<String, String> errors = new HashMap<String, String>();
        HashMap<String, Boolean> validez = new HashMap<String, Boolean>();
        if (request.getMethod() == "POST") {
            validez.put("nickname", true);
            validez.put("nombre", true);
            validez.put("apellido", true);
            validez.put("pass", true);
            validez.put("conf_pass", true);
            validez.put("correo", true);
            validez.put("fecha", true);
            validez.put("imagen", true);
            validez.put("descripcion", true);
            validez.put("biografia", true);
            validez.put("link", true);
            if (request.getParameter("es_artista") != null) {
                es_artista = true;
            }
            
            String nickname = request.getParameter("nickname");
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String pass = request.getParameter("pass");
            String conf_pass = request.getParameter("conf_pass");
            String correo = request.getParameter("correo");
            String fecha = request.getParameter("fecha");
            String imagen = request.getParameter("imagen");
            String descripcion = request.getParameter("descripcion");
            String biografia = request.getParameter("biografia");
            String link = request.getParameter("link");
            values.put("nickname", nickname);
            values.put("nombre", nombre);
            values.put("apellido", apellido);
            values.put("correo", correo);
            values.put("fecha", fecha);
            values.put("descripcion", descripcion);
            values.put("biografia", biografia);
            values.put("link", link);
            boolean error = false;
            if (imagen.length() != 0) { // esto no es un error, ya que la imagen tiene que volver a introducirse si es que ocurre un error
                validez.put("imagen", false);
                errors.put("imagen", "Vuelva a introducir la imagén");

                if (!imagen.substring(0, 10).equals("data:image")) { // esto si es un error
                    errors.put("imagen", "El formato de la imagén no es de tipo imagén");
                    error = true;
                }
            }
            if (Fabrica.getInstance().getInstanceControllerUsuario().chequear_nickname_repetido(nickname)) {
                validez.put("nickname", false);
                errors.put("nickname", "Nickname ya esta siendo usado en el sistema por otro usuario");
                error = true;
            }
            if (nickname.isEmpty()) {
                validez.put("nickname", false);
                errors.put("nickname", "El nickname es un campo obligatorio");
                error = true;
            }
            if (nombre.isEmpty()) {
                validez.put("nombre", false);
                errors.put("nombre", "El nombre es un campo obligatorio");
                error = true;
            }
            if (apellido.isEmpty()) {
                validez.put("apellido", false);
                errors.put("apellido", "El apellido es un campo obligatorio");
                error = true;
            }
            if (Fabrica.getInstance().getInstanceControllerUsuario().chequear_correo_repetido(correo)) {
                validez.put("correo", false);
                errors.put("correo", "Este correo ya esta siendo usado por otro usuario en el sistema");
                error = true;
            }
            else if (!correo.matches(Fabrica.EMAIL_REGEX)) {
                validez.put("correo", false);
                errors.put("correo", "El correo debe tener un formato valido");
                error = true;
            }
            if (correo.isEmpty()) {
                validez.put("correo", false);
                errors.put("correo", "El correo es un campo obligatorio");
                error = true;
            }
            if (!pass.equals(conf_pass)) {
                validez.put("pass", false);
                validez.put("conf_pass", false);
                errors.put("conf_pass", "La contraseña y la confirmación de contraseña no coinciden");
                System.out.println(pass);
                System.out.println(conf_pass);
                error = true;
            }
            if (pass.isEmpty()) {
                validez.put("pass", false);
                validez.put("conf_pass", false);
                errors.put("pass", "La contraseña es obligatoria");
                error = true;
            }
            LocalDate date = LocalDate.now();
            try {
                date = LocalDate.parse(fecha);
                // lo comentado es para verificar que sea mayor a 18 años, aun no se si es necesario
                Period p = Period.between(date, LocalDate.now());
                if (p.getYears() < 18) {
                    validez.put("fecha", false);
                    errors.put("fecha", "Debe tener almenos 18 años para registrarse");
                    error = true;
                }
            } catch (DateTimeParseException ex) {
                validez.put("fecha", false);
                errors.put("fecha", "La fecha debe tener un formato valido");
                error = true;
            }

            if (es_artista) {
                if (descripcion.isEmpty()) {
                    validez.put("descripcion", false);
                    errors.put("descripcion", "La descripción es un campo obligatorio");
                    error = true;
                }
                if (!link.isEmpty() && !link.matches(Fabrica.WEB_REGEX)) {
                    validez.put("link", false);
                    errors.put("link", "El link del sitio web debe tener un formato valido");
                    error = true;
                }
            }
            if (!error) {
                byte[] imageUsuario = null;
                if (!imagen.isEmpty()) {
                    String[] parts = imagen.split(",");
                    imageUsuario = Base64.getDecoder().decode(parts[1]);
                }
                java.util.Date f = java.util.Date.from(date.atStartOfDay().atZone(ZoneId.systemDefault()).toInstant());
                if (es_artista) {
                    Artista artista = new Artista(descripcion, biografia, link, nickname, nombre, apellido, correo, f, -1, pass);

                    Fabrica.getInstance().getInstanceControllerUsuario().registrar_artista(artista, imageUsuario);
                    session.setAttribute("mensaje", "ARTISTA REGISTRADO CON ÉXITO");
                }
                else {
                    Espectador espectador = new Espectador(nickname, nombre, apellido, correo, f, -1, pass);
                    Fabrica.getInstance().getInstanceControllerUsuario().registrar_espectador(espectador, imageUsuario);
                    session.setAttribute("mensaje", "ESPECTADOR REGISTRADO CON ÉXITO");
                }
                %><meta http-equiv="Refresh" content="0; url='/ServidorWeb'" /><% // me lleva al inicio
            }
        }

        // Llenando el mapa de validez con is-valid y is-invalid
        HashMap<String, String> is_valids = new HashMap<String, String>();
        for (Map.Entry<String, Boolean> set : validez.entrySet()) {
            is_valids.put(set.getKey(), set.getValue() ? "is-valid":"is-invalid");
        }
    %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registrarse</title>
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

            $( document ).ready(function() {
                
                
                <% if (!es_artista) { %>
                    $(".parte_de_artista").hide(); // oculta los datos de artista
                <% } %>

                // alterna entre artista y espectador, haciendo visible a la parte de artista que no es parte de espectador
                $("#es_artista").change(() => {
                    $(".parte_de_artista").toggle();
                });

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
//                        alert("que paso?");
                    }
                });
                
//                $("#fecha").change((e) => {
//                    
//                    $("#fecha").val(new Date($("#fecha").val()).toISOString().substring(0, 10));
//                });

            });
        </script>
        
    </head>
    <body>
     
        <%@ include file="/WEB-INF/jsp/cabezal.jsp"%>
        <div class="container">
            <form id="form" class="needs-validation" method='post' novalidate style="width: 60%; margin: 0 auto; background-color: lemonchiffon">
                <div class="mb-3">
                    <label class="form-label">Nickname</label>
                    <input class="form-control <%= is_valids.get("nickname") %>" name='nickname' type='text' value="<%= values.getOrDefault("nickname", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("nickname", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nombre</label>
                    <input class="form-control <%= is_valids.get("nombre") %>" name='nombre' type='text' value="<%= values.getOrDefault("nombre", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("nombre", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Apellido</label>
                    <input class="form-control <%= is_valids.get("apellido") %>" name='apellido' type='text' value="<%= values.getOrDefault("apellido", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("apellido", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Contraseña</label>
                    <input class="form-control <%= is_valids.get("pass") %>" name='pass' type='password' required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("pass", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Confirme contraseña</label>
                    <input class="form-control <%= is_valids.get("conf_pass") %>" name='conf_pass' type='password' required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("conf_pass", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Correo electrónico</label>
                    <input class="form-control <%= is_valids.get("correo") %>" name='correo' type='email' value="<%= values.getOrDefault("correo", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("correo", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Fecha de nacimiento</label>
                    <input class="form-control <%= is_valids.get("fecha") %>" name='fecha' type='date' id="fecha" value="<%= values.getOrDefault("fecha", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("fecha", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Imagén de perfil</label>
                    <input class="form-control <%= is_valids.get("imagen") %>" name='imagen' accept="image/jpeg,image/gif,image/png,image/x-eps" type='file' id="file" onchange="readFile(this)">
                    <div class="invalid-feedback"><%= errors.getOrDefault("imagen", "") %></div>
                </div>
                <div class="form-check form-switch" id="es_artista">
                    <input class="form-check-input" type="checkbox" role="switch" name="es_artista" id="flexSwitchCheckDefault" <%= es_artista ? "checked":"" %>>
                    <label class="form-check-label" for="flexSwitchCheckDefault">¿Eres un artista?</label>
                </div>

                <div class="mb-3 parte_de_artista">
                    <label class="form-label">Descripción general</label>
                    <input class="form-control <%= is_valids.get("descripcion") %>" name='descripcion' type='text' value="<%= values.getOrDefault("descripcion", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("descripcion", "") %></div>
                </div>
                <div class="mb-3 parte_de_artista">
                    <label for="exampleFormControlTextarea1" class="form-label">Breve biografía</label>
                    <textarea class="form-control <%= is_valids.get("biografia") %>" id="exampleFormControlTextarea1" rows="3" name="biografia"><%= values.getOrDefault("biografia", "") %></textarea>
                    <div class="invalid-feedback"><%= errors.getOrDefault("biografia", "") %></div>
                </div>
                <div class="mb-3 parte_de_artista">
                    <label class="form-label">Link a su sitio web</label>
                    <input class="form-control <%= is_valids.get("link") %>" name='link' type='link' value="<%= values.getOrDefault("link", "") %>">
                    <div class="invalid-feedback"><%= errors.getOrDefault("link", "") %></div>
                </div>
                <button type="submit" class="btn btn-primary" id="registrarse">Registrarse</button>
            </form>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
       
    </body>
</html>
