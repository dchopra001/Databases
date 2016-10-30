<%-- 
    Document   : patient_serach_results
    Created on : 22-Mar-2015, 2:33:30 PM
    Author     : tjia
--%>
<%@page import = "java.util.ArrayList" %>
<%@page import = "DTO.DoctorResult" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Search Results</title>
    </head>
    <body>
        <h1>Doctor Search Results</h1>
        
        <%! ArrayList<DoctorResult> doctorResultList; %>
        <% doctorResultList = (ArrayList<DoctorResult>)request.getAttribute("doctorResultList"); %>
        <% if (doctorResultList != null) { %>
            <table border="1" style="width:75%">
                <tr>
                    <th> Name </th>
                    <th> Gender </th>
                    <th> Average Star Rating </th>
                    <th> # of Reviews </th>
                    <th> Profile </th>
                </tr>
                <% for(DoctorResult doctor : doctorResultList ) { %>
                <tr> 
                    <td> <%= doctor.Name.getFullName() %> </td>
                    <td> <%= doctor.Gender %> </td>
                    <td> <%= doctor.AvgStarRating %> </td>
                    <td> <%= doctor.NumReview %> </td>
                    <td> <a href="DoctorServlet?doctorAlias=<%= doctor.Alias %>">Profile</a> </td>
                </tr>
                <% } %>
            </table>  
        <% } else { %>
            <p> No doctors found.</p>
        <% } %>
        
        <br></br>
        <ul>
        <li><a href="DoctorPreSearch">Search Again</a></li>        
        <li><a href="LoginServlet">Return to Main Page</a></li>
        </ul>
    </body>
</html>
