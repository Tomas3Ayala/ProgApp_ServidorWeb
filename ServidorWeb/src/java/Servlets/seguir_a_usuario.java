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
import logica.Fabrica;
import logica.clases.Usuario;
import Utility.Converter;
import Utility.Sender;
import com.google.gson.Gson;
import Utility.GsonToUse;

/**
 *
 * @author Tomas
 */
@WebServlet(name = "seguir_a_usuario", urlPatterns = {"/seguir_a_usuario"})
public class seguir_a_usuario extends HttpServlet {

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
        String nick1 = request.getParameter("nick1"), nick2 = request.getParameter("nick2");
        if (nick1 == null || nick2 == null)
            return;
        if (request.getParameter("seguir") == null)
            return;
        if (nick1.equals(nick2))
            return;
        boolean seguir = request.getParameter("seguir").equals("si");
        HttpSession session = request.getSession(true);
        if (session.getAttribute("tipo") == null || !((Usuario)session.getAttribute("usuario")).getNickname().equals(nick1))
            return;
        if (!Fabrica.getInstance().getInstanceControllerUsuario().existe_nickname_de_usuario(nick1) || !Fabrica.getInstance().getInstanceControllerUsuario().existe_nickname_de_usuario(nick2))
            return;
        if (seguir) {
            if ((GsonToUse.gson.fromJson(Sender.post("/users/esta_siguiendo_a", new Object[] {nick1,  nick2} ), boolean.class)))
                return;
            Sender.post("/users/seguir_a", new Object[] {nick1,  nick2} );
        }
        else {
            if (!(GsonToUse.gson.fromJson(Sender.post("/users/esta_siguiendo_a", new Object[] {nick1,  nick2} ), boolean.class)))
                return;
            Sender.post("/users/dejar_de_seguir", new Object[] {nick1,  nick2} );
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
