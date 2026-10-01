<%@ page import="com.creatorhub.bean.Student" %>
<%@ page import="com.creatorhub.dao.StudentDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
if(session.getAttribute("student_id")!=null){response.sendRedirect("dashboard.jsp");return;}
String error=null;
if("POST".equalsIgnoreCase(request.getMethod())){
 String email=request.getParameter("email"), password=request.getParameter("password");
 Student s=new StudentDAO().login(email,password);
 if(s!=null){
  session.setAttribute("student_id",s.getStudentId()); session.setAttribute("student_name",s.getName());
  session.setAttribute("student_email",s.getEmail()); session.setAttribute("role",s.getRole());
  response.sendRedirect("dashboard.jsp"); return;
 } else error="Invalid email or password.";
}
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Login · Creator Hub</title><link rel="stylesheet" href="style.css"></head>
<body>
<div class="container"><div class="form-card card">
<div class="center"><a class="brand" href="index.jsp">Creator Hub</a><h1>Welcome back</h1><p class="muted">Sign in and keep creating.</p></div>
<% if(error!=null){ %><div class="notice dangerbox"><%=error%></div><% } %>
<form method="post">
<label>Email</label><input type="email" name="email" required>
<label>Password</label><input type="password" name="password" required>
<button class="btn full" type="submit">Login</button>
</form>
<p class="center muted">New here? <a href="signup.jsp">Create an account</a></p>
</div></div></body></html>