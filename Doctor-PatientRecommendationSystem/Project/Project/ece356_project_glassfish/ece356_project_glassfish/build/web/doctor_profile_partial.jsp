<%-- 
    Document   : doctor_profile
    Created on : 22-Mar-2015, 2:14:46 PM
    Author     : tjia
--%>

<%@page import = "java.util.ArrayList" %>
<%@page import = "DTO.DoctorProfileFull" %>
<%@page import = "DTO.Doctor" %>
<%@page import = "DTO.WorkAddress" %>
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
        <h1>Profile Info</h1>

        <%! DoctorProfileFull doctorProfileFull; %>
        <% doctorProfileFull = (DoctorProfileFull)request.getAttribute("doctorProfilePartial"); %>
        
    
     
        <% Doctor doctor = doctorProfileFull.Doctor; %>
        <% if (doctor != null) { %>
            <table border="1" style="width:75%">
                <tr>
                    <th> Name </th>
                    <th> Gender </th>
                    <th> Work Address </th>
                    <th> Specialization </th>
                    <th> # of Years Licensed </th>
                    <th> Average Star Rating </th>
                    <th> # of Reviews </th>
                </tr>
                <tr> 
                    <td> <%= doctor.Name.FirstName %>&nbsp;
                         <%= doctor.Name.MiddleName %>&nbsp;
                         <%= doctor.Name.LastName %></td>
                    <td> <%= doctor.Gender %> </td>
                    <td>
                        <% for(WorkAddress workAddress : doctor.WorkAddressList) { %>
                            <%= workAddress.StreetNumber %>&nbsp;
                            <%= workAddress.StreetName %>,&nbsp;
                            <%= workAddress.AptNumber %>,&nbsp;
                            <%= workAddress.City %>,&nbsp;
                            <%= workAddress.Province %>,&nbsp;
                            <%= workAddress.PostalCode %>
                            <br>
                        <% } %>
                    </td>
                    <td>
                        <% for(String specialization : doctor.SpecializationList) { %>
                            <%= specialization %>
                            <br>
                        <% } %>
                    </td>
                    <td> <%= doctor.NumYearsLicensed %> </td>
                    <td> <%= doctor.AvgStarRating %> </td>
                    <td> <%= doctor.NumReview %> </td>
                </tr>
            </table>
        <% } else { %>
            <p> You have no profile info..</p>
        <% } %>
        
        <br></br>
        <br></br>
        <%! ArrayList<Integer> reviewIDList; %>
        <% reviewIDList = doctorProfileFull.ReviewIDList; %>
        
        <h2> Reviews</h2>
        <% int reviewId_Count = 1; %>
        <% if (reviewIDList != null) { %>
        <ul>
                <% for(Integer reviewID : reviewIDList) { %>
                                    <li> <a href="ReviewServlet?reviewId=<%= reviewID %>">View Review <%= reviewId_Count++ %></a> </li>
                        <% } %>
            </ul>
        <% } else { %>
            <p> Not been reviewed yet.. ;-;</p>
        <% } %>
        
        <br></br>
        <li><a href="add_review.jsp?doctorAlias=<%= doctor.Alias %>">Write Review</a> </li>

        <br></br>
        <li><a href="LoginServlet">Return to Main Page</a></li>
    </body>
</html>