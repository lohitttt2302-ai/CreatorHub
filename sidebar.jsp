<%
String sidebarRole=(String)session.getAttribute("role");
String sidebarPage=request.getServletPath();
if(sidebarRole==null){response.sendRedirect("login.jsp");return;}
%>
<aside class="ch-sidebar" id="chSidebar">
    <div class="ch-sidebar-head">
        <a class="ch-brand" href="<%= "CREATOR".equalsIgnoreCase(sidebarRole)?"creatorDashboard.jsp":"studentPortal.jsp" %>">
            <span class="ch-brand-text">Creator Hub</span>
        </a>
        <button class="ch-sidebar-toggle" id="chSidebarToggle" type="button" aria-label="Toggle sidebar">&#8249;</button>
    </div>

    <nav class="ch-nav">
        <% if("CREATOR".equalsIgnoreCase(sidebarRole)){ %>
            <div class="ch-nav-label">CREATOR</div>
            <a class="ch-nav-item <%=sidebarPage.endsWith("creatorDashboard.jsp")?"active":""%>" href="creatorDashboard.jsp" title="Dashboard">
                <span class="ch-nav-text">Dashboard</span>
            </a>
            <a class="ch-nav-item <%=sidebarPage.endsWith("createCollaboration.jsp")?"active":""%>" href="createCollaboration.jsp" title="Create Collaboration">
                <span class="ch-nav-text">Create Collaboration</span>
            </a>
            <a class="ch-nav-item" href="creatorDashboard.jsp#collaborations" title="My Collaborations">
                <span class="ch-nav-text">My Collaborations</span>
            </a>
            <a class="ch-nav-item" href="creatorDashboard.jsp#applicants" title="Applicants">
                <span class="ch-nav-text">Applicants</span>
            </a>
            <a class="ch-nav-item <%=sidebarPage.endsWith("creatorPortfolio.jsp")?"active":""%>" href="creatorPortfolio.jsp" title="My Portfolio">
                <span class="ch-nav-text">My Portfolio</span>
            </a>
            <a class="ch-nav-item" href="profile.jsp?id=<%=session.getAttribute("student_id")%>&role=CREATOR" title="My Profile">
                <span class="ch-nav-text">My Profile</span>
            </a>
            <a class="ch-nav-item <%=sidebarPage.endsWith("leaderboard.jsp")?"active":""%>" href="leaderboard.jsp" title="Leaderboard">
                <span class="ch-nav-text">Leaderboard</span>
            </a>
            <a class="ch-nav-item" href="profile.jsp?id=<%=session.getAttribute("student_id")%>&role=CREATOR#reputation" title="My Reputation">
                <span class="ch-nav-text">My Reputation</span>
            </a>
        <% } else { %>
            <div class="ch-nav-label">STUDENT</div>
            <a class="ch-nav-item <%=sidebarPage.endsWith("studentPortal.jsp")?"active":""%>" href="studentPortal.jsp" title="Dashboard">
                <span class="ch-nav-text">Dashboard</span>
            </a>
            <a class="ch-nav-item <%=sidebarPage.endsWith("collaborations.jsp")?"active":""%>" href="collaborations.jsp" title="Discover Collaborations">
                <span class="ch-nav-text">Discover Collaborations</span>
            </a>
            <a class="ch-nav-item" href="applications.jsp" title="My Applications">
                <span class="ch-nav-text">My Applications</span>
            </a>
            <a class="ch-nav-item <%=sidebarPage.endsWith("creators.jsp")?"active":""%>" href="creators.jsp" title="Creators">
                <span class="ch-nav-text">Creators</span>
            </a>
            <a class="ch-nav-item" href="portfolio.jsp" title="My Portfolio">
                <span class="ch-nav-text">My Portfolio</span>
            </a>
            <a class="ch-nav-item" href="profile.jsp?id=<%=session.getAttribute("student_id")%>&role=STUDENT" title="My Profile">
                <span class="ch-nav-text">My Profile</span>
            </a>
            <a class="ch-nav-item <%=sidebarPage.endsWith("leaderboard.jsp")?"active":""%>" href="leaderboard.jsp" title="Leaderboard">
                <span class="ch-nav-text">Leaderboard</span>
            </a>
            <a class="ch-nav-item" href="profile.jsp?id=<%=session.getAttribute("student_id")%>&role=STUDENT#reputation" title="My Reputation">
                <span class="ch-nav-text">My Reputation</span>
            </a>
        <% } %>
    </nav>

    <div class="ch-sidebar-bottom">
        <a class="ch-nav-item ch-logout" href="logout.jsp" title="Logout">
            <span class="ch-nav-text">Logout</span>
        </a>
    </div>
</aside>
<div class="ch-sidebar-backdrop" id="chSidebarBackdrop"></div>

<script>
(function(){
    const s=document.getElementById('chSidebar');
    const b=document.getElementById('chSidebarToggle');
    const back=document.getElementById('chSidebarBackdrop');
    if(!s||!b)return;
    const k='creatorHubSidebarCollapsed';
    function state(c){
        document.body.classList.toggle('ch-sidebar-collapsed',c);
        b.textContent=c?'›':'‹';
        b.title=c?'Expand sidebar':'Collapse sidebar';
    }
    state(localStorage.getItem(k)==='1');
    b.onclick=()=>{
        const c=!document.body.classList.contains('ch-sidebar-collapsed');
        state(c);
        localStorage.setItem(k,c?'1':'0');
    };
    if(back)back.onclick=()=>document.body.classList.remove('ch-mobile-sidebar-open');
    document.querySelectorAll('.ch-nav-item').forEach(x=>x.onclick=()=>{
        if(innerWidth<=760)document.body.classList.remove('ch-mobile-sidebar-open');
    });
})();
</script>
