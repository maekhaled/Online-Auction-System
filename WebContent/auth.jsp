<%
	// Preprocessor Directives
	int REDIRECT = 10;

	// Authorization variables
	Boolean success = false;
	String error = "No error found";
	String url="";

	// Log in Authorization
	try {

		//Get the database connection
		
		ApplicationDB db = new ApplicationDB();	 Connection con = db.getConnection();
		
		out.print("checkintg ");

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the index.jsp
		String user = request.getParameter("user");
		String pass = request.getParameter("pass");
		
		String query_verify = "SELECT count(*) FROM users WHERE username ='" + 
			user + "' AND password='" + pass + "'";
		String query_user_type = "SELECT userType FROM users WHERE username='" + user + "'";
		
		
		
		ResultSet result = stmt.executeQuery(query_verify);
		result.next();
		//out.print(query_verify);
		int unique = result.getInt("count(*)");
		
		if (unique != 1) {
			throw new IllegalArgumentException("Invalid Username/Password Combination");
		}
		
		ResultSet result2 = stmt.executeQuery(query_user_type);
		result2.next();
		String user_type = result2.getString("userType");
		
		
		session.setAttribute("userType", user_type);
		session.setAttribute("username", user);
		session.setAttribute("active_session", true);
		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		success = true;
		
		url = user_type + "Session.jsp";
		
	} catch (Exception ex) {
		error = ex.getMessage();
		url = "welcome.jsp";
	}
	 
	String content = REDIRECT + ";" + url;
	
%>


<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<!-- <meta http-equiv="refresh" content="3;url=http://www.google.com/" /> -->
	<meta http-equiv="refresh" content="<%=content%>" />
	<title>Authorization</title>
</head>
<body>
		
		<%
			if(success) {
				out.print("Login Successful. Redirecting in " + REDIRECT + " seconds");
		%>
		<br><br>
		<form method="get" action="<%=url%>">
			<input type="submit" value="Continue">
		</form>
		<% } %>			
				
		<%
			if(!success) {
				out.print(
						error + ". Please try again with new username, " +
						"Redirecting in " + REDIRECT + " seconds"
				);
		%>
		<br><br>
		<form method="get" action="welcome.jsp">
			<input type="submit" value="Return to Login">
		</form>
		<% } %>
		
</body>
</html>