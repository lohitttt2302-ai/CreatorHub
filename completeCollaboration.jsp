<%@ page import="com.creatorhub.dao.CreditDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
Integer creator = (Integer) session.getAttribute("student_id");
if (creator == null || !"CREATOR".equalsIgnoreCase((String)session.getAttribute("role"))) {
    response.sendRedirect("login.jsp"); return;
}
String c0=request.getParameter("collab_id"), s0=request.getParameter("student_id"), p0=request.getParameter("points");
if(c0==null || s0==null || p0==null){response.sendRedirect("creatorDashboard.jsp?message=missing");return;}
boolean ok=false;
try{
    int collab=Integer.parseInt(c0), student=Integer.parseInt(s0), points=Integer.parseInt(p0);
    String note=request.getParameter("note");
    ok=new CreditDAO().complete(collab,creator,student,points,note);
}catch(Exception e){e.printStackTrace();}
response.sendRedirect("creatorDashboard.jsp?message="+(ok?"completed":"complete_failed"));
%>
