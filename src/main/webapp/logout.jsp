<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session.invalidate(); // destroys session
    response.sendRedirect("index.jsp"); // redirect to homepage
%>
