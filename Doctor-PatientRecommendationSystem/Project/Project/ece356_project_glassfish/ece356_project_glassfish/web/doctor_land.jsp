<%-- 
    Document   : doctor_profile
    Created on : 22-Mar-2015, 2:14:46 PM
    Author     : tjia
--%>

<%@page import = "java.util.ArrayList" %>
<%@page import = "DTO.Review" %>
<%@page import = "Misc.ViewHelper" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Profile</title>
    </head>
    <body>
        
        <% String alias; %>
        <% alias = (String) request.getAttribute("alias"); %>
        
        <h1>Welcome <%= alias %>!</h1>
        <br></br>
           
        <li><a href="DoctorServlet">View Profile</a></li>
        
        <br></br>
        <li><a href="LogOutServlet">Logout</a></li>
    </body>
</html>
