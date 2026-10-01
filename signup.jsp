<%@ page import="com.creatorhub.dao.StudentDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
String error=null;
if("POST".equalsIgnoreCase(request.getMethod())){
 String name=request.getParameter("name"),email=request.getParameter("email"),password=request.getParameter("password"),role=request.getParameter("role");
 StudentDAO dao=new StudentDAO();
 if(dao.emailExists(email)) error="An account with this email already exists.";
 else if(password==null||password.length()<4) error="Password must contain at least 4 characters.";
 else {int id=dao.signup(name,email,password,role);if(id>0){response.sendRedirect("login.jsp?registered=1");return;} error="Could not create account.";}
}
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Sign up · Creator Hub</title><link rel="stylesheet" href="style.css"></head>
<body><div class="container"><div class="form-card card">
<div class="center"><a class="brand" href="index.jsp">Creator Hub</a><h1>Create your profile</h1><p class="muted">Join as a student or creator.</p></div>
<%if(error!=null){%><div class="notice dangerbox"><%=error%></div><%}%>
<form method="post"><label>Name</label><input name="name" required>
<label>Email</label><input type="email" name="email" required>
<label>Password</label><input type="password" name="password" minlength="4" required>
<label>Account type</label><select name="role" required><option value="STUDENT">Student</option><option value="CREATOR">Creator</option></select>
<button class="btn full" type="submit">Create Account</button></form>
<p class="center muted">Already registered? <a href="login.jsp">Login</a></p>
</div></div></body></html>