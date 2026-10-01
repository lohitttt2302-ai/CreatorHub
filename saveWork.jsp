<%@ page import="com.creatorhub.bean.StudentWork" %>
<%@ page import="com.creatorhub.dao.WorkDAO" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="java.io.File" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
Integer id = (Integer) session.getAttribute("student_id");
String role = (String) session.getAttribute("role");
boolean creator = "CREATOR".equalsIgnoreCase(role);
String backPage = creator ? "creatorPortfolio.jsp" : "portfolio.jsp";
if (id == null) {
    response.sendRedirect("login.jsp");
    return;
}

String data = request.getParameter("work_data");
String name = request.getParameter("work_name");
String mime = request.getParameter("work_mime");
String msg = "";
boolean ok = false;

try {
    if (data == null || data.isEmpty()) {
        throw new Exception("No file selected.");
    }

    if (data.length() > 2200000) {
        throw new Exception("File is too large.");
    }

    String safe = (name == null || name.trim().isEmpty() ? "work" : name)
            .replaceAll("[^a-zA-Z0-9._-]", "_");

    /*
     * IMPORTANT:
     * Uploaded files are stored OUTSIDE the Tomcat web application.
     * Therefore redeploying/removing CreatorHub will not delete user files.
     * Default location on your Mac:
     * /Users/rathneshvaran/CreatorHubUploads/
     */
    Path uploadRoot = Paths.get(System.getProperty("user.home"), "CreatorHubUploads")
            .toAbsolutePath()
            .normalize();

    Files.createDirectories(uploadRoot);

    String storedName = id + "_" + System.currentTimeMillis() + "_" + safe;
    Path destination = uploadRoot.resolve(storedName).normalize();

    if (!destination.startsWith(uploadRoot)) {
        throw new Exception("Invalid file path.");
    }

    byte[] bytes = Base64.getDecoder().decode(data);
    Files.write(destination, bytes, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);

    StudentWork w = new StudentWork();
    w.setStudentId(id);
    w.setFileName(safe);

    /*
     * Prefix tells downloadWork.jsp that this file is in the permanent
     * external storage directory rather than inside the web application.
     */
    w.setFilePath("external/" + storedName);
    w.setMimeType(mime == null || mime.trim().isEmpty()
            ? "application/octet-stream"
            : mime);

    ok = new WorkDAO().add(w) > 0;

    if (!ok) {
        Files.deleteIfExists(destination);
        msg = "Could not save work to the database.";
    } else {
        msg = "Work added to your portfolio.";
    }

} catch (Exception e) {
    msg = e.getMessage() == null ? "Upload failed." : e.getMessage();
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Portfolio · Creator Hub</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<%@ include file="sidebar.jsp" %>

<div class="container">
    <div class="form-card card center">
        <h1><%= ok ? "Portfolio updated!" : "Upload failed" %></h1>
        <p class="muted"><%= msg %></p>
        <a class="btn" href="<%=backPage%>">Back to <%=creator ? "creator portfolio" : "my portfolio"%></a>
    </div>
</div>

</body>
</html>
