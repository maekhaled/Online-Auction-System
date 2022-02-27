<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Session Page</title>
</head>
<body>

	<br><br>
	<form method="get" action="register.jsp">
		<% 
			session.setAttribute("new_userType", "rep");
			session.setAttribute("redirect", "adminSession.jsp");
		%>
			<table>
				<tr>
					<td>Username</td><td><input type="text" name="user" required></td>
				</tr>
				<tr>
					<td>Password</td><td><input type="text" name="pass" required></td>
				</tr>
			</table>
		<input type="submit" value="Add New Representative">
	</form>
	<br><br>
	<form method="get" action="reports.jsp">
			<input type="submit" value="Reports">
	</form>
	<br><br>
	<form method="get" action="teardown.jsp">
			<input type="submit" value="Logout">
	</form>
</body>
</html>