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
		String type = request.getParameter("num");
		String item = request.getParameter("item");
		String sub = request.getParameter("subcategory");
		String sellerID = request.getParameter("sellerID");
	
		String query = null;
		String label = "";
		String col = "";
		String col2 = "";
		
		if (type != null && type.compareTo("1") == 0){
			label = "Total Earnings Report";
			query =
				"select sum(currBid) as s from postItem where sold='true'";
			col = "s";
		}
		
		if (type != null && type.compareTo("2") == 0){
			label = "Earnings per Item";
			query =
				"select sum(currBid) as s from postItem where sold='true' and title='" + item + "'";
			col = "s";
		}


		if (type != null && type.compareTo("3") == 0){
			label = "Earnings per Category";
			query =
				"select sum(currBid) as s from postItem where sold='true' and subcategory='" + sub + "'";
			col = "s";
		}
		
		if (type != null && type.compareTo("4") == 0){
			label = "Earnings per User";
			query =
				"select sum(currBid) as s from postItem where sold='true' and sellerID='" + sellerID + "'";
			col = "s";
		}
		
		if (type != null && type.compareTo("5") == 0){
			label = "Best Earning User";
			query = 
				"select t1.sellerID, sum(t1.currBid) as s from (" +
				"select * from postItem where sold='true'" +
				") as t1 group by sellerID order by s desc;";
			col = "s";
			col2 = "sellerID";
		}

		if (type != null && type.compareTo("6") == 0){
			label = "Best Earning Item Category";
			query = 
				"select t1.subcategory, sum(t1.currBid) as s from (" +
				"select * from postItem where sold='true'" +
				") as t1 group by subcategory order by s desc;";
			col = "s";
			col2 = "subcategory";
		}
	
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
			ResultSet result = stmt.executeQuery(query);
			
			result.next();
			
			String result1 = result.getString(col);
			
			if (type != null && type.compareTo("5") == 0 || type.compareTo("6") == 0){
				String result2 = result.getString(col2);
				out.print(label + ": " + result2 + " -- $" + result1);
			} else {
				out.print(label + ": $" + result1);
			}
			
			con.close();
		} catch (Exception ex) {
			out.print(ex.getMessage());
		}

	%>




	
	<br><br>
	<form method="get" action="reports.jsp">
			<input type="submit" value="Return Home">
	</form>
</body>
</html>