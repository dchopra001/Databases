<%-- 
    Document   : view_review
    Created on : 24-Mar-2015, 2:27:48 PM
    Author     : tjia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "DTO.Review" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Review</title>
    </head>
    <body>
        <h1>Review</h1>
        
        <%! Review review; %>
        <% review = (Review)request.getAttribute("reviewContent"); %>
        <p>
            Doctor Name: <%= review.DoctorName.getFullName() %><br></br>
            Date: <%= review.ReviewDate %><br></br>
            Star Rating:<%= review.StarRating %><br></br>
            <br></br>
            Comments:<br></br><%= review.Comments %><br></br>
                        
        <br></br>
        </p>
        <% if(review.PrevId > 0){ %>
            <a href="ReviewServlet?reviewId=<%= review.PrevId %>">PREV</a>
        <% } else { %>
        <p>PREV</p>
        <% } %>
        <p>|</p>
          <% if(review.NextId > 0){ %>
            <a href="ReviewServlet?reviewId=<%= review.NextId %>">NEXT</a>
        <% } else { %>
        <p>NEXT</p>
        <% } %>
        
        <br></br>
        <a href="DoctorServlet?doctorAlias=<%= review.DoctorAlias%>">Back to Doctor Profile </a>
    </body>
</html>
