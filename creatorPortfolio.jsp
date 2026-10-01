<%@ page import="com.creatorhub.bean.Student" %>
<%@ page import="com.creatorhub.bean.StudentWork" %>
<%@ page import="com.creatorhub.dao.StudentDAO" %>
<%@ page import="com.creatorhub.dao.WorkDAO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
if(!"CREATOR".equalsIgnoreCase((String)session.getAttribute("role"))){response.sendRedirect("login.jsp");return;}
Integer id=(Integer)session.getAttribute("student_id");
Student s=new StudentDAO().getById(id);
List<StudentWork> works=new WorkDAO().byStudent(id);
%>
<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>My Portfolio · Creator Hub</title><link rel="stylesheet" href="style.css"></head>
<body>
<%@ include file="sidebar.jsp" %>
<nav class="nav"><a class="brand" href="creatorDashboard.jsp">Creator Hub</a><div class="navlinks"><a href="logout.jsp" class="logout">Logout</a></div></nav>
<div class="container">
<section class="hero">
<span class="pill">CREATOR PORTFOLIO</span>
<h1>Showcase your previous work</h1>
<p>Give students a clear view of your skills and past projects before they apply to collaborate with you.</p>
<div class="actions"><a class="btn" href="uploadWork.jsp">+ Add previous work</a><a class="btn secondary" href="profile.jsp?id=<%=id%>&role=CREATOR">View public profile</a></div>
</section>
<div class="card topspace">
<h2><%=s==null?"My":s.getName()+"'s"%> portfolio</h2>
<p class="muted">These files are visible from your public creator profile.</p>
<%if(works.isEmpty()){%>
<div class="notice"><b>No previous work yet.</b><br>Add your first project to start building your portfolio.</div>
<div class="actions"><a class="btn" href="uploadWork.jsp">Upload first project</a></div>
<%}else for(StudentWork w:works){%>
<div class="work topspace">
<div class="leader">
<div class="grow"><b><%=w.getFileName()%></b><p class="small muted">Previous work · <%=w.getUploadedAt()==null?"":w.getUploadedAt()%></p></div>
<a class="btn secondary" href="downloadWork.jsp?id=<%=w.getWorkId()%>" target="_blank">View work ↗</a>
</div>
</div>
<%}%>
</div>
</div></body></html>