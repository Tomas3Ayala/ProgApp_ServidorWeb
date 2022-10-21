
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="logica.enums.EstadoEspectaculo"%>
<%@page import="logica.clases.Espectaculo"%>
<%@page import="logica.clases.Funcion"%>
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
<%@page import="logica.Fabrica"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        ArrayList<String> grupo_espectaculos = new ArrayList<String>();
        HashMap<String, String> values = new HashMap<String, String>();
        HashMap<String, String> errors = new HashMap<String, String>();
        HashMap<String, Boolean> validez = new HashMap<String, Boolean>();
        if (request.getMethod() == "POST") {
            validez.put("espectaculo", true);
            validez.put("nombre", true);
            validez.put("fecha", true);
            validez.put("hora_inicio", true);
            validez.put("imagen", true);
            
            String espectaculo = request.getParameter("espectaculo");
            String nombre = request.getParameter("nombre");
            String fecha = request.getParameter("fecha");
            System.out.println(fecha);
            String horainicio = request.getParameter("hora_inicio");
            String imagen = request.getParameter("imagen");
            SimpleDateFormat formated =new SimpleDateFormat("yyyy-MM-dd");
            Date ffecha = (Date) formated.parse(fecha);
            //Date ffecha =  fromated.parse
            //java.sql.Date ffechad= new java.sql.Date(ffecha.getTime());
    
            values.put("nombre", nombre);
            values.put("espectaculo", espectaculo);
            values.put("fecha", fecha);
            values.put("hora_inicio", horainicio);
            

            System.out.println("====");
            System.out.println(nombre);
            System.out.println(fecha);
            System.out.println(horainicio);
            System.out.println(espectaculo);
            
            
            
            boolean error = false;
            if (imagen.length() != 0) { // esto no es un error, ya que la imagen tiene que volver a introducirse si es que ocurre un error
                validez.put("imagen", false);
                errors.put("imagen", "Vuelva a introducir la imagén");

                if (!imagen.substring(0, 10).equals("data:image")) { // esto si es un error
                    errors.put("imagen", "El formato de la imagén no es de tipo imagén");
                    error = true;
                }
            }
            
             if (espectaculo.isEmpty()) {
                validez.put("espectaculo", false);
                errors.put("espectaculo", "El espectaculo es un campo obligatorio");
                error = true;
            } 
           
            if (nombre.isEmpty()) {
                validez.put("nombre", false);
                errors.put("nombre", "El nombre es un campo obligatorio");
                error = true;
            }
            
            if (Fabrica.getInstance().getInstanceControladorEspectaculo().chequear_si_nombre_de_funcion_esta_repetido(nombre)) {
                validez.put("nombre", false);
                errors.put("nombre", "El nombre ya esta en uso");
                error = true;
            }
            if (fecha.isEmpty()) {
                validez.put("fecha", false);
                errors.put("fecha", "La fecha es un campo obligatorio");
                error = true;
            }else{ ffecha= formated.parse(fecha);}
           // ffechad= new java.sql.Date(ffecha.getTime());}
            Integer fhora_inicio = 0;
            if (horainicio.isEmpty()) {
                validez.put("hora_inicio", false);
                errors.put("hora_inicio", "La hora_inicio es un campo obligatorio");
                error = true;
            }
            else
                fhora_inicio = Math.round(Integer.valueOf(horainicio).intValue());
            
            if (!error) {
                byte[] imageFuncion = null;
                if (!imagen.isEmpty()) {
                    String[] parts = imagen.split(",");
                    imageFuncion = Base64.getDecoder().decode(parts[1]);
                }
                
                Integer id_espectaculo = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_idespectaculo(espectaculo);
                
                Funcion funcion = new Funcion (nombre, ffecha, fhora_inicio, new java.util.Date(), id_espectaculo);
                if (Fabrica.getInstance().getInstanceControladorPlataforma().Alta_de_Funcion(funcion, imageFuncion)) {
                    int ideFuncion = Fabrica.getInstance().getInstanceControladorPlataforma().obtener_idfuncion(nombre);
                  // for (String espectaculo : grupo_espectaculos) {
                  //   int idespec = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_espectaculo(idespec);
                      // Fabrica.getInstance().getInstanceControladorPlataforma().insertar_en_categoria_espectaculo(idecatego, idespec);
                   // }
//                    response.sendRedirect("/ServidorWeb");
                } else {
                    System.out.println("error desconocido en alta funcion");
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
        <title>Alta de funcion</title>
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
                if ($('#seleccion-espectaculo').val().length === 0)
                    return;
                let salir = false;
                $('#grupo-espectaculos li').each(function(){
                    console.log($(this).text());
                    if ($('#seleccion-espectaculo').val() === $(this).text())
                        salir = true;
                });
                if (salir)
                    return;

                $('#grupo-espectaculos').append(['<li class="list-group-item">', $('#seleccion-espectaculo').val(), '</li>'].join(''));
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

                    let espectaculos = "";
                    let primero = true;
                    $('#grupo-espectaculos li').each(function(){
                        if (primero)
                            primero = false;
                        else
                            espectaculos += ",";
                        espectaculos += $(this).text();
                    });
                    formData.set("espectaculos", espectaculos);

                });

            });
        </script>
    </head>
    <body>
        <%@ include file="/WEB-INF/jsp/cabezal.jsp"%>
        <div class="container">
            <form id="form" class="needs-validation" method='post' novalidate>
                <div class="mb-3">
                    <label class="form-label">Elija un espectaculo</label>
                    <select class="form-select <%= is_valids.get("espectaculo") %>" name="espectaculo" id="espectaculo" required>
                        
                        <% for (String espectaculo : Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_espectaculos_aceptados()) { %>
                            <option<%= (values.getOrDefault("espectaculo", "").equals(espectaculo)) ? " selected":"" %>><%= espectaculo %></option>
                        <% } %>
                    </select>
                    <div class="invalid-feedback"><%= errors.getOrDefault("espectaculo", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nombre</label>
                    <input class="form-control <%= is_valids.get("nombre") %>" name='nombre' type='text' value="<%= values.getOrDefault("nombre", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("nombre", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Fecha de la funcion</label>
                    <input class="form-control <%= is_valids.get("fecha") %>" name='fecha' type='date' value="<%= values.getOrDefault("fecha", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("fecha", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Hora de inicio</label>
                    <input class="form-control <%= is_valids.get("hora_inicio") %>" name='hora_inicio' type='number' step="1" pattern="\d+" value="<%= values.getOrDefault("hora_inicio", "") %>" required>
                    <div class="invalid-feedback"><%= errors.getOrDefault("hora_inicio", "") %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Imagén de funcion</label>
                    <input class="form-control <%= is_valids.get("imagen") %>" name='imagen' accept="image/jpeg,image/gif,image/png,image/x-eps" type='file' id="file" onchange="readFile(this)">
                    <div class="invalid-feedback"><%= errors.getOrDefault("imagen", "") %></div>
                </div>
                <button type="submit" class="btn btn-primary" id="registrarse">Registrar funcion</button>
            </form>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>
