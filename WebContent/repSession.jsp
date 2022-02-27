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
<%
	out.print("Welcome, Representative " + session.getAttribute("username"));
%>


<br><br>
	<form method="get" action="inbox.jsp">
			<input type="submit" value="Inbox">
	</form>
	
<br><br>
	<form method="get" action="viewUserInfo.jsp">
			<input type="submit" value="View User Information">
	</form>
	
<br><br>
	<form method="get" action="viewAuctionInfo.jsp">
		<input type="radio" name="command" value="bids" required/>Remove Bids
		  <br>
		  <input type="radio" name="command" value="auctions"/>Remove Auctions
		    <!-- when the radio for bars is chosen, then 'command' will have value 
		     | 'bars', in the show.jsp file, when you access request.parameters -->
		  <br>
		<input type="submit" value="Submit" >
	</form>
	
	

<br><br>
	<form method="get" action="teardown.jsp">
			<input type="submit" value="Logout">
	</form>
</body>
</html>