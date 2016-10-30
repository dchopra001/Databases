<%-- 
    Document   : search_doctors
    Created on : 22-Mar-2015, 2:13:40 PM
    Author     : tjia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.util.ArrayList" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Doctors</title>
    </head>
    <body>
        <h1>Doctor Search</h1>
        
        <% 
        String errorMessage = (String)request.getAttribute("errorMessage");
        if(errorMessage != null){ %>
            <font color="red"><h2> <%= errorMessage %> </h2></font>
        <% } %>
        
        <% ArrayList<String> specializationList = (ArrayList<String>)request.getAttribute("specializationList"); %>
        
        <p1>Enter search fields:</p1>
        <br/><br/>
        <form action="DoctorSearchServlet" method="POST">
            
            First Name: <input type="text" name="firstName" value="" />
            <br>
            Last Name: <input type="text" name="lastName" value="" />
            <br>
            Gender: <select size="1" name="gender">
                <option value ="">-</option>
                <option value ="male">Male</option>
                <option value ="female">Female</option>
            </select>
            <br>
            Work Address: <br>
            &nbsp;&nbsp;&nbsp;&nbsp;Province: <input type="text" name="province" value="" />
            <br>
            &nbsp;&nbsp;&nbsp;&nbsp;City: <input type="text" name="city" value="" />
            <br>
            &nbsp;&nbsp;&nbsp;&nbsp;Street: <input type="text" name="street" value="" />
            <br>
            &nbsp;&nbsp;&nbsp;&nbsp;Street # <input type="text" name="streetNumber" value="" />
            <br>
            &nbsp;&nbsp;&nbsp;&nbsp;Apartment #: <input type="text" name="apartmentNumber" value="" />
            <br>
            &nbsp;&nbsp;&nbsp;&nbsp;Postal Code: <input type="text" name="postalCode" value="" />
            <br>
            Specialization: <select size="1" name="specialization">
                <option value="">-</option>
                <% for (String s: specializationList){ %>
                    <option value="<%= s %>"><%= s %></option>
                <%}%>
            </select>
            <br>
            Number of Years Licensed Greater than or Equal to: <input type="number" name="numYearsLicensed" value="" />
            <br>
            Minimal Average Rating Greater Than: <select size="1" name="avgStarRating">
                    <option value="-1">-</option>                        
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
            </select>
            <br>
            If Reviewed by Friend: <select size="1" name="reviewedByFriend">
                <option value="-1">-</option>
                <option value="1">Yes</option>                
            </select>
            <br>
            Review Keyword (case sensitive): <input type="text" name="keyword" value="" />
            <br>
            
            <br/><br/>
            <input type="submit" value="Search" />
        </form>
        <br/>
        
        
        <br></br>
        <ul>
        <li><a href="LoginServlet">Return to Main Page</a></li>
        </ul>
    </body>
</html>
