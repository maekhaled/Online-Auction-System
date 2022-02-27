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

	<br><br>
	<form method="get" action="generateReport.jsp?num=1">
			<input type="hidden" name="num" value="1">
			<input type="submit" value="Total Earnings Report">
	</form>
	
	<br><br>
	<form method="get" action="generateReport.jsp?num=2">
			<input type="hidden" name="num" value="2">
			<label>Earnings per Item</label><br>
			<input type="text" name="item" id="item" required>
			<input type="submit" value="Generate">
	</form>
	
	<br><br>
	<form method="get" action="generateReport.jsp">
			<input type="hidden" name="num" value="3">
			<label for="subcategory">Choose an Item Type:</label><br>
			<select  name="subcategory" id="subcategory">
				<%
					try {
						ApplicationDB db = new ApplicationDB();	
						Connection con = db.getConnection();
						String query = 
							"select distinct subcategory from postItem order by subcategory asc;";
						Statement stmt = con.createStatement();
						ResultSet result = stmt.executeQuery(query);
						
						while(result.next()){
							String option = result.getString("subcategory");
							%>
							<option value="<%=option %>"><%=option %></option>
							<%
						}						
					}  catch (Exception ex) {
						out.print(ex.getMessage());
					}
				
				%>
			</select>
			<input type="submit" value="Generate Report">
	</form>
	
	<br><br>
	<form method="get" action="generateReport.jsp">
			<label>Earnings per User</label><br>
			<input type="hidden" name="num" value="4">
			<input type="text" name="sellerID" id="sellerID" required>
			<input type="submit" value="Generate Report">
	</form>
	
	<br><br>
	<form method="get" action="generateReport.jsp">
		<input type="hidden" name="num" value="5">
		<label>Best Earning User</label><br>
		<input type="submit" value="Generate Report">
	</form>
	
	<br><br>
	<form method="get" action="generateReport.jsp">
		<input type="hidden" name="num" value="6">
		<label>Best Earning Item Category</label><br>
		<input type="submit" value="Generate Report">
	</form>




	
	<br><br>
	<form method="get" action="adminSession.jsp">
			<input type="submit" value="Return Home">
	</form>
</body>
</html>