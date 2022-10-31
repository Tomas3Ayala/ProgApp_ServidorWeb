<%@page import="java.text.SimpleDateFormat"%>
<%@page import="logica.clases.Paquete"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Base64"%>
<%@page import="java.time.ZoneId"%>
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
      <%
        HashMap<String, String> values = new HashMap<String, String>();
        HashMap<String, String> errors = new HashMap<String, String>();
        HashMap<String, Boolean> validez = new HashMap<String, Boolean>();
        if (request.getMethod() == "POST") {
            
            validez.put("nombre", true);
            validez.put("descripcion", true);
            validez.put("fecha_inicio", true);
            validez.put("fecha_fin", true);
            validez.put("imagen", true);
            validez.put("porcentaje", true);
                     
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            String fecha_inicio = request.getParameter("fecha_inicio");
            String fecha_fin = request.getParameter("fecha_fin");
            String porcentaje = request.getParameter("porcentaje");
            String imagen = request.getParameter("imagen");
            SimpleDateFormat formated =new SimpleDateFormat("yyyy-MM-dd");
            Date ifecha = (Date) formated.parse(fecha_inicio);
            Date ffecha = (Date) formated.parse(fecha_fin);
               
            values.put("nombre", nombre);
            values.put("descripcion", descripcion);
            values.put("fecha_inicio", fecha_inicio);
            values.put("fecha_fin", fecha_fin);
            values.put("porcentaje", porcentaje);
           
            System.out.println("====");
            System.out.println(nombre);
            System.out.println(descripcion);
            System.out.println(fecha_inicio);
            System.out.println(porcentaje);         
            
            boolean error = false;
            if (imagen.length() != 0) { // esto no es un error, ya que la imagen tiene que volver a introducirse si es que ocurre un error
                validez.put("imagen", false);
                errors.put("imagen", "Vuelva a introducir la imagén");

                if (!imagen.substring(0, 10).equals("data:image")) { // esto si es un error
                    errors.put("imagen", "El formato de la imagén no es de tipo imagén");
                    error = true;
                }
            }
            
             if (descripcion.isEmpty()) {
                validez.put("descripcion", false);
                errors.put("descripcion", "La descripcion es un campo obligatorio");
                error = true;
            } 
           
            if (nombre.isEmpty()) {
                validez.put("nombre", false);
                errors.put("nombre", "El nombre es un campo obligatorio");
                error = true;
            }
            
            if (Fabrica.getInstance().getInstanceControladorEspectaculo().chequear_si_nombre_de_paquete_esta_repetido(nombre)) {
                validez.put("nombre", false);
                errors.put("nombre", "El nombre ya esta en uso");
                error = true;
            }
            if (fecha_inicio.isEmpty()) {
                validez.put("fecha_inicio", false);
                errors.put("fecha_inicio", "La fecha de inicio es un campo obligatorio");
                error = true;
            }else{ ifecha= formated.parse(fecha_inicio);}
            
            if (fecha_fin.isEmpty()) {
                validez.put("fecha_fin", false);
                errors.put("fecha_fin", "La fecha de fin es un campo obligatorio");
                error = true;
            }else{ ffecha= formated.parse(fecha_fin);}
           
            int pporcentaje = 0;
            if (porcentaje.isEmpty()) {
                validez.put("porcentaje", false);
                errors.put("porcentaje", "El porcentaje de descuento es un campo obligatorio");
                error = true;
            }
            else
                pporcentaje = Math.round(Integer.valueOf(porcentaje).intValue());
            
            if (!error) {
                byte[] imagePaquete = null;
                if (!imagen.isEmpty()) {
                    String[] parts = imagen.split(",");
                    imagePaquete = Base64.getDecoder().decode(parts[1]);
                }
                
                Paquete paquete = new Paquete (nombre, descripcion, ifecha, ffecha, pporcentaje);
                if (Fabrica.getInstance().getInstanceControladorEspectaculo().registrar_paquete(paquete, imagePaquete)){ 
//                    response.sendRedirect("/ServidorWeb");
                      %><meta http-equiv="Refresh" content="0; url='/ServidorWeb'" /><%
                } else {
                    System.out.println("error desconocido al crear el paquete");
                }
            }
        }

        // Llenando el mapa de validez con is-valid y is-invalid
        HashMap<String, String> is_valids = new HashMap<String, String>();
        for (Map.Entry<String, Boolean> set : validez.entrySet()) {
            is_valids.put(set.getKey(), set.getValue() ? "is-valid":"is-invalid");
        }
    %>
    <head>
         <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Alta de Paquete</title>
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
                });

            });
        </script>
    </head>
    <body>
        <%@ include file="/WEB-INF/jsp/cabezal.jsp"%>
        <div class="container">
            <form id="form" class="needs-validation" method='post' novalidate>
                <div class="mb-3">
                    <label class="form-label">Nombre</label>
                    <input class="form-control <%= is_valids.get("nombre")%>" name='nombre' type='text' value="<%= values.getOrDefault("nombre", "")%>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("nombre", "")%></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Descripcion</label>
                    <input class="form-control <%= is_valids.get("descripcion")%>" name='descripcion' type='text' value="<%= values.getOrDefault("descripcion", "")%>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("nombre", "")%></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Fecha que iniciara el paquete</label>
                    <input class="form-control <%= is_valids.get("fecha_inicio")%>" name='fecha_inicio' type='date' value="<%= values.getOrDefault("fecha_inicio", "")%>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("fecha_inicio", "")%></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Fecha que finaliza paquete</label>
                    <input class="form-control <%= is_valids.get("fecha_fin")%>" name='fecha_fin' type='date' value="<%= values.getOrDefault("fecha_fin", "")%>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("fecha_fin", "")%></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Porcentaje de descuento</label>
                    <input class="form-control <%= is_valids.get("porcentaje")%>" name='porcentaje' type='number' step="1" pattern="\d+" value="<%= values.getOrDefault("porcentaje", "")%>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("porcentaje", "")%></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Imagén de Paquete</label>
                    <input class="form-control <%= is_valids.get("imagen")%>" name='imagen' accept="image/jpeg,image/gif,image/png,image/x-eps" type='file' id="file" onchange="readFile(this)">
                    <div class="invalid-feedback"><%= errors.getOrDefault("imagen", "")%></div>
                </div>
                <button type="submit" class="btn btn-primary" id="registrarse">Registrar Paquete</button>
            </form>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>