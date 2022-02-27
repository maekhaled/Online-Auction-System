<%@page import="java.sql.Date"%>
<%@page import="java.time.Instant"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Authorization</title>
</head>
<body>
	<%
	String typing = session.getAttribute("new_userType").toString();
	String redirect = session.getAttribute("redirect").toString();
	
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the index.jsp
		String newUser = request.getParameter("user");
		String newPass = request.getParameter("pass");
		
		long millis=System.currentTimeMillis();  
        java.sql.Date since=new java.sql.Date(millis);
		String verify_unique = "SELECT count(*) FROM users WHERE username ='" + 
			newUser + "'";
		
		ResultSet result = stmt.executeQuery(verify_unique);
		
		result.next();
		int unique = result.getInt("count(*)");
		
		if (unique != 0) {
			throw new IllegalArgumentException("Username not unique");
		}
		
		
		//Make an insert statement for the Sells table:
		String insert = "INSERT INTO users(username, password, userType)"
				+ "VALUES (?, ?, ?)";
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(insert);

		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, newUser);
		ps.setString(2, newPass);
		ps.setString(3, typing);
		
		//Run the query against the DB
		ps.executeUpdate();
		//Run the query against the DB
		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		out.print("Account Successfully Created");
		
		
	} catch (Exception ex) {
		out.print(ex.getMessage() + ". Please try again with new username\n\n");
	}
%>
<br><br>
	<form method="get" action="<%=redirect%>">
			<input type="submit" value="Return">
	</form>
</body>
</html>