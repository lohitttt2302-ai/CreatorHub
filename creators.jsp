<%@ page import="com.creatorhub.bean.Student" %>
<%@ page import="com.creatorhub.dao.StudentDAO" %>
<%@ page import="com.creatorhub.dao.LikeDAO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
Integer me=(Integer)session.getAttribute("student_id");
if(me==null){response.sendRedirect("login.jsp");return;}
List<Student> creators=new StudentDAO().getCreators();
LikeDAO likeDAO=new LikeDAO();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Creators · Creator Hub</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .creator-card{display:flex;flex-direction:column;gap:18px;height:100%;}
        .creator-top{display:flex;align-items:flex-start;gap:15px;}
        .creator-info{flex:1;min-width:0;}
        .creator-name{font-size:22px;font-weight:850;margin:0 0 4px;}
        .creator-bio{margin:8px 0 0;color:var(--muted);display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;overflow:hidden;}
        .creator-stats{display:flex;gap:12px;flex-wrap:wrap;}
        .creator-stat{padding:8px 12px;border-radius:10px;background:#f7f8fc;border:1px solid var(--line);font-size:13px;font-weight:750;}
        .creator-actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:auto;}
        .like-btn{min-width:115px;text-align:center;}
        .like-btn.liked{background:#fff0f2;color:#d84d62;border:1px solid #ffd1d8;}
        .empty-creators{padding:45px;text-align:center;}
    </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>
<nav class="nav">
    <a class="brand" href="studentPortal.jsp">Creator Hub</a>
    <div class="navlinks"><a href="logout.jsp" class="logout">Logout</a></div>
</nav>

<div class="container">
    <div class="hero">
        <span class="pill">CREATOR DISCOVERY</span>
        <h1>Discover Creators</h1>
        <p>Explore creator profiles, previous work, reputation and collaborations. Like creators whose work you want to support.</p>
    </div>

    <div class="grid topspace">
    <% if(creators.isEmpty()) { %>
        <div class="card empty-creators">
            <h2>No creators yet</h2>
            <p class="muted">Creator profiles will appear here when creators join the platform.</p>
        </div>
    <% } else { for(Student creator:creators){
        boolean liked=likeDAO.hasLiked(me,creator.getStudentId(),"CREATOR");
        int likes=likeDAO.countReceived(creator.getStudentId(),"CREATOR");
        String initial=creator.getName()==null||creator.getName().isEmpty()?"C":creator.getName().substring(0,1).toUpperCase();
    %>
        <div class="card creator-card">
            <div class="creator-top">
                <div class="avatar"><%=initial%></div>
                <div class="creator-info">
                    <h2 class="creator-name"><%=creator.getName()%></h2>
                    <span class="pill">CREATOR</span>
                    <p class="creator-bio"><%=creator.getBio()==null||creator.getBio().isEmpty()?"Creator profile — view their skills and previous work.":creator.getBio()%></p>
                </div>
            </div>

            <div class="creator-stats">
                <span class="creator-stat"><%=likes%> likes</span>
                <span class="creator-stat"><%=creator.getSkills()==null||creator.getSkills().isEmpty()?"Skills not listed":creator.getSkills()%></span>
            </div>

            <div class="creator-actions">
                <a class="btn secondary" href="profile.jsp?id=<%=creator.getStudentId()%>&role=CREATOR">View Profile</a>
                <a class="btn like-btn <%=liked?"liked":""%>" href="likeProfile.jsp?target_id=<%=creator.getStudentId()%>&target_role=CREATOR&back=creators.jsp">
                    <%=liked?"Liked":"Like Creator"%>
                </a>
            </div>
        </div>
    <% }} %>
    </div>
</div>
</body>
</html>
