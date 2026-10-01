<%@ page import="com.creatorhub.bean.Collaboration" %><%@ page import="com.creatorhub.bean.Student" %><%@ page import="com.creatorhub.dao.CollaborationDAO" %><%@ page import="com.creatorhub.dao.VoteDAO" %><%@ page import="com.creatorhub.dao.StudentDAO" %><%@ page import="java.util.List" %><%@ page contentType="text/html;charset=UTF-8" %>
<%
if(session.getAttribute("student_id")==null){response.sendRedirect("login.jsp");return;}
List<Collaboration> list=new CollaborationDAO().getAllCollaborations(); VoteDAO vd=new VoteDAO(); StudentDAO sd=new StudentDAO(); String cat=request.getParameter("category");
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Discover · Creator Hub</title><link rel="stylesheet" href="style.css"></head><body>
<%@ include file="sidebar.jsp" %>
<nav class="nav"><a class="brand" href="dashboard.jsp">Creator Hub</a><div class="navlinks"><a href="studentPortal.jsp">My Portal</a><a href="leaderboard.jsp">Leaderboards</a><a href="logout.jsp" class="logout">Logout</a></div></nav>
<div class="container"><div class="hero"><span class="pill">DISCOVER</span><h1>Find your next collaboration.</h1><p>Explore open opportunities, check the creator profile and apply with your best work.</p></div>
<div class="card topspace"><form method="get"><div class="row"><div><label>Category</label><select name="category"><option value="">All categories</option><%for(String x:new String[]{"Video Editing","Podcast","Photography","Design","Music","Writing"}){%><option <%=x.equals(cat)?"selected":""%>><%=x%></option><%}%></select></div><div style="display:flex;align-items:end"><button class="btn" type="submit">Filter opportunities</button></div></div></form></div>
<div class="grid topspace">
<%boolean found=false;for(Collaboration c:list){if(cat!=null&&!cat.isEmpty()&&!cat.equals(c.getCategory()))continue;found=true;Student creator=sd.getById(c.getCreatorId());%>
<div class="card"><div class="pill"><%=c.getCategory()%></div><h2><%=c.getTitle()%></h2><p class="muted"><%=c.getDescription()%></p><span class="pill status"><%=c.getStatus()%></span>
<p class="small">Created by <a href="profile.jsp?id=<%=c.getCreatorId()%>&role=CREATOR"><b><%=creator==null?"Creator":creator.getName()%></b></a></p>
<div class="statgrid"><div class="stat"><span>👍</span><b><%=vd.getVoteCount(c.getCollabId())%></b><span class="small muted">upvotes</span></div></div>
<div class="actions"><a class="btn" href="apply.jsp?collab_id=<%=c.getCollabId()%>">Apply now</a><form action="vote.jsp" method="post"><input type="hidden" name="collab_id" value="<%=c.getCollabId()%>"><button class="btn secondary" type="submit">👍 Upvote</button></form><a class="btn secondary" href="profile.jsp?id=<%=c.getCreatorId()%>&role=CREATOR">View creator</a></div></div>
<%}if(!found){%><div class="card"><h2>No opportunities found.</h2></div><%}%>
</div></div></body></html>