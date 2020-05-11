<%@ page import="v1.grade.GradeExcelUtil2" %>
<%--
  Created by IntelliJ IDEA.
  User: Yu-hsin Wang
  Date: 2019/7/24
  Time: 9:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="application/vnd.ms-excel" language="java" pageEncoding="UTF-8" %>
<%
    String exam_plan_id = request.getParameter("exam_plan_id");
    int id = Integer.parseInt(exam_plan_id);

    GradeExcelUtil2.expExcel(id, request, response);

%>
