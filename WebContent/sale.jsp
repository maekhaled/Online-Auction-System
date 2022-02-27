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
<% 
 try {
	 if(session.getAttribute("username")==null){
			response.sendRedirect("welcome.jsp");
		}
	 //out.println(session.getAttribute("name"));
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			
			
			//out.print(now+"<br>");
			String str ="";
			//String str = "SELECT * FROM post p left outer join item i on p.itemid=i.id where userid <> " + session.getAttribute("id") +" and till > '"+dtf.format(now)+"'";
			//Run the query against the database.
			
			str = "SELECT * from postitem ";
			
			//str= "SELECT * FROM postitem p where sellerID <> '" + session.getAttribute("name") +"' and DATE(endDate) > curdate()";
			
			str= "SELECT * FROM postitem p where sellerID <> '" + session.getAttribute("username") +"' and sold = 'false'";
			//out.println(str);
			ResultSet result = stmt.executeQuery(str);
			
			LocalDateTime time;
			//LocalDateTime time = LocalDateTime.parse(result.getString("endDate")) ;
			//Date date = new Date(); 
			
			//out.println(str+"<br>");
		%>
			
		<!--  Make an HTML table to show the results in: -->
	<table >
		<tr>    
			<td>Seller</td>
			
			<td>Tile</td>
			
			<td>Sub-category </td>
			
			<td>Going Bid</td>
			
			<td>Next Bid</td>

			<td>(match next Bid)</td>
		</tr>
			<%
			//parse out the results
			while (result.next()) { 
				
				
				str = result.getString("endDate").substring(0,result.getString("endDate").length()-2).replace(" ","T");
				
				time =LocalDateTime.parse(str);
				time.minusSeconds(11);
				
				
				//out.println(time.isAfter(LocalDateTime.now())+"<br>"+ result.getInt("itemID") +"<br>");
				 		
				 if(time.isAfter(LocalDateTime.now()))	{%>
			
			
				<tr>
					<td><%= result.getString("sellerID") %> </td>
					
					<td><a href="viewPost.jsp?itemID= <%= result.getInt("itemID") + " " %> "><%= result.getString("title") %></a> </td>
					
					
					<td><%= result.getString("subcategory") %></td>
					
					<td ><%= result.getString("currBid") %> </td>
					
					
					<td ><% //result.getString("increment");
						float i = Float.parseFloat(result.getString("currBid"))
								+Float.parseFloat(result.getString("increment"));
						out.println(i);
						
					%> </td>
					
					
					
				</tr>
				

			<% }
			
			}
			//close the connection.
			db.closeConnection(con);
			%>
		</table>

			
		<%} catch (Exception e) {
			out.print(e);
		}%>


</body>
</html>