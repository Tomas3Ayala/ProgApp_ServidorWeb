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
import logica.clases.Espectaculo;
import logica.clases.Usuario;
import logica.enums.EstadoEspectaculo;
import Utility.Converter;
import Utility.Sender;
import com.google.gson.Gson;
import Utility.GsonToUse;

/**
 *
 * @author Tomas
 */
@WebServlet(name = "consulta_espectaculo", urlPatterns = {"/consulta_espectaculo"})
public class consulta_espectaculo extends HttpServlet {

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
        String espec = request.getParameter("espectaculo");
        if (espec == null){
            //System.out.println("algo 1");
            response.sendRedirect("/ServidorWeb");
           
        } 
        else
        {
            try {
                int id_espec = Integer.parseInt(espec);
                if ((GsonToUse.gson.fromJson(Sender.post("/espectaculos/existe_id_de_espectaculo", new Object[] {id_espec} ), boolean.class))) {
                    HttpSession session = request.getSession(true);
                    Espectaculo espectaculo = (GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_espectaculo", new Object[] {id_espec} ), Espectaculo.class));
                    if (espectaculo.getEstado() == EstadoEspectaculo.ACEPTADO || (session.getAttribute("usuario") != null && espectaculo.getId_artista() == ((Usuario)session.getAttribute("usuario")).getId()))
                    {
                        ServletContext context = getServletContext();
                        RequestDispatcher dispatcher = context.getRequestDispatcher("/WEB-INF/jsp/consulta_espectaculo.jsp");
                        dispatcher.forward(request, response);
                    }
                    else
                        response.sendRedirect("/ServidorWeb");
                }
                else{
                    //System.out.println("algo 2");
                    response.sendRedirect("/ServidorWeb");
                }
            } catch (NumberFormatException ex) {
                //System.out.println("algo 3");
                response.sendRedirect("/ServidorWeb");
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
