<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Redirect to HomeController servlet
    response.sendRedirect(request.getContextPath() + "/home");
%>