/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package Core;

import Core.DBAO.UserType;
import DTO.Review;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



/**
 *
 * @author tjia
 */
public class LoginServlet extends HttpServlet {

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
                String loggedinAlias = SessionAssert.getLoggedInUserAlias(request.getSession());
                if(loggedinAlias != null){
                    UserType userType = SessionAssert.getLoggedInUserType(request.getSession());
                    url = RedirectByType(userType, request, loggedinAlias );
                    
                } else {
                    
                    //pull the login values from req and validate
                    String alias = request.getParameter("alias");
                    String password = request.getParameter("password");
                    
                    if(alias == null || password == null){
                        url = "/index.jsp";
                        request.setAttribute("errorMessage", "Invalid Login Credentials. Try Again");
                        
                    } else {
                    
                    
                        UserType  userType = DBAOSingleton.getInstance().validateLogin(alias, password);

                         //Cache succesful login to session
                        if(userType != UserType.Invalid){
                            SessionAssert.SetLoggedInSession(request.getSession(), alias, userType);
                        }                


                        url = RedirectByType(userType, request, alias);                    

                    }
                    
                }


        } catch(Exception e){           
            request.setAttribute("exception", e);
            url = "/error.jsp";
        }             
        
        getServletContext().getRequestDispatcher(url).forward(request, response);
          
        
      
    }
    
    private String RedirectByType(UserType userType, HttpServletRequest request, String alias){
        String url ="";
        if (userType.equals(UserType.Patient)){
            request.setAttribute("alias", alias);
            url = "/patient_land.jsp";
        }
        else if (userType.equals(UserType.Doctor)){
            request.setAttribute("alias", alias);
            url = "/doctor_land.jsp";
        }
        else{
            // Bad login
            request.setAttribute("errorMessage", "ERROR: Incorrect Login Credentials");
            url = "/index.jsp";  
        }
        
        return url;
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
