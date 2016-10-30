<%-- 
    Document   : patient_land
    Created on : 22-Mar-2015, 1:56:10 PM
    Author     : tjia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Patient Land</title>
    </head>
  <body>
      
              
        <% 
            String errorMessage = (String)request.getAttribute("errorMessage");
            if(errorMessage != null){ %>
        <font color="red"><h2> <%= errorMessage %> </h2></font>
	<% } %>      
      
        <% String alias; %>
        <% alias = (String) request.getAttribute("alias"); %>
        
        <h1>Welcome <%= alias %>!</h1>
        <br></br>
      
        <h2>Please select one of the following:</h2>
        <ul>
        <li><a href="patient_search.jsp">Search Patients</a></li>        
        <li><a href="FriendRequestServet">View Friend Requests</a></li>
        <li><a href="DoctorPreSearch">Search Doctors</a></li>
        <br></br>
        <li><a href="LogOutServlet">Logout</a></li>
        </ul>
    </body>
</html>
