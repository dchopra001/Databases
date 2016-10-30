<%-- 
    Document   : patient_serach_results
    Created on : 22-Mar-2015, 2:33:30 PM
    Author     : tjia
--%>

<%@page import = "java.util.ArrayList" %>
<%@page import = "DTO.ExtendedPatient" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Patient Search Results</title>
    </head>    
  
    <body>
        <h1>Patient Search Results</h1>
        
        <%! ArrayList<ExtendedPatient> patientList; %>
        <% patientList = (ArrayList<ExtendedPatient>)request.getAttribute("patientList"); %>
        
        <% if (patientList != null) { %>
            <table border="1" style="width:75%">
                <tr>
                    <th> Alias </th>
                    <th> Home Address </th>
                    <th> # of Reviews </th>
                    <th> Date of Last Review </th>
                    <th> Friend Status </th>
                </tr>
                <% for(ExtendedPatient patient : patientList ) { %>
                <tr> 
                    <td> <%= patient.Alias %> </td>
                    <td> <%= patient.HomeAddress %> </td> 
                    <td> <%= patient.NumReviews %> </td>
                    <td> <%= patient.DateLastReview %> </td>
                    <td>
                        <% if (patient.IsFriend == 0) { %>
                            <a href="FriendProcessServlet?friendAlias=<%= patient.Alias %>">Add Friend</a>
                        <% } else { %>
                            FRIEND!
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </table>  
        <% } else { %>
            <p> No patients found.</p>
        <% } %>
        
        
        <br></br>
        <ul>
        <li><a href="patient_search.jsp">Search Again</a></li>        
        <li><a href="LoginServlet">Return to Main Page</a></li>
        </ul>
        
    </body>
</html>