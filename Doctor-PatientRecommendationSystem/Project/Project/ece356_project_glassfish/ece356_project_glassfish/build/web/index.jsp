<%-- 
    Document   : Login Page
    Created on : 22-Mar-2015, 1:42:31 PM
    Author     : tjia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Welcome to ECE356!</title>
    </head>
    <body>
        
        <h1>Welcome to ECE356!</h1>
        
        <% 
            String errorMessage = (String)request.getAttribute("errorMessage");
            if(errorMessage != null){ %>
        <font color="red"><h2> <%= errorMessage %> </h2></font>
	<% } %>
        
        <p1>Enter login info:</p1>
        <br/><br/>
        <form action="LoginServlet" method="POST">
            Username: <input
                type="text"
                name="alias"
                value=""
                required/><br>
            Password: <input
                type="password"
                name="password"
                value=""
                required/><br>
            <input type="submit" value="Login" />
        </form>
        <br/>
        
        
        
    </body>
</html>