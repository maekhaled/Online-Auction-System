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
		String command = request.getParameter("command");
		String itemID = request.getParameter("itemID");
		String bidID = request.getParameter("bidID");
	
		if (command != null && command.compareTo("auctions") == 0) {
			out.print(
				"<form method='get'>" +
					"<label>Search Auctions: </label><br>" +
					"Item ID: <input type='text' name='itemID' id='itemID' required><br>" +
					"<input type='submit' value='Remove'>" +
				"</form>"
			);
			
		}
		
		if (command != null && command.compareTo("bids") == 0) {
			out.print(
				"<form method='get'>" +
					"<label>Search Auctions: </label><br>" +
					"Item ID: <input type='text' name='itemID' id='itemID' required><br>" +
					"Bid ID: <input type='text' name='bidID' id='bidID' required><br>" +
					"<input type='submit' value='Remove'>" +
				"</form>"
			);
		}
	
	out.print(itemID);
    if (bidID == null && itemID != null) {
    	try {
    		
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			Statement stmt = con.createStatement();

			String query = "select * from postitem where itemID='" + itemID + "' and sold='false';";
			
			ResultSet result = stmt.executeQuery(query);
			
			
			
			if (result.next()){
				query = "delete from postitem where itemID='" + itemID + "';";
				
				int rows = stmt.executeUpdate(query);
				
				rows = rows + stmt.executeUpdate(query);								
				out.println(rows + " rows affected by the deletion");
				
			} else {
				out.print("Item (" + itemID + ") invalid, item already sold or not found.");
			}
			
			
			con.close();
		} catch (Exception ex) {
			out.print(ex.getMessage());
		}
    	
    }
    
    
    if (bidID != null && itemID != null) {
    	try {
	   		ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			Statement stmt = con.createStatement();
	    	
	    	String query = "select * from postitem where itemID='" + itemID + "' and sold='false';";
			
			ResultSet result = stmt.executeQuery(query);
		
			if (result.next()){
				
				float init_bid = result.getFloat("initialPrice");
				
				query = "delete from placebidon where itemID='" + itemID + "' and bidID='" + bidID + "';";
				
				int rows = stmt.executeUpdate(query);
				
				query = "select * \n" +
						"from placebidon\n" +
					    "where itemID = '" + itemID + "'\n" +
					    "and buyerID <> 'user1'\n" +
					    "order by bidSeq desc;\n";
					    
				ResultSet results = stmt.executeQuery(query);				
				
				float bid = init_bid;
				if(results.next()) {
					bid = results.getFloat("bidPrice");
				}			
				
				query = "update postitem\n" + 
						"set currBid='" + bid + "'\n" +
						"where itemID='" + itemID + "';\n"; 
				
				rows = rows + stmt.executeUpdate(query);
						
				out.println(rows + " rows affected by the deletion");
				
				con.close();
	
		    } else {
		    	out.print("Item (" + itemID + ") invalid, item already sold or not found.");
			}
			
		
			con.close();
			
		} catch (Exception ex) {
			out.print(ex.getMessage());
		}
    }
	%>
	
	<br>
	<form method="get" action="repSession.jsp">
			<input type="submit" value="Return to Home Page">
	</form>	


<br><br><br>

	<%
		
		
	%>
	


</body>
</html>