<%@ page import="com.creatorhub.bean.Application" %>
<%@ page import="com.creatorhub.bean.Collaboration" %>
<%@ page import="com.creatorhub.dao.ApplicationDAO" %>
<%@ page import="com.creatorhub.dao.CollaborationDAO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
Integer id=(Integer)session.getAttribute("student_id");
if(id==null){response.sendRedirect("login.jsp");return;}
List<Application> apps=new ApplicationDAO().getApplicationsByStudent(id);
CollaborationDAO cd=new CollaborationDAO();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Applications · Creator Hub</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<%@ include file="sidebar.jsp" %>
<nav class="nav"><a class="brand" href="studentPortal.jsp">Creator Hub</a><div class="navlinks"><a href="collaborations.jsp">Discover</a><a href="leaderboard.jsp">Leaderboard</a><a href="profile.jsp?id=<%=id%>&role=STUDENT">Public profile</a><a href="logout.jsp" class="logout">Logout</a></div></nav>
<div class="container">
<section class="hero">
<span class="pill">MY APPLICATIONS</span>
<h1>Application tracker</h1>
<p>See every collaboration you applied for, its current status and what happens next.</p>
</section>

<div class="card topspace">
<%if(apps.isEmpty()){%>
<p class="muted">You haven't applied to any collaborations yet.</p>
<a class="btn" href="collaborations.jsp">Discover collaborations</a>
<%}else for(Application a:apps){
    Collaboration c=cd.getById(a.getCollabId());
    String status=a.getStatus()==null?"PENDING":a.getStatus();
    boolean completed=c!=null && "COMPLETED".equalsIgnoreCase(c.getStatus());
%>
<div class="work topspace">
<div class="leader">
<div class="grow">
<h3><%=c==null?"Collaboration":c.getTitle()%></h3>
<p class="small muted"><%=c==null?"":c.getCategory()%></p>
<p><%=a.getPitchText()%></p>
</div>
<span class="pill <%=completed||"ACCEPTED".equalsIgnoreCase(status)?"status":""%>"><%=status%></span>
</div>

<div class="actions">
<%if(c!=null){%>
<a class="btn secondary" href="collaborations.jsp">View collaborations</a>
<%if(completed){%>
<a class="btn" href="rateCreator.jsp?collab_id=<%=c.getCollabId()%>&creator_id=<%=c.getCreatorId()%>">Rate creator</a>
<%}%>
<%}%>
</div>
</div>
<%}%>
</div>
</div>
</body>
</html>
