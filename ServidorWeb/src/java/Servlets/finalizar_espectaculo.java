/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import DTOs.EspectaculoDto;
import Utility.GsonToUse;
import Utility.Sender;
import enums.EstadoEspectaculo;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import logica.clases.Espectaculo;
import logica.clases.Usuario;

/**
 *
 * @author Tomas
 */
@WebServlet(name = "finalizar_espectaculo", urlPatterns = {"/finalizar_espectaculo"})
public class finalizar_espectaculo extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        if (session.getAttribute("tipo") == null || !session.getAttribute("tipo").equals("artista")) // chequea que el usuario que inicio sesion sea un artista
            return;
        String id_espectaculo = request.getParameter("id_espectaculo");
            System.out.println(id_espectaculo);
        int id = -1;
        try {
            id = Integer.parseInt(id_espectaculo);
        } catch (NumberFormatException ex) {
            System.out.println("Error en finalizar_espectaculo.java: " + ex);
            return;
        }
        Espectaculo espectaculo = EspectaculoDto.toEspectaculo(GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_espectaculo", new Object[] {id} ), EspectaculoDto.class));
        if (espectaculo.getEstado() == EstadoEspectaculo.ACEPTADO && ((Usuario)session.getAttribute("usuario")).getId() == espectaculo.getId_artista()) {
            Sender.post("/espectaculos/finalizar_espectaculo", new Object[] {id});
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
