<%@ page import="com.creatorhub.bean.Collaboration" %>
<%@ page import="com.creatorhub.bean.Application" %>
<%@ page import="com.creatorhub.bean.Student" %>
<%@ page import="com.creatorhub.dao.CollaborationDAO" %>
<%@ page import="com.creatorhub.dao.ApplicationDAO" %>
<%@ page import="com.creatorhub.dao.VoteDAO" %>
<%@ page import="com.creatorhub.dao.StudentDAO" %>
<%@ page import="com.creatorhub.dao.LikeDAO" %>
<%@ page import="com.creatorhub.dao.RatingDAO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
if(!"CREATOR".equalsIgnoreCase((String)session.getAttribute("role"))){response.sendRedirect("login.jsp");return;}
Integer id=(Integer)session.getAttribute("student_id");
String name=(String)session.getAttribute("student_name");
List<Collaboration> cs=new CollaborationDAO().getCollaborationsByCreator(id);
LikeDAO ld=new LikeDAO(); int likes=ld.countReceived(id,"CREATOR");
double rating=new RatingDAO().avg(id);
String message=request.getParameter("message");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Creator Dashboard · Creator Hub</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<%@ include file="sidebar.jsp" %>
<nav class="nav"><a class="brand" href="creatorDashboard.jsp">Creator Hub</a><div class="navlinks"><a href="createCollaboration.jsp">+ Create</a><a href="profile.jsp?id=<%=id%>&role=CREATOR">My profile</a><a href="leaderboard.jsp">Leaderboard</a><a href="logout.jsp" class="logout">Logout</a></div></nav>

<div class="container">
<section class="hero">
<span class="pill">CREATOR DASHBOARD</span>
<h1>Welcome, <%=name%></h1>
<p>Review applicants, select a collaborator, complete the work and transfer credits.</p>
<div class="statgrid">
<div class="stat"><span>Profile likes</span><b><%=likes%></b></div>
<div class="stat"><span>Rating</span><b><%=String.format("%.1f",rating)%></b></div>
<div class="stat"><span>Opportunities</span><b><%=cs.size()%></b></div>
</div>
</section>

<% if(message!=null){ %>
<div class="notice success topspace">
<% if("accepted".equals(message)){ %>Applicant accepted. The collaboration is now in progress.<% } %>
<% if("rejected".equals(message)){ %>Applicant rejected.<% } %>
<% if("completed".equals(message)){ %>Collaboration completed and credits transferred to the selected student. The student can now rate you.<% } %>
<% if(message.endsWith("failed")){ %>That action could not be completed. The collaboration may already have changed state.<% } %>
</div>
<% } %>

<div class="actions topspace"><a class="btn" href="createCollaboration.jsp">+ New collaboration</a><a class="btn secondary" href="profile.jsp?id=<%=id%>&role=CREATOR">View public profile</a></div>

