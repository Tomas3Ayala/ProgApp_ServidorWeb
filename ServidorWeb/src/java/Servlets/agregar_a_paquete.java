/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import logica.Fabrica;
import logica.clases.Espectaculo;

/**
 *
 * @author Tomas
 */
@WebServlet(name = "agregar_a_paquete", urlPatterns = {"/agregar_a_paquete"})
public class agregar_a_paquete extends HttpServlet {

    public boolean chequear_datos_validos(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        String paquete = request.getParameter("paquete");
        if (paquete == null)
            return false;
        int id_paqu;
        try {
            id_paqu = Integer.parseInt(paquete);
        } catch (NumberFormatException ex) {
            return false;
        }
        String espectaculo = request.getParameter("espectaculo");
        if (espectaculo == null)
            return false;
        int id_espec;
        try {
            id_espec = Integer.parseInt(espectaculo);
        } catch (NumberFormatException ex) {
            return false;
        }
        if (session.getAttribute("tipo") == null || !session.getAttribute("tipo").equals("artista"))
            return false;
        if (!Fabrica.getInstance().getInstanceControladorEspectaculo().existe_id_de_paquete(id_paqu))
            return false;
        if (!Fabrica.getInstance().getInstanceControladorEspectaculo().existe_id_de_espectaculo(id_espec))
            return false;

        ArrayList<Espectaculo> espectaculos_no_en_paquete = Fabrica.getInstance().getInstanceControladorEspectaculo().obtener_espectaculos_aceptados_no_de_paquete(id_paqu);
        boolean no_enpac = false;
        for (Espectaculo espe : espectaculos_no_en_paquete) {
            if (espe.getId() == id_espec) {
                no_enpac = true;
                break;
            }
        }
        if (!no_enpac)
            return false;

        return true;
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (chequear_datos_validos(request, response)) {
            int id_paqu = Integer.parseInt(request.getParameter("paquete"));
            int id_espec = Integer.parseInt(request.getParameter("espectaculo"));
            Fabrica.getInstance().getInstanceControladorPlataforma().Agregar_espectaculo_a_paquete(id_espec, Fabrica.getInstance().getInstanceControladorPlataforma().obtener_info_paquetes(id_paqu).getNombre());
//            response.sendRedirect("/ServidorWeb/consulta_paquete?paquete=" + id_paqu);
            response.sendRedirect("/ServidorWeb");
        }
        else
            response.sendRedirect("/ServidorWeb");
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
        processRequest(request, response);
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
        processRequest(request, response);
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
