<%-- 
    Document   : friend_result
    Created on : 24-Mar-2015, 5:04:23 PM
    Author     : tjia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Friend Result</title>
    </head>
    <body>
        <h1><%= request.getAttribute("friendResultMessage") %></h1>
        
        
        <br></br>
        <ul>
        <li><a href="LoginServlet">Return to Main Page</a></li>
        </ul>
    </body>
</html>
