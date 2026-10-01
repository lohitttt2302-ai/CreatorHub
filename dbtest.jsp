<%@ page import="java.sql.*" %>

<html>
<head>
    <title>Database Connection Test</title>
</head>
<body>

<h1>Creator Hub - Database Test</h1>

<%
    String url = "jdbc:mysql://localhost:3306/creator_hub";
    String username = "root";
    String password = "";   // Change this if your MySQL has a password

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con = DriverManager.getConnection(url, username, password);

        out.println("<h2 style='color:green;'>Database Connected Successfully!</h2>");

        con.close();

    } catch (Exception e) {
        out.println("<h2 style='color:red;'>Database Connection Failed!</h2>");
        out.println("<p>" + e.getMessage() + "</p>");
    }
%>

</body>
</html>