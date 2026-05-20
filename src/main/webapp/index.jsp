<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
  index.jsp — WELCOME / REDIRECT PAGE

  This is the first page Tomcat serves when a user hits the root URL:
  http://localhost:8080/code-snippet-manager/

  It immediately redirects to /snippets (the main list page).
  The 'c:redirect' tag sends a 302 HTTP redirect response to the browser.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:redirect url="/snippets"/>
