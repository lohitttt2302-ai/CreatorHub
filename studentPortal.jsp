<%@ page import="com.creatorhub.bean.Student" %>
<%@ page import="com.creatorhub.bean.Collaboration" %>
<%@ page import="com.creatorhub.dao.StudentDAO" %>
<%@ page import="com.creatorhub.dao.CollaborationDAO" %>
<%@ page import="com.creatorhub.dao.LikeDAO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
Integer id=(Integer)session.getAttribute("student_id");
if(id==null){response.sendRedirect("login.jsp");return;}
Student s=new StudentDAO().getById(id);
List<Collaboration> done=new CollaborationDAO().getCompletedForStudent(id);
int likes=new LikeDAO().countReceived(id,"STUDENT");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student Dashboard · Creator Hub</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<%@ include file="sidebar.jsp" %>
<nav class="nav"><a class="brand" href="studentPortal.jsp">Creator Hub</a><div class="navlinks"><a href="collaborations.jsp">Discover</a><a href="leaderboard.jsp">Leaderboard</a><a href="profile.jsp?id=<%=id%>&role=STUDENT">Public profile</a><a href="editProfile.jsp">Edit profile</a><a href="logout.jsp" class="logout">Logout</a></div></nav>

<div class="container">
<section class="hero">
<span class="pill">STUDENT DASHBOARD</span>
<h1>Welcome, <%=s==null?"Creator":s.getName()%></h1>
<p>Track your profile, reputation and completed collaborations from one place.</p>
<div class="actions">
<a class="btn" href="collaborations.jsp">Find collaborations</a>
<a class="btn secondary" href="uploadWork.jsp">+ Add portfolio work</a>
</div>
</section>

<div class="statgrid topspace">
<div class="stat"><span>Credits</span><b><%=s==null?0:s.getCredits()%></b></div>
<div class="stat"><span>Profile likes</span><b><%=likes%></b></div>
<div class="stat"><span>Completed</span><b><%=done.size()%></b></div>
</div>

<div class="grid topspace">
<div class="card">
<h2>Profile</h2>
<p><b><%=s==null?"":s.getName()%></b></p>
<p class="muted"><%=s==null?"":s.getBio()%></p>
<p><b>Skills:</b> <%=s==null?"":s.getSkills()%></p>
<%if(s!=null&&s.getLinkedinUrl()!=null&&!s.getLinkedinUrl().isEmpty()){%>
<a href="<%=s.getLinkedinUrl()%>" target="_blank" class="btn secondary">LinkedIn ↗</a>
<%}%>
</div>

<div class="card">
<h2>Quick access</h2>
<div class="actions">
<a class="btn secondary" href="applications.jsp">My Applications</a>
<a class="btn secondary" href="portfolio.jsp">My Portfolio</a>
<a class="btn secondary" href="profile.jsp?id=<%=id%>&role=STUDENT">My Profile</a>
</div>
</div>
</div>

<div class="card topspace">
<h2>Completed collaborations</h2>
<%if(done.isEmpty()){%>
<p class="muted">Complete your first collaboration to build your reputation.</p>
<%}else for(Collaboration c:done){%>
<div class="work">
<b><%=c.getTitle()%></b>
<p class="muted">Creator: <a href="profile.jsp?id=<%=c.getCreatorId()%>&role=CREATOR">View creator</a></p>
<a class="btn secondary" href="rateCreator.jsp?collab_id=<%=c.getCollabId()%>&creator_id=<%=c.getCreatorId()%>">Leave creator rating</a>
</div>
<%}%>
</div>
</div>
</body>
</html>
