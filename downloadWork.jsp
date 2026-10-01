<%@ page import="com.creatorhub.bean.StudentWork" %>
<%@ page import="com.creatorhub.dao.WorkDAO" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="application/octet-stream" %>
<%
String x = request.getParameter("id");

if (x == null || x.trim().isEmpty()) {
    response.sendError(400, "Missing work id.");
    return;
}

StudentWork w;
try {
    w = new WorkDAO().get(Integer.parseInt(x));
} catch (NumberFormatException e) {
    response.sendError(400, "Invalid work id.");
    return;
}

if (w == null) {
    response.sendError(404, "Portfolio work not found.");
    return;
}

Path file;
String storedPath = w.getFilePath();

try {
    if (storedPath != null && storedPath.startsWith("external/")) {

        /* New permanent storage */
        Path uploadRoot = Paths.get(System.getProperty("user.home"), "CreatorHubUploads")
                .toAbsolutePath()
                .normalize();

        String relative = storedPath.substring("external/".length());
        file = uploadRoot.resolve(relative).normalize();

        if (!file.startsWith(uploadRoot)) {
            response.sendError(403, "Invalid file path.");
            return;
        }

    } else {

        /*
         * Backward compatibility for old records that were saved inside
         * the Tomcat application as uploads/....
         */
        Path appRoot = Paths.get(application.getRealPath("/"))
                .toAbsolutePath()
                .normalize();

        file = appRoot.resolve(storedPath == null ? "" : storedPath)
                .normalize();

        if (!file.startsWith(appRoot)) {
            response.sendError(403, "Invalid file path.");
            return;
        }
    }

    if (!Files.exists(file) || !Files.isRegularFile(file)) {
        response.sendError(404, "The uploaded file is not available.");
        return;
    }

    String mime = w.getMimeType();
    response.reset();
    response.setContentType(
            mime == null || mime.trim().isEmpty()
                    ? "application/octet-stream"
                    : mime
    );

    String safeName = w.getFileName() == null
            ? "portfolio-work"
            : w.getFileName().replace("\"", "");

    response.setHeader(
            "Content-Disposition",
            "inline; filename=\"" + safeName + "\""
    );

    response.setContentLengthLong(Files.size(file));

    try (InputStream in = Files.newInputStream(file);
         OutputStream outStream = response.getOutputStream()) {

        byte[] buffer = new byte[8192];
        int n;

        while ((n = in.read(buffer)) != -1) {
            outStream.write(buffer, 0, n);
        }

        outStream.flush();
    }

} catch (IOException e) {
    if (!response.isCommitted()) {
        response.sendError(500, "Could not open the uploaded file.");
    }
}
%>
