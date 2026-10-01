<%@ page import="com.creatorhub.bean.Student" %>
<%@ page import="com.creatorhub.bean.StudentWork" %>
<%@ page import="com.creatorhub.dao.StudentDAO" %>
<%@ page import="com.creatorhub.dao.WorkDAO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
Integer id=(Integer)session.getAttribute("student_id");
if(id==null){response.sendRedirect("login.jsp");return;}
Student s=new StudentDAO().getById(id);
List<StudentWork> works=new WorkDAO().byStudent(id);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Portfolio · Creator Hub</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<%@ include file="sidebar.jsp" %>
<nav class="nav"><a class="brand" href="studentPortal.jsp">Creator Hub</a><div class="navlinks"><a href="collaborations.jsp">Discover</a><a href="leaderboard.jsp">Leaderboard</a><a href="profile.jsp?id=<%=id%>&role=STUDENT">Public profile</a><a href="logout.jsp" class="logout">Logout</a></div></nav>
<div class="container">
<section class="hero">
<span class="pill">MY PORTFOLIO</span>
<h1>Previous work</h1>
<p>Show creators what you can do. Your portfolio is visible when you apply for collaborations.</p>
<div class="actions"><a class="btn" href="uploadWork.jsp">+ Add portfolio work</a></div>
</section>

<div class="card topspace">
<h2><%=s==null?"Your":s.getName()+"'s"%> portfolio</h2>
<%if(works.isEmpty()){%>
<p class="muted">You haven't uploaded any previous work yet.</p>
<a class="btn" href="uploadWork.jsp">Upload your first work</a>
<%}else for(StudentWork w:works){%>
<div class="work topspace">
<div class="leader">
<div class="grow"><b><%=w.getFileName()%></b><p class="small muted">Previous work</p></div>
<a class="btn secondary" href="downloadWork.jsp?id=<%=w.getWorkId()%>" target="_blank">View work ↗</a>
</div>
</div>
<%}%>
</div>
</div>
</body>
</html>