<%for(Collaboration c:cs){
    List<Application> apps=new ApplicationDAO().getApplicantsByCollaboration(c.getCollabId());
    boolean inProgress="IN_PROGRESS".equalsIgnoreCase(c.getStatus());
    boolean completed="COMPLETED".equalsIgnoreCase(c.getStatus());
%>
<div class="card topspace" id="collaboration-<%=c.getCollabId()%>">
<div class="leader">
<div class="grow"><span class="pill"><%=c.getCategory()%></span><h2><%=c.getTitle()%></h2><p class="muted"><%=c.getDescription()%></p></div>
<span class="pill <%=completed?"status":""%>"><%=c.getStatus()%></span>
</div>

<div class="statgrid topspace">
<div class="stat"><b><%=new VoteDAO().getVoteCount(c.getCollabId())%></b><span class="small muted">upvotes</span></div>
<div class="stat"><b><%=apps.size()%></b><span class="small muted">applicants</span></div>
<div class="stat"><b><%=c.getSelectedApplicantId()>0?"1":"0"%></b><span class="small muted">selected student</span></div>
</div>

<h3 class="topspace" id="applicants">Applicants</h3>
<%if(apps.isEmpty()){%>
<p class="muted">No applications yet.</p>
<%}else for(Application a:apps){
    Student st=new StudentDAO().getById(a.getApplicantId());
    boolean accepted="ACCEPTED".equalsIgnoreCase(a.getStatus());
    boolean pending="PENDING".equalsIgnoreCase(a.getStatus());
    boolean selected=c.getSelectedApplicantId()==a.getApplicantId();
    String formId="acceptForm"+a.getApplicationId();
    String rejectFormId="rejectForm"+a.getApplicationId();
%>
<div class="work">
<div class="leader">
<div class="avatar"><%=st==null?"?":st.getName().substring(0,1).toUpperCase()%></div>
<div class="grow">
<a href="profile.jsp?id=<%=a.getApplicantId()%>&role=STUDENT"><b><%=st==null?"Student":st.getName()%></b></a>
<p class="small muted"><%=a.getPitchText()%></p>
<%if(a.getLinkedinUrl()!=null&&!a.getLinkedinUrl().isEmpty()){%><a href="<%=a.getLinkedinUrl()%>" target="_blank">LinkedIn ↗</a> · <%}%>
<a href="profile.jsp?id=<%=a.getApplicantId()%>&role=STUDENT">View full portfolio/profile ↗</a>
</div>
<span class="pill <%=accepted||"COMPLETED".equalsIgnoreCase(a.getStatus())?"status":""%>"><%=a.getStatus()==null?"PENDING":a.getStatus()%></span>
</div>

<% if(pending && "OPEN".equalsIgnoreCase(c.getStatus())) { %>
<div class="actions">
<form id="<%=formId%>" action="acceptApplication.jsp" method="post">
<input type="hidden" name="application_id" value="<%=a.getApplicationId()%>">
<button class="btn green" type="button" onclick="openDecisionModal('<%=formId%>','accept','<%=st==null?"this applicant":st.getName()%>')">Accept applicant</button>
</form>
<form id="<%=rejectFormId%>" action="rejectApplication.jsp" method="post">
<input type="hidden" name="application_id" value="<%=a.getApplicationId()%>">
<button class="btn danger" type="button" onclick="openDecisionModal('<%=rejectFormId%>','reject','<%=st==null?"this applicant":st.getName()%>')">Reject</button>
</form>
</div>
<% } %>

<% if(selected && accepted && inProgress) { %>
<div class="notice topspace">
<b>Collaboration in progress</b><br>
This student has been selected. When the work is finished, enter the credits you want to transfer and complete the collaboration.
</div>
<form class="actions" action="completeCollaboration.jsp" method="post" onsubmit="return validateCompletion(this)">
<input type="hidden" name="collab_id" value="<%=c.getCollabId()%>">
<input type="hidden" name="student_id" value="<%=a.getApplicantId()%>">
<input type="number" name="points" min="0" max="10000" placeholder="Credits to transfer" required>
<input name="note" placeholder="Credit note (optional)">
<button class="btn green" type="submit">Complete collaboration + transfer credits</button>
</form>
<% } %>

<% if(selected && completed) { %>
<div class="notice success topspace">
<b>Collaboration completed.</b><br>
<%=c.getCreditPoints()%> credits were transferred to this student. They can now rate your collaboration.
</div>
<% } %>
</div>
<%}%>

<%if(!inProgress&&!completed){%>
<form class="actions" action="deleteCollaboration.jsp" method="post"><input type="hidden" name="collab_id" value="<%=c.getCollabId()%>"><button class="btn danger" type="submit">Delete collaboration</button></form>
<%}%>
</div>
<%}%>
</div>

<!-- Custom decision modal -->
<div class="ch-modal-backdrop" id="decisionModal" aria-hidden="true">
    <div class="ch-modal" role="dialog" aria-modal="true" aria-labelledby="decisionTitle">
        <button type="button" class="ch-modal-close" onclick="closeDecisionModal()" aria-label="Close">×</button>
        <div class="ch-modal-icon" id="decisionIcon">?</div>
        <h2 id="decisionTitle">Confirm action</h2>
        <p id="decisionMessage" class="muted">Please confirm this action.</p>
        <div class="ch-modal-actions">
            <button type="button" class="btn secondary" onclick="closeDecisionModal()">Cancel</button>
            <button type="button" class="btn green" id="decisionConfirm">Confirm</button>
        </div>
    </div>
</div>

<script>
let decisionFormId = null;

function openDecisionModal(formId, action, applicantName) {
    decisionFormId = formId;
    const modal = document.getElementById('decisionModal');
    const title = document.getElementById('decisionTitle');
    const message = document.getElementById('decisionMessage');
    const icon = document.getElementById('decisionIcon');
    const confirm = document.getElementById('decisionConfirm');

    if (action === 'accept') {
        icon.textContent = '✓';
        icon.className = 'ch-modal-icon accept';
        title.textContent = 'Accept applicant?';
        message.textContent = applicantName + ' will be selected for this collaboration. Any other pending applicants for this collaboration will be rejected.';
        confirm.textContent = 'Accept applicant';
        confirm.className = 'btn green';
    } else {
        icon.textContent = '×';
        icon.className = 'ch-modal-icon reject';
        title.textContent = 'Reject applicant?';
        message.textContent = 'This applicant will be marked as rejected and will no longer be considered for this collaboration.';
        confirm.textContent = 'Reject applicant';
        confirm.className = 'btn danger';
    }

    modal.classList.add('show');
    modal.setAttribute('aria-hidden', 'false');
}

function closeDecisionModal() {
    const modal = document.getElementById('decisionModal');
    modal.classList.remove('show');
    modal.setAttribute('aria-hidden', 'true');
    decisionFormId = null;
}

document.getElementById('decisionConfirm').addEventListener('click', function () {
    if (decisionFormId) document.getElementById(decisionFormId).submit();
});

document.getElementById('decisionModal').addEventListener('click', function (event) {
    if (event.target === this) closeDecisionModal();
});

document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') closeDecisionModal();
});

function validateCompletion(form) {
    const points = parseInt(form.points.value, 10);
    if (isNaN(points) || points < 0 || points > 10000) {
        alert('Enter credits between 0 and 10,000.');
        return false;
    }
    return true;
}
</script>
</body>
</html>
