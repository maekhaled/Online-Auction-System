<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Login Auth</title>
	</head>
	
	<body>
	
	<div align="center">
		<%out.print("Welcome to Online Auction"); %>
		<h1>Login </h1>
		
		<form method="get" action="auth.jsp">
			<table>
				<tr><td>User: </td><td><input type ="text" name="user"></td></tr>
				<tr><td>Password: </td><td><input type="password" name="pass"></td></tr>
				<tr><td></td><td><input type ="submit" value="Login"></td></tr>
			</table>
		</form>
	</div>
	
	<div align="center">
		<h1>Register </h1>
		
		<form method="post" action="register.jsp">
			<%
				session.setAttribute("new_userType", "customer");
				session.setAttribute("redirect", "welcome.jsp");
			%>
			<table>
				<tr><td>User: </td><td><input type ="text" name="user" required></td></tr>
				<tr><td>Password: </td><td><input type="password" name="pass" required></td></tr>
				<tr><td></td><td><input type ="submit" value="Register"></td></tr>
			</table>
		</form>
	</div>

	

</body>
</html>