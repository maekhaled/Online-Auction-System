<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.util.Random" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<title>Ticket Confirmation</title>
</head>
<body>

<% 
	
	String ticketNumber = "" + System.currentTimeMillis() + "" + new Random().nextInt(10);
	String submissionUser = session.getAttribute("username").toString();
	String assignedRep = "system";
	String subject = request.getParameter("subject");
	String msg = request.getParameter("desc");

	// Calculate which representative to assign to the ticket
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		
		String filter_tickets = 
			"create temporary table if not exists filteredTickets\n" +
			"select *\n" +
			"from tickets\n" +
			"where assignedRep!='system' and isCompleted=0;\n";
		
		String rep_list = 
			"create temporary table if not exists reps\n" +
			"select username from users where userType='rep';\n";
		
		String get_counts = 
			"create temporary table if not exists tickCounts\n" +
			"select assignedRep, count(*) as c\n" +
			"from filteredTickets\n" +
			"group by assignedRep;\n";
		
		String find_rep = 
			"select username, coalesce(c, 0) as c\n" +
			"from reps\n" +
			"left join tickCounts\n" +
			"on assignedRep = username\n" +
			"order by c asc;";
		
		Statement ps = con.createStatement();
		
		ps.executeUpdate(filter_tickets);
		ps.executeUpdate(rep_list);
		ps.executeUpdate(get_counts);
		
		ResultSet result = ps.executeQuery(find_rep);
		result.next();
		
		assignedRep = result.getString("username");
		con.close();
		
	} catch (Exception ex) {
		out.print(ex.getMessage());
	}

	// Actually attempt to create the ticket
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		String new_ticket = "INSERT INTO tickets(ticketNumber, submissionUser, subject, originalQuestion, assignedRep)"
				+ "VALUES (?, ?, ?, ?, ?)";
		
		PreparedStatement ps = con.prepareStatement(new_ticket);
	
		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, ticketNumber);
		ps.setString(2, submissionUser);
		ps.setString(3, subject);
		ps.setString(4, msg);
		ps.setString(5, assignedRep);
		
		ps.executeUpdate();
		con.close();
		
	} catch (Exception ex) {
		out.print(ex.getMessage());
	}

	// Send first message to ticket thread
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		String new_message = "INSERT INTO messages(ticketNumber, threadNumber, src, dest, body, timestamp)"
				+ "VALUES (?, ?, ?, ?, ?, ?)";
		
		PreparedStatement ps = con.prepareStatement(new_message);
	
		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, ticketNumber);
		ps.setInt(2, 0);
		ps.setString(3, submissionUser);
		ps.setString(4, assignedRep);
		ps.setString(5, msg);
		ps.setDate(6, new java.sql.Date(System.currentTimeMillis()));
		
		ps.executeUpdate();
		con.close();
		
	} catch (Exception ex) {
		out.print(ex.getMessage());
	}
	
%>


	<h1>Ticket Created!</h1>
	<h2>Ticket #: <%=ticketNumber %></h2>

<br><br>
	<form method="get" action="inbox.jsp">
			<input type="submit" value="Go to Inbox">
	</form>
</body>
</html>