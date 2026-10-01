<%@ page contentType="text/html;charset=UTF-8" %>
<%
Integer id=(Integer)session.getAttribute("student_id");
String role=(String)session.getAttribute("role");
if(id==null){response.sendRedirect("login.jsp");return;}
boolean creator="CREATOR".equalsIgnoreCase(role);
String back=creator?"creatorPortfolio.jsp":"portfolio.jsp";
String title=creator?"Add previous work":"Add portfolio work";
String description=creator?"Show students what you have created before they apply to collaborate with you.":"Upload a strong sample that creators can view from your profile.";
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title><%=title%> · Creator Hub</title><link rel="stylesheet" href="style.css"></head><body>
<%@ include file="sidebar.jsp" %>
<div class="container">
<div class="form-card card">
<span class="pill"><%=creator?"CREATOR PORTFOLIO":"MY PORTFOLIO"%></span>
<h1><%=title%></h1>
<p class="muted"><%=description%></p>
<form id="workForm" action="saveWork.jsp" method="post">
<input type="hidden" id="data" name="work_data"><input type="hidden" id="name" name="work_name"><input type="hidden" id="mime" name="work_mime">
<label>Previous work file</label>
<input id="file" type="file" accept=".pdf,.png,.jpg,.jpeg,.webp,.mp4,.mov" required>
<div id="msg" class="notice">Choose a file below 1.5 MB.</div>
<div class="actions"><button class="btn" type="submit">Add to portfolio</button><a class="btn secondary" href="<%=back%>">Cancel</a></div>
</form>
</div></div>
<script>
const f=document.getElementById('file'),m=document.getElementById('msg'),form=document.getElementById('workForm');
f.onchange=()=>{let x=f.files[0];if(!x)return;if(x.size>1500000){alert('Keep the file below 1.5 MB');f.value='';return;}let r=new FileReader();r.onload=()=>{document.getElementById('data').value=r.result.split(',')[1];document.getElementById('name').value=x.name;document.getElementById('mime').value=x.type;m.className='notice success';m.textContent='Ready: '+x.name};r.readAsDataURL(x)};
form.onsubmit=e=>{if(!document.getElementById('data').value){e.preventDefault();alert('Choose a file first.')}};
</script></body></html>