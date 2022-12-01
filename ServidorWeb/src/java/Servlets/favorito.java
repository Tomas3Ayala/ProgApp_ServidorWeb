/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import logica.clases.Usuario;
import logica.clases.Espectaculo;
import logica.clases.Espectador;
import Utility.Converter;
import Utility.Sender;
import com.google.gson.Gson;
import Utility.GsonToUse;

/**
 *
 * @author 59892
 */
@WebServlet(name = "favorito", urlPatterns = {"/favorito"})
public class favorito extends HttpServlet {

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
        System.out.println(request.getParameter("marcar"));
        String nick = request.getParameter("nick"),id_espectaculo = request.getParameter("id_espectaculo");
        if (nick == null || id_espectaculo == null)
            return;
        if (request.getParameter("marcar") == null)
            return;
        int id_espectacul = Integer.parseInt(id_espectaculo);
        boolean marcar = request.getParameter("marcar").equals("si");
        HttpSession session = request.getSession(true);
        if (session.getAttribute("tipo") == null || !((Usuario)session.getAttribute("usuario")).getNickname().equals(nick))
            return;
        if (!GsonToUse.gson.fromJson(Sender.post("/users/existe_nickname_de_usuario", new Object[] {nick}), boolean.class) || !GsonToUse.gson.fromJson(Sender.post("/espectaculos/existe_id_de_espectaculo", new Object[] {id_espectacul}), boolean.class))
            return;
        if (marcar) {
            if ((GsonToUse.gson.fromJson(Sender.post("/users/tiene_favorito_a", new Object[] {nick, id_espectacul} ), boolean.class)))
                return;
            Sender.post("/users/marcar_favorito_a", new Object[] {nick, id_espectaculo} );
        }
        else {
            if (!(GsonToUse.gson.fromJson(Sender.post("/users/tiene_favorito_a", new Object[] {nick,  id_espectacul} ), boolean.class)))
                return;
            Sender.post("/users/desmarcar_favorito_a", new Object[] {nick,  id_espectacul} );
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
