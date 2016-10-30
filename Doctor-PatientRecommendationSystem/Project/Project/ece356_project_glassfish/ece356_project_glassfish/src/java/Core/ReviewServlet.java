/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Core;

import Core.DBAO.UserType;
import DTO.Name;
import DTO.Review;
import java.io.IOException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author tjia
 */
public class ReviewServlet extends HttpServlet {

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
        
        
        
       String httpverb = request.getMethod();       
       try {
                 
            if(request.getMethod().equals("POST")){
                addReview(request, response);
            } else if (request.getMethod().equals("GET")) {
                getReview(request, response);
            }   else {            
                getServletContext().getRequestDispatcher("/LoginServlet").forward(request, response);
            }
       } catch(Exception e){
           request.setAttribute("exception", e);               
        
            getServletContext().getRequestDispatcher("/error.jsp").forward(request, response);
       }

       
        
    }
    
    private void addReview(HttpServletRequest request, HttpServletResponse response)
             throws ServletException, IOException, Exception {
        //pull request parameters out of request

        if(!SessionAssert.AssertUserType(request.getSession(), UserType.Patient)){
            //Go to login screen
            
             getServletContext().getRequestDispatcher("/LoginServlet").forward(request, response);
        } else {
            
            //Add Review
            
            String userAlias = SessionAssert.getLoggedInUserAlias(request.getSession());
            
            String docAlias = request.getParameter("doctorAlias");
            String strStarRating = request.getParameter("starRating");
            
            double starRating = Double.parseDouble(strStarRating);          
            String reviewText = request.getParameter("reviewText");
            if (reviewText.trim().equals("")){
                String url;
                url = "/LoginServlet";
                request.setAttribute("errorMessage", "Please don't input empty reviews.");
                
                getServletContext().getRequestDispatcher(url).forward(request, response);
            } else {
            
                        
                DBAO dbao = DBAOSingleton.getInstance();

                dbao.addReview(userAlias, docAlias, reviewText, starRating);

                getServletContext().getRequestDispatcher("/review_submitted.html").forward(request,response);
            }
            
        }
        
    }
    
    private void getReview(HttpServletRequest request, HttpServletResponse response)
             throws ServletException, IOException, Exception{
        
             String url;
             
             
             if(SessionAssert.AssertUserType(request.getSession(), UserType.Invalid)){
                 url = "/LoginServlet";
             
             } else {
        
                String strReviewId = request.getParameter("reviewId");
                int reviewId = Integer.parseInt(strReviewId);
                DBAO dbao = DBAOSingleton.getInstance();
                
                Review r = dbao.fetchFullReview(reviewId);
               
                if(SessionAssert.AssertUserType(request.getSession(), UserType.Doctor)){
                    
                     String docLoggedinAlias = SessionAssert.getLoggedInUserAlias(request.getSession());
                     
                     if(!docLoggedinAlias.equals(r.DoctorAlias)){
                         
                         url = "/LoginServlet";
                     } else {
                           request.setAttribute("reviewContent", r);

                            url = "/view_review.jsp";
                     }
                } else {
                             request.setAttribute("reviewContent", r);

                            url = "/view_review.jsp";
                }
              
          
             }
                   getServletContext().getRequestDispatcher(url).forward(request,response);
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
