<%-- 
    Document   : search_patients
    Created on : 22-Mar-2015, 2:13:23 PM
    Author     : tjia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Patients</title>
    </head>
    <body>
        <h1>Patient Search</h1>
        
        <% 
        String errorMessage = (String)request.getAttribute("errorMessage");
        if(errorMessage != null){ %>
            <font color="red"><h2> <%= errorMessage %> </h2></font>
        <% } %>
        
        <p1>Enter search fields:</p1>
        <br/><br/>
        <form action="PatientSearchServlet" method="POST">
            Alias: <input type="text"
                         name="alias" value="" /><br>
            Province: <input type="text"
                         name="province" value="" /><br>
            City: <input type="text"
                         name="city" value="" /><br>
            <input type="submit" value="Search" />
        </form>
        <br/>
        
        
        <br></br>
        <ul>
        <li><a href="LoginServlet">Return to Main Page</a></li>
        </ul>
    </body>
</html>
