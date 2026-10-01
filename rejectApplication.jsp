<%@ page import="com.creatorhub.dao.ApplicationDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
Integer creatorId = (Integer) session.getAttribute("student_id");
if (creatorId == null || !"CREATOR".equalsIgnoreCase((String)session.getAttribute("role"))) {
    response.sendRedirect("login.jsp"); return;
}
String value = request.getParameter("application_id");
if (value == null) { response.sendRedirect("creatorDashboard.jsp"); return; }
boolean ok = false;
try { ok = new ApplicationDAO().rejectApplication(Integer.parseInt(value), creatorId); }
catch (Exception ignored) {}
response.sendRedirect("creatorDashboard.jsp" + (ok ? "?message=rejected" : "?message=reject_failed"));
%>
