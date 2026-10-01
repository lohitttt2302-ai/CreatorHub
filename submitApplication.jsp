<%@ page import="com.creatorhub.bean.Application" %><%@ page import="com.creatorhub.bean.StudentWork" %><%@ page import="com.creatorhub.dao.ApplicationDAO" %><%@ page import="com.creatorhub.dao.StudentDAO" %><%@ page import="com.creatorhub.dao.WorkDAO" %><%@ page import="java.util.Base64" %><%@ page import="java.nio.file.*" %><%@ page import="java.io.File" %><%@ page contentType="text/html;charset=UTF-8" %>
<%
Integer studentId=(Integer)session.getAttribute("student_id"); if(studentId==null){response.sendRedirect("login.jsp");return;}
String collabStr=request.getParameter("collab_id"); if(collabStr==null){response.sendRedirect("collaborations.jsp");return;} int collabId=Integer.parseInt(collabStr);
String pitch=request.getParameter("pitch"), linkedin=request.getParameter("linkedin_url"), fileData=request.getParameter("work_data"), fileName=request.getParameter("work_name"), mime=request.getParameter("work_mime");
ApplicationDAO ad=new ApplicationDAO();
if(ad.hasApplied(collabId,studentId)){response.sendRedirect("apply.jsp?collab_id="+collabId+"&already=1");return;}
String error=null; int workId=-1;
if(pitch==null||pitch.trim().length()<20) error="Please explain why you are suitable in at least 20 characters.";
else if(fileData==null||fileData.isEmpty()) error="Please upload one previous work.";
else {
 try{
  if(fileData.length()>2200000) throw new Exception("File is too large. Please keep it below about 1.5 MB.");
  String safe=fileName==null?"work":fileName.replaceAll("[^a-zA-Z0-9._-]","_"); String rel="uploads/"+studentId+"_"+System.currentTimeMillis()+"_"+safe;
  Path uploadRoot=Paths.get(System.getProperty("user.home"),"CreatorHubUploads").toAbsolutePath().normalize(); Files.createDirectories(uploadRoot);
  String storedName=studentId+"_"+System.currentTimeMillis()+"_"+safe; Path destination=uploadRoot.resolve(storedName).normalize();
  if(!destination.startsWith(uploadRoot)) throw new Exception("Invalid file path.");
  byte[] bytes=Base64.getDecoder().decode(fileData); Files.write(destination,bytes,StandardOpenOption.CREATE,StandardOpenOption.TRUNCATE_EXISTING);
  StudentWork w=new StudentWork();w.setStudentId(studentId);w.setFileName(safe);w.setFilePath("external/"+storedName);w.setMimeType(mime==null?"application/octet-stream":mime);workId=new WorkDAO().add(w);
  Application a=new Application();a.setCollabId(collabId);a.setApplicantId(studentId);a.setPitchText(pitch);a.setLinkedinUrl(linkedin==null?"":linkedin);a.setWorkId(workId);
  if(!ad.applyForCollaboration(a)) throw new Exception("Could not save the application.");
 }catch(Exception e){error=e.getMessage();}
}
%>
<!DOCTYPE html><html><head><title>Application · Creator Hub</title><link rel="stylesheet" href="style.css"></head><body>
<%@ include file="sidebar.jsp" %>
<div class="container"><div class="form-card card">
<%if(error!=null){%><div class="notice dangerbox"><h3>Application not submitted</h3><p><%=error%></p><a class="btn secondary" href="apply.jsp?collab_id=<%=collabId%>">Go back</a></div><%}else{%><div class="center"><div style="font-size:45px">🎉</div><h1>Application submitted!</h1><p class="muted">The creator can now review your profile, pitch and previous work.</p><a class="btn" href="studentPortal.jsp">Open My Portal</a></div><%}%>
</div></div></body></html>