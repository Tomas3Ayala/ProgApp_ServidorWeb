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
import Utility.Converter;
import Utility.Sender;
import com.google.gson.Gson;
import Utility.GsonToUse;

/**
 *
 * @author 59892
 */
@WebServlet(name = "comprar_paquete", urlPatterns = {"/comprar_paquete"})
public class comprar_paquete extends HttpServlet {
    
   protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession(true);

        String paquete = request.getParameter("paquete");
        int id_paqu;
        id_paqu = Integer.parseInt(paquete);
        
        int id_espec = ((Usuario) session.getAttribute("usuario")).getId();
        //System.out.println(id_espec);
        boolean comprado = (GsonToUse.gson.fromJson(Sender.post("/users/paquete_comprado", new Object[] {id_espec,  id_paqu} ), boolean.class));

        if (!comprado) {
            Sender.post("/users/comprar_paquete", new Object[] {id_espec,  id_paqu} );
//            response.sendRedirect("/ServidorWeb/consulta_paquete?paquete=" + id_paqu); 
        } else {
            ServletContext context = getServletContext();
            RequestDispatcher dispatcher = context.getRequestDispatcher("/WEB-INF/jsp/consulta_paquete.jsp");
            dispatcher.forward(request, response);
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
