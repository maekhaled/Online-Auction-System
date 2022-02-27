<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Message Inbox</title>
</head>
<body>
<br><br>
	<table>
		<tr>
			<td>
			<form method="get" action="inbox.jsp">
					<input type="submit" value="Return to inbox">
			</form>
			</td>
			<td>
			<%
				String username = session.getAttribute("username").toString();
				String completion = request.getParameter("isComplete");
				String ticketNum = request.getParameter("ticketNum");
				
				String usermsg = request.getParameter("usermsg");
				String submitmsg = request.getParameter("submitmsg");
				String markedComplete = request.getParameter("markedComplete");
				
				String dest = request.getParameter("dest");
				
				if (completion != null && completion.compareTo("0") == 0) { %>
					<form method="post" action="conversation.jsp?ticketNum=<%=ticketNum %>&isComplete=1&dest=<%=dest %>">
						<input type="submit" name="markedComplete" id="markedComplete" value="Mark as complete">
					</form>
			</td>
		</tr>
	</table>
	<form name="message" method="post" action="conversation.jsp?ticketNum=<%=ticketNum %>&isComplete=0&dest=<%=dest %>">
		<input name="usermsg" type="text" id="usermsg" required/>
		<input name="submitmsg" type="submit" id="submitmsg" value="Send"/>
    </form>
		<% } else {
				try {
					ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();
					
					String markAsCompleted =
						"update tickets\n" + 
						"set isCompleted = 1\n" +
						"where ticketNumber='" + ticketNum + "';\n"; 
					
					Statement stmt = con.createStatement();
					stmt.executeUpdate(markAsCompleted);
					
					usermsg = "Ticket marked as complete by " + username;
					con.close();
				} catch (Exception ex) {
					out.print(ex.getMessage());
				} 
		%>
			</td>
		</tr>
	</table>
		
		<%
			}	
			
	
			if (submitmsg != null || markedComplete != null) {
				try {
					//Get the database connection
					ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();	
		
					//Create a SQL statement
					Statement stmt = con.createStatement();
				
					String get_thread_number = 
						"select count(*) as c\n" + 
						"from messages\n" + 
						"where ticketNumber='" + ticketNum + "'\n" +
					"order by threadNumber\n;";
					
					//Run the query against the database.
					ResultSet result = stmt.executeQuery(get_thread_number);
					result.next(); int next_num = result.getInt("c");
					
					String send_message = "INSERT INTO messages" +
							"(ticketNumber, threadNumber, src, dest, body, timestamp)"
							+ "VALUES (?, ?, ?, ?, ?, ?)";
					
					PreparedStatement ps = con.prepareStatement(send_message);
					
					ps.setString(1, ticketNum);
					ps.setInt(2, next_num);
					ps.setString(3, username);
					ps.setString(4, dest);
					ps.setString(5, usermsg);
					ps.setDate(6, new java.sql.Date(System.currentTimeMillis()));
					
					ps.executeUpdate();
					con.close();
				} catch (Exception ex) {
					out.print(ex.getMessage());
				}	
			}
	
			
			try {
	
				//Get the database connection
				ApplicationDB db = new ApplicationDB();	
				Connection con = db.getConnection();	
	
				//Create a SQL statement
				Statement stmt = con.createStatement();
				
			
				String str = "SELECT body, src FROM messages WHERE ticketNumber='" + ticketNum + "'" +
				"order by threadNumber";
				
				//Run the query against the database.
				ResultSet result = stmt.executeQuery(str);
		%>
 		<div id="wrapper" rows="10" cols="80">

			<div id="chatbox"></div>
				<%
					//parse out the results
					while (result.next()) { 
						String msg = result.getString("body") + "\n";
						String sender = result.getString("src");
				%>
						<%=sender %>: <%=msg %><br>
				<%} con.close();%>
				
			<% } catch (Exception ex) {
				out.print(ex.getMessage());
			} %>
        </div>
		<!--  Make an HTML table to show the results in: -->
		<br>

</body>
</html>