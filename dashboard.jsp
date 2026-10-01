<%
String role=(String)session.getAttribute("role");
if(session.getAttribute("student_id")==null){response.sendRedirect("login.jsp");return;}
if("CREATOR".equalsIgnoreCase(role)) response.sendRedirect("creatorDashboard.jsp"); else response.sendRedirect("studentPortal.jsp");
%>