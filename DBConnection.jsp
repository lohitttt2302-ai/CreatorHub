<%@ page import="java.sql.*" %>

<%
String url = "jdbc:mysql://localhost:3306/creator_hub";
String username = "root";
String password = "";   // change this if your MySQL has a password

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(url, username, password);

    out.println("<h2>Database Connected Successfully!</h2>");

    con.close();

} catch (Exception e) {
    out.println("<h2>Database Connection Failed</h2>");
    out.println("<p>" + e.getMessage() + "</p>");
}
%>