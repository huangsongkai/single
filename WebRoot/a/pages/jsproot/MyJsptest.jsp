<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page language="java" import="java.util.regex.*"%>
<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc"/>
<jsp:useBean id="server" scope="page" class="service.dao.db.Page"/>