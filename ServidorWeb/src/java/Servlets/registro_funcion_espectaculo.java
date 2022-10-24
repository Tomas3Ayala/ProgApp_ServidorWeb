/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import logica.Fabrica;
import logica.clases.Usuario;

/**
 *
 * @author Tomas
 */
@WebServlet(name = "registro_funcion_espectaculo", urlPatterns = {"/registro_funcion_espectaculo"})
public class registro_funcion_espectaculo extends HttpServlet {
    
    public boolean es_entero(String p) {
        try {
            Integer.parseInt(p);
        } catch (NumberFormatException ex) {
            return false;
        }
        return true;
    }
    
    public boolean chequear_datos_validos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        if (session.getAttribute("tipo") == null || session.getAttribute("tipo").equals("artista")) { // chequea que el usuario que inicio sesion NO sea un espectador
            System.out.println("sauce?");
            return false;
        }
        else { // en caso de que si sea pasa lo que indique el jsp registro_funcion_espectaculo
            //http://localhost:8080/ServidorWeb/registro_funcion_espectaculo?espectaculo=2&funcion=2
            String espectaculo = request.getParameter("espectaculo"), funcion = request.getParameter("funcion");
            int id_espec, id_func;
            if (espectaculo == null || !es_entero(espectaculo))
                return false;
            if (funcion == null || !es_entero(funcion))
                return false;
            id_espec = Integer.parseInt(espectaculo);
            id_func = Integer.parseInt(funcion);
            if (espectaculo != null && funcion != null &&
                    Fabrica.getInstance().getInstanceControladorEspectaculo().existe_id_de_espectaculo(id_espec) &&
                    Fabrica.getInstance().getInstanceControladorEspectaculo().existe_id_de_funcion(id_func) &&
                    Fabrica.getInstance().getInstanceControladorEspectaculo().es_un_espectaculo_aceptado(id_espec) &&
                    Fabrica.getInstance().getInstanceControladorEspectaculo().es_funcion_de_espectaculo(id_func, id_espec) &&
                    !Fabrica.getInstance().getInstanceControladorEspectaculo().esta_el_espectaculo_lleno(id_espec) &&
                    !Fabrica.getInstance().getInstanceControllerUsuario().esta_usuario_registrado_a_funcion(((Usuario) session.getAttribute("usuario")).getId(), id_func)
                    ) {
                System.out.println(((Usuario) session.getAttribute("usuario")).getId() + " " + id_func);
                return true;
            }
            else {
                //http://localhost:8080/ServidorWeb/registro_funcion_espectaculo?espectaculo=21&funcion=5
                System.out.println(Fabrica.getInstance().getInstanceControladorEspectaculo().existe_id_de_espectaculo(id_espec));
                System.out.println(Fabrica.getInstance().getInstanceControladorEspectaculo().es_un_espectaculo_aceptado(id_espec));
                System.out.println(Fabrica.getInstance().getInstanceControladorEspectaculo().es_funcion_de_espectaculo(id_func, id_espec));
                System.out.println("pero que?");
                return false;
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (chequear_datos_validos(request, response)) {
            ServletContext context = getServletContext();
            RequestDispatcher dispatcher = context.getRequestDispatcher("/WEB-INF/jsp/registro_funcion_espectaculo.jsp");
            dispatcher.forward(request, response);
        }
        else
            response.sendRedirect("/ServidorWeb");
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (chequear_datos_validos(request, response)) {
            HttpSession session = request.getSession(true);
            int id_espec = Integer.parseInt(request.getParameter("espectaculo"));
            int id_func = Integer.parseInt(request.getParameter("funcion"));
            int id_user = ((Usuario)session.getAttribute("usuario")).getId();

            String paquete = request.getParameter("paquete");
            int canje1 = Integer.parseInt(request.getParameter("canje1"));
            int canje2 = Integer.parseInt(request.getParameter("canje2"));
            int canje3 = Integer.parseInt(request.getParameter("canje3"));

            int costo = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_espectaculo(id_espec).getCosto();
            if (paquete.length() > 0 && Fabrica.getInstance().getInstanceControladorEspectaculo().existe_paquete(paquete))
                costo = (int) (costo * (1.0f - Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_info_paquete(paquete).getDescuento() / 100.0f));
            
            if (Fabrica.getInstance().getInstanceControladorEspectaculo().chequear_canje(id_user, canje1) && Fabrica.getInstance().getInstanceControladorEspectaculo().chequear_canje(id_user, canje2) && Fabrica.getInstance().getInstanceControladorEspectaculo().chequear_canje(id_user, canje3)) {
                costo = 0;
                Fabrica.getInstance().getInstanceControladorEspectaculo().canjear_registro(canje1, ((Usuario)session.getAttribute("usuario")).getId());
                Fabrica.getInstance().getInstanceControladorEspectaculo().canjear_registro(canje2, ((Usuario)session.getAttribute("usuario")).getId());
                Fabrica.getInstance().getInstanceControladorEspectaculo().canjear_registro(canje3, ((Usuario)session.getAttribute("usuario")).getId());
            }

            Fabrica.getInstance().getInstanceControladorEspectaculo().registrar_espectador_en_funcion_de_espectaculo(id_user, id_func, costo);
            response.sendRedirect("/ServidorWeb");
        }
        else
            response.sendRedirect("/ServidorWeb");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}