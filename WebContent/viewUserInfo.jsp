<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search Users</title>
</head>
<body>
<br><br>
	
	<% 
		String searchbar = request.getParameter("searchbar");
		String del = request.getParameter("delete");
		String uc = request.getParameter("userChange");
		String pc = request.getParameter("passChange");
		String upd = request.getParameter("update");
	
	%>
	

	<form method="get" action="<%=session.getAttribute("userType").toString() + "Session.jsp" %>">
			<input type="submit" value="Return to Home Page">
	</form>	

	<form method="get">
		<label>Search Users: </label>
		<input type="text" name="searchbar" id="searchbar" required>
		<input type="submit" value="Search">
	</form>
<br><br><br>

	<%	
		int i = 0;
		while(i == 0) {
			i++;
		
		if (searchbar != null) {			
			
			
			try {
				
				ApplicationDB db = new ApplicationDB();	
				Connection con = db.getConnection();
				
				String query = "select * from users where username='" + searchbar + "'";
				
				Statement ps = con.createStatement();
				
				ResultSet result = ps.executeQuery(query);
				
				boolean val = result.next() && 
						session.getAttribute("username").toString().compareTo(result.getString("username")) != 0;
				
				String a = result.getString("username");
				String b = result.getString("password");
				
				if (del != null) {
					
					ps = con.createStatement();
					query = "delete from users where username='"+ searchbar + "';";
					ps.executeUpdate(query);
					
				}
				
				if (pc != null) {
					query = "update users set password='" + pc + "' where username='"+ searchbar + "';";
					ps.executeUpdate(query);					
				}
				
				if (uc != null) {
					query = "update users set username='" + uc + "' where username='"+ searchbar + "';";
					ps.executeUpdate(query);

				}
				
				
				if (del != null || upd != null){
					out.println("Changes made successfully.");
					break;
				}
				
				
				if (val) {
					%>
					<form action="viewUserInfo.jsp?test=1">
						<input name="searchbar" id="searchbar" value="<%=searchbar %>" readonly><br>
						<label name="user">Username: </label>
						<input type="text" name="userChange" value="<%=a %>" id="userChange" required>
						<label name="password">Password: </label>
						<input type="text" name="passChange" value="<%=b %>" id="passChange" required>
						<input type="submit" name="update" value="Update">
						<input type="submit" name="delete" value="Delete">
					</form>					
					<%
				} else {
					out.print("Error: User not found");
					
				}
				
				con.close();	
				
			} catch (Exception ex) {
				out.print(ex.getMessage());
			}
			}
		}
		
	
	
	
	%>
	


</body>
</html>