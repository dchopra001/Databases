<%-- 
    Document   : friend_request
    Created on : 22-Mar-2015, 2:41:23 PM
    Author     : tjia
--%>

<%@page import = "java.util.ArrayList" %>
<%@page import = "DTO.FriendRequest" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Friend Requests</title>
    </head>
    <body>
        <h1>Friend Requests</h1>
           
        <%! ArrayList<FriendRequest> friendRequestList; %>
        <% friendRequestList = (ArrayList<FriendRequest>)request.getAttribute("friendRequestList"); %>
        <% if (friendRequestList != null) { %>
            <table border="1" style="width:75%">
                <tr>
                    <th> Alias </th>
                    <th> Email </th>
                </tr>
                <% for(FriendRequest friendRequest : friendRequestList ) { %>
                <tr> 
                    <td> <%= friendRequest.Alias %> </td>
                    <td> <%= friendRequest.Email %> </td>
                    <td> <a href="FriendProcessServlet?friendAlias=<%= friendRequest.Alias %>">Accept</a> </td>
                </tr>
                <% } %>
            </table>
        <% } else { %>
            <p> You have no Friend Requests..  :-:</p>
        <% } %>
                
        <br></br>
        <ul>
        <li><a href="LoginServlet">Return to Main Page</a></li>
        </ul>
    </body>
</html>
