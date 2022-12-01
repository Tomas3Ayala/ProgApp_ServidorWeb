/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import DTOs.PaqueteDto;
import Utility.Converter;
import Utility.GsonToUse;
import Utility.Sender;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import logica.clases.Espectaculo;

/**
 *
 * @author Tomas
 */
@WebServlet(name = "agregar_a_paquete", urlPatterns = {"/agregar_a_paquete"})
public class agregar_a_paquete extends HttpServlet {

    public boolean chequear_datos_validos(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
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
        if (!(GsonToUse.gson.fromJson(Sender.post("/espectaculos/existe_id_de_paquete", new Object[] {id_paqu} ), boolean.class)))
            return false;
        if (!(GsonToUse.gson.fromJson(Sender.post("/espectaculos/existe_id_de_espectaculo", new Object[] {id_espec} ), boolean.class)))
            return false;

        ArrayList<Espectaculo> espectaculos_no_en_paquete = Converter.to_Espectaculo_list(GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_espectaculos_aceptados_no_de_paquete", new Object[] {id_paqu} ), ArrayList.class));
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
            ///plataformas/obtener_info_paquetes
            Sender.post("/plataformas/Agregar_espectaculo_a_paquete", new Object[] {id_espec, GsonToUse.gson.fromJson(Sender.post("/plataformas/obtener_info_paquetes", new Object[] {id_paqu}), PaqueteDto.class).getNombre()});
            //Fabrica.getInstance().getInstanceControladorPlataforma().obtener_info_paquetes(id_paqu).getNombre()
//            Fabrica.getInstance().getInstanceControladorPlataforma().Agregar_espectaculo_a_paquete(, );

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
