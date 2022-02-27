<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.LocalDateTime,java.text.SimpleDateFormat,java.util.Date   "%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<div>
<% 
 try {
	 if(session.getAttribute("username")==null){
			response.sendRedirect("welcome.jsp");
		}
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			
			//out.print(request.getParameter("itemID"));
			
			String str = "SELECT * FROM postitem where itemID="+request.getParameter("itemID");
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
			
			result.next();
			float incFloat = result.getFloat("increment");
			//out.println(incFloat);
			float nextBid = result.getFloat("currBid") + incFloat;
			
		%>
			

	<table>
		<tr>    
			
			<td>Name</td>
			<td>Category</td>
			<td>Current Bid</td>
			<td>Next Bid</td>
		
		
		</tr>
		<tr>
			<td><%= result.getString("title")%></td>
			<td><%= result.getString("subcategory") %></td>
			<td><%=result.getInt("currBid") %></td>
			<td><%=nextBid %></td>
		</tr>
		<tr><td></td> </tr>
			<tr>
			<td>Details:</td> 
			<td><%= result.getString("details")%> </td>
			</tr>
		
			<%
			
			
			
			//close the connection.
			db.closeConnection(con);
			%>
		</table>
		
		
			
		
		<%
			
		session.setAttribute("controlDetails", request.getParameter("itemID")+ " "+ 
				session.getAttribute("username") + " "+ incFloat);
		
		

			%>

		<form method="post" action="makeBid.jsp?"> 
		<br>
						Bid Price:
						<input type="number" step="0.01" required name="us_bid"><br><br>
						Max Bid:
						<input type="number" step="0.01" name="us_bidMax"><br>
						<input type="submit" value="Bid">
						
		</form>
			
		<%} catch (Exception e) {
			out.print(e);
		}%>


	
</div>


</body>
</html>