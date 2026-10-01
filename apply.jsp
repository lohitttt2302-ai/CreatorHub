<%@ page import="com.creatorhub.bean.Collaboration" %><%@ page import="com.creatorhub.bean.Student" %><%@ page import="com.creatorhub.dao.CollaborationDAO" %><%@ page import="com.creatorhub.dao.StudentDAO" %><%@ page import="com.creatorhub.dao.ApplicationDAO" %><%@ page contentType="text/html;charset=UTF-8" %>
<%
Integer studentId=(Integer)session.getAttribute("student_id"); if(studentId==null){response.sendRedirect("login.jsp");return;}
String p=request.getParameter("collab_id"); if(p==null){response.sendRedirect("collaborations.jsp");return;} int collabId=Integer.parseInt(p);
Collaboration c=new CollaborationDAO().getById(collabId); Student s=new StudentDAO().getById(studentId); boolean already=new ApplicationDAO().hasApplied(collabId,studentId);
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Apply · Creator Hub</title><link rel="stylesheet" href="style.css"></head><body>
<%@ include file="sidebar.jsp" %>
<nav class="nav"><a class="brand" href="studentPortal.jsp">Creator Hub</a><div class="navlinks"><a href="profile.jsp?id=<%=studentId%>&role=STUDENT">My Profile</a><a href="logout.jsp" class="logout">Logout</a></div></nav>
<div class="container"><div class="form-card card">
<%if(c==null){%><h2>Collaboration not found.</h2><%}else if(already){%><div class="center"><h1>Already applied</h1><p class="muted">You have already applied to <b><%=c.getTitle()%></b>.</p><a class="btn" href="studentPortal.jsp">Back to Portal</a></div><%}else{%>
<span class="pill"><%=c.getCategory()%></span><h1>Apply to <%=c.getTitle()%></h1><p class="muted"><%=c.getDescription()%></p>
<form id="applyForm" action="submitApplication.jsp" method="post"><input type="hidden" name="collab_id" value="<%=collabId%>"><input type="hidden" id="work_data" name="work_data"><input type="hidden" id="work_name" name="work_name"><input type="hidden" id="work_mime" name="work_mime">
<label>Why are you suitable?</label><textarea name="pitch" rows="7" placeholder="Tell the creator about your skills, experience and what you can contribute..." required></textarea>
<label>LinkedIn profile</label><input type="url" name="linkedin_url" value="<%=s!=null&&s.getLinkedinUrl()!=null?s.getLinkedinUrl():""%>" placeholder="https://www.linkedin.com/in/yourname">
<label>Previous work <span class="muted">(required)</span></label><input type="file" id="workFile" accept=".pdf,.png,.jpg,.jpeg,.webp,.mp4,.mov" required><p class="small muted">Upload one strong sample. Keep it under about 1.5 MB.</p>
<div id="fileStatus" class="notice">No file selected.</div><button class="btn full" type="submit">Submit Application →</button></form>
<script>
const f=document.getElementById('workFile'),form=document.getElementById('applyForm'),status=document.getElementById('fileStatus');
f.addEventListener('change',()=>{const x=f.files[0]; if(!x){status.textContent='No file selected.';return;} if(x.size>1500000){status.textContent='File is too large. Choose a file below 1.5 MB.';f.value='';return;} const r=new FileReader();r.onload=()=>{document.getElementById('work_data').value=r.result.split(',')[1];document.getElementById('work_name').value=x.name;document.getElementById('work_mime').value=x.type;status.className='notice success';status.textContent='Ready: '+x.name;};r.readAsDataURL(x);});
form.addEventListener('submit',e=>{if(!document.getElementById('work_data').value){e.preventDefault();alert('Please wait for the file to finish loading or choose a file.');}});
</script>
<%}%></div></div></body></html>