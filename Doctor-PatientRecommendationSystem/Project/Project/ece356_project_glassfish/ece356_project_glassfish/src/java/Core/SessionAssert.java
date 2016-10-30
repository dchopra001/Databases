/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Core;

import Core.DBAO.UserType;
import javax.servlet.http.HttpSession;

/**
 *
 * @author tjia
 */
public class SessionAssert {
    
    private static final String SESSION_ALIAS = "sessionAlias";
    private static final String SESSION_USERTYPE = "sessionUserType";
    
    public static boolean AssertUserType(HttpSession session, UserType userType){
        
        UserType sessionUserType = (UserType)session.getAttribute(SESSION_USERTYPE);
        return sessionUserType == userType;
    }
     public static boolean AssertUser(HttpSession session, String alias){
        
        String sessionAlias = (String)session.getAttribute(SESSION_ALIAS);
        return sessionAlias.equals(alias);
    }
     
    public static void SetLoggedInSession(HttpSession session, String alias, UserType userType){
        session.setAttribute(SESSION_ALIAS, alias);
        session.setAttribute(SESSION_USERTYPE, userType);        
    }
    
    public static String getLoggedInUserAlias(HttpSession session){
        String sessionAlias = (String)session.getAttribute(SESSION_ALIAS);
        return sessionAlias;
    }
    public static UserType getLoggedInUserType(HttpSession session){
        UserType sessionUserType = (UserType)session.getAttribute(SESSION_USERTYPE);
        return sessionUserType;
    }
    
    public static void Logout(HttpSession session){
        session.setAttribute(SESSION_ALIAS, null);
        session.setAttribute(SESSION_USERTYPE, null);        
    }
}
