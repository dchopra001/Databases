<%-- 
    Document   : add_review
    Created on : 24-Mar-2015, 1:32:14 PM
    Author     : tjia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Review</title>
    </head>
    <body>
        <h1>Add Review</h1>
       
        <form action="ReviewServlet" method="POST" id="addReviewForm">
             <input type="hidden" value="<%= request.getParameter("doctorAlias") %>" class="field left" name="doctorAlias" readonly>
                       
             Rating: <select size="1" name="starRating">               
                <option value="0">0</option>
                <option value="0.5">0.5</option>
                <option value="1">1</option>
                <option value="1.5">1.5</option>
                <option value="2">2</option>
                <option value="2.5">2.5</option>
                <option value="3">3</option>
                <option value="3.5">3.5</option>
                <option value="4">4</option>
                <option value="4.5">4.5</option>
                <option value="5">5</option>
                
            </select><br>            
             
        </form>
        <p>Comments:<p>
        <textarea rows="4" cols="50" name="reviewText" form="addReviewForm" required></textarea><br><br>
          <input type="submit" value="Submit Review" form="addReviewForm"/>
    </body>
</html>
