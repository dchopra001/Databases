/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Core;

import DTO.DoctorResult;
import DTO.Name;
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
public class DoctorSearchServlet extends HttpServlet {

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
             
            
            if (!SessionAssert.AssertUserType(request.getSession(), DBAO.UserType.Patient)){
                url = "/LoginServlet";                
            } else {
                //pull the login values from req and validate
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String gender = request.getParameter("gender");
                String province = request.getParameter("province");
                String city = request.getParameter("city");
                String street = request.getParameter("street");
                String streetNumber = request.getParameter("streetNumber");
                String apartmentNumber = request.getParameter("apartmentNumber");
                String postalCode = request.getParameter("postalCode");
                String specialization = request.getParameter("specialization");
                String strNumYearsLicensed = request.getParameter("numYearsLicensed");
                int numYearsLicensed = -1;

                if(!strNumYearsLicensed.isEmpty()){

                    numYearsLicensed = Integer.parseInt(strNumYearsLicensed);
                }
                String strAvgStarRating = request.getParameter("avgStarRating");
                double avgStarRating  = Double.parseDouble(strAvgStarRating);
                String strReviewByFriend = request.getParameter("reviewedByFriend");
                int reviewByFriend = strReviewByFriend == null ? -1 :Integer.parseInt(strReviewByFriend);
                String keyword = request.getParameter("keyword");


                DBAO dbao = DBAOSingleton.getInstance();


                String patientAlias = SessionAssert.getLoggedInUserAlias(request.getSession());
                ArrayList<DoctorResult> doctorResultList = dbao.searchDoctorProfile(
                        patientAlias, 
                        firstName, 
                        "", 
                        lastName, 
                        gender, 
                        province, 
                        city, 
                        street, 
                        streetNumber, 
                        apartmentNumber, 
                        postalCode, 
                        specialization, 
                        numYearsLicensed, 
                        avgStarRating, 
                        reviewByFriend, 
                        keyword
                    );
                
                
                request.setAttribute("doctorResultList", doctorResultList);
                url = "/doctor_search_results.jsp";
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
