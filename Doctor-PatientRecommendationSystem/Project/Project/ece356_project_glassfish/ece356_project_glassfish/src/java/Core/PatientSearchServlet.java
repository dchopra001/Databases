/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Core;

import DTO.ExtendedPatient;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author tjia
 */
public class PatientSearchServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String url;    
        try {
                if(!SessionAssert.AssertUserType(request.getSession(), DBAO.UserType.Patient)){
                    url = "/LoginServlet";
                
                } else {
    
                    String searcherAlias = SessionAssert.getLoggedInUserAlias(request.getSession());
                    
                    //pull the login values from req and validate
                    String alias = request.getParameter("alias") ;
                    String province = request.getParameter("province");
                    String city = request.getParameter("city");

                    alias = alias == null ? "" : alias;
                    province = province == null ? "" : province;
                    city = city == null ? "" : city;


                    DBAO dbao = DBAOSingleton.getInstance();
                    
                    ArrayList<ExtendedPatient> patientList = dbao.searchPatientProfile(alias, province, city, searcherAlias);


                    request.setAttribute("patientList", patientList);
                    url = "/patient_search_results.jsp";
                }   

        } catch(Exception e){           
            request.setAttribute("exception", e);
            url = "/error.jsp";
        }             
        
        getServletContext().getRequestDispatcher(url).forward(request, response);
          
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
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
     * Handles the HTTP
     * <code>POST</code> method.
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
