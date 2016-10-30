/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Core;

import DTO.FriendRequest;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author tjia
 */
public class FriendProcessServlet extends HttpServlet {

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
               
                String userAlias = SessionAssert.getLoggedInUserAlias(request.getSession());

                String friendAlias = request.getParameter("friendAlias");

                if(userAlias.equals(friendAlias)){
                    url = "/LoginServlet";   
                }else {
                    DBAO dbao = DBAOSingleton.getInstance();
                    DBAO.FriendRequestResult friendRequestResult = dbao.patientRequestFriend(userAlias, friendAlias);
                    
                    String friendResultMessage = "";
                    if(friendRequestResult == DBAO.FriendRequestResult.AlreadyFriends){
                        friendResultMessage = "Already Friends!";
                    } else if(friendRequestResult == DBAO.FriendRequestResult.AlreadyRequested) {
                        friendResultMessage = "Already Requested!";
                    } else if(friendRequestResult == DBAO.FriendRequestResult.NewFriendshipFormed) {
                        friendResultMessage = "Friendship Accepted!";
                    } else if(friendRequestResult == DBAO.FriendRequestResult.NewRequestAdded) {
                        friendResultMessage = "Friendship Requested!";
                    }
                    
                    request.setAttribute("friendResultMessage", friendResultMessage);
                    url="/friend_result.jsp";
                }
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
