
package Servlets;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.springframework.http.MediaType;
import Utility.Converter;
import Utility.Sender;
import com.google.gson.Gson;
import logica.clases.Paquete;
import Utility.GsonToUse;

@WebServlet(name = "imagen", urlPatterns = {"/imagen"})
public class imagen extends HttpServlet {
    
    void default_image(HttpServletResponse response) throws IOException {
        ServletContext context = getServletContext();
        IOUtils.copy(context.getResourceAsStream("/WEB-INF/spaceship.png"), response.getOutputStream());
    }

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
        request.setCharacterEncoding("UTF-8");
        String nick = request.getParameter("nick");

        String func = request.getParameter("funcion");
        int id_func = -1;
        if (func != null)
        {
            try {
                id_func = Integer.parseInt(func);
            } catch (NumberFormatException ex) {
                //
            }
        }

        String espectaculo = request.getParameter("espectaculo");
        int id_espec = -1;
        if (espectaculo != null)
        {
            try {
                id_espec = Integer.parseInt(espectaculo);
            } catch (NumberFormatException ex) {
                //
            }
        }

        String paquete = request.getParameter("paquete");
        
        response.setContentType(MediaType.ALL_VALUE);
        if (nick != null) {
            byte[] bytes = (GsonToUse.gson.fromJson(Sender.post("/users/obtener_imagen_usuario_con_nickname", new Object[] {nick} ), byte[].class));
            if (bytes != null)
                response.getOutputStream().write(bytes);
            else
                default_image(response);
        }
        else if ((GsonToUse.gson.fromJson(Sender.post("/espectaculos/existe_id_de_funcion", new Object[] {id_func} ), boolean.class))) {
            byte[] bytes = (GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_imagen_funcion", new Object[] {id_func} ), byte[].class));
            if (bytes != null)
                response.getOutputStream().write(bytes);
            else
                default_image(response);
        }
        else if ((GsonToUse.gson.fromJson(Sender.post("/espectaculos/existe_id_de_espectaculo", new Object[] {id_espec} ), boolean.class))) {
            byte[] bytes = (GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_imagen_espectaculo", new Object[] {id_espec} ), byte[].class));
            if (bytes != null)
                response.getOutputStream().write(bytes);
            else
                default_image(response);
        }
        else if ((GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_info_paquete", new Object[] {paquete} ), Paquete.class)) != null) {
            byte[] bytes = (GsonToUse.gson.fromJson(Sender.post("/espectaculos/obtener_imagen_paquete", new Object[] {paquete} ), byte[].class));
            if (bytes != null)
                response.getOutputStream().write(bytes);
            else
                default_image(response);
        }
        else
            default_image(response);

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
