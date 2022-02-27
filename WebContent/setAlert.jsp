<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<title>Create Alert</title>
</head>
<body>

<% 
	
	// Calculate which representative to assign to the ticket
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		
		String username = session.getAttribute("username").toString();
		
		Statement stmt = con.createStatement();
		
		ResultSet rs = stmt.executeQuery("SELECT max(alertNumber) max FROM alerts WHERE username = '" + username + "'");
		
		int alertNumber;
		if(rs.next()){
			int max = rs.getInt("max");
			alertNumber = max+1;
		}
		else{
			alertNumber = 1;
		}
		
		//Get the selected radio button from the index.jsp
		String entity = request.getParameter("command");

		String title = request.getParameter("title");
		
		
		
		
		String insert = "INSERT INTO alerts values( '"+ username + "' ," + alertNumber + ", '" + entity + "' , '" + title + "' )";
		
		Statement stmt2 = con.createStatement();
		
		stmt2.executeUpdate(insert);
		
		%>
		
Alert has been added! When an item matching this title becomes available you will be alerted in your inbox.

		<%
		con.close();
		
	} catch (Exception ex) {
		out.print(ex.getMessage());
	}%>

<br><br>
	<form method="get" action="inbox.jsp">
			<input type="submit" value="Go to Inbox">
	</form>
<br><br>
		<form method="get" action="<%=session.getAttribute("userType").toString() %>Session.jsp">
				<input type="submit" value="Return to Home Page">
		</form>
</body>
</html>