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
<script type="text/javascript">
			    function ChangeColor(tableRow, highLight){
				    if (highLight){
				      tableRow.style.backgroundColor = '#dcfac9';}
				    else{
				      tableRow.style.backgroundColor = 'white';}
				  	}
			    function doNav(itemID){
			        var form = document.createElement("form");
			        form.method="get";
			        form.action= "viewPost.jsp";
			        
			        item = document.createElement("input");
			        item.value = itemID;
			        item.name = "itemID";
			        form.appendChild(item);

			        form.submit();
			    }
			    function myFunction(){
					var input, filter, table, tr, td, id;
					input = document.getElementById("search");
					filter = input.value.toUpperCase();
					table = document.getElementById("table");
					tr = table.getElementsByTagName("tr");
					for (i = 0; i < tr.length; i++) {
				        td = tr[i].getElementsByTagName("td");
				        for (j = 0; j < td.length; j++) {
				            if (td[j].innerHTML.toUpperCase().indexOf(filter) > -1) {
				                found = true;
				            }
				        }
				        if (found) {
				            tr[i].style.display = "";
				            found = false;
				        } else {
				            tr[i].style.display = "none";
				        }
				    }
				}
			  </script>
</head>
<body>
	<!-- -->

	<br><br>
		<form method="get" action="<%=session.getAttribute("userType").toString() %>Session.jsp">
				<input type="submit" value="Return to Home Page">
		</form>

		
		<% 
			String username = session.getAttribute("username").toString();			
			String userType = session.getAttribute("userType").toString();
			
			try {
	
				//Get the database connection
				ApplicationDB db = new ApplicationDB();	
				Connection con = db.getConnection();		
	
				//Create a SQL statement
				Statement stmt = con.createStatement();

				//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
				String str;
				if (userType.compareTo("rep") == 0) {
					str = "SELECT * FROM tickets WHERE assignedRep='" + username + "'";
				} else {
					str = "SELECT * FROM tickets WHERE submissionUser='" + username + "'";
				}
				
				
				//Run the query against the database.
				ResultSet result = stmt.executeQuery(str);
		%>
			
		<!--  Make an HTML table to show the results in: -->
		<br>
		<b>Tickets</b>
		<br>
		Search in questions:<input type="text" id="search" onkeyup="myFunction();" placeholder="Search for ..">
		<table id="table">
			<%
				//parse out the results
				while (result.next()) { 
					String num = result.getString("ticketNumber");
					String subject = result.getString("subject");
			%>
				<tr>    
					<td><a href="conversation.jsp?ticketNum=<%=num %>">Ticket #<%=num %>: <%=subject %></a></td>
				</tr>
			<%}%>
		</table>
		<br>
		<br>
		<table>
			<%
				//parse out the results
				while (result.next()) {
					String dest;
					if (userType.compareTo("rep") == 0) {
						dest = result.getString("submissionUser");
					} else {
						dest = result.getString("assignedRep");
					}
					String num = result.getString("ticketNumber");
					String subject = result.getString("subject");
					int complete = result.getInt("isCompleted");
			%>
				<tr>    
					<td>
						<a href="conversation.jsp?ticketNum=<%=num %>&isComplete=<%=complete %>&dest=<%=dest %>">
							Ticket #<%=num %>: <%=subject %>
						</a>
					</td>
				</tr>
			<%}%>
			</table>
			
			<b>Alerts</b>
		<br>
		<table border='1'>
				<% 
				String query = "SELECT alertNumber, itemID, title FROM postItem JOIN alerts USING(title) WHERE username = '" +username + "'";
				Statement stmt2 = con.createStatement();
				ResultSet rs = stmt2.executeQuery(query);
				while(rs.next()){ %>
					<tr onmouseover="ChangeColor(this, true);"
					onmouseout="ChangeColor(this, false);"
					onclick="doNav(<%=rs.getString("itemID")%>);">
					<td><% out.print(" Alert # " + rs.getString("alertNumber") ); %></td>
					<td><% out.print(rs.getString("title") + " is available!"); %></td> 
					<td><% out.print(" ItemID: " + rs.getString("itemID") ); %></td>
					</tr>
			
		<% }
				stmt.close();%>
				</table>
				<br>
			
			<% con.close();%>
			
			
		<% } catch (Exception ex) {
			out.print(ex.getMessage() + ". Please try again with new username\n\n");
		}
		
		
			
		%>
	


</body>
</html>