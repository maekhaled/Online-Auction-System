<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Similar Item History</title>
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
			        form.action= "itemPost.jsp";
			        
			        item = document.createElement("input");
			        item.value = itemID;
			        item.name = "itemID";
			        form.appendChild(item);
			        
			        form.submit();
			    }
			  </script>
</head>
<body>
	<%
	try {
		
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		String itemID = request.getParameter("itemID");
		
		String initialquery = "SELECT * FROM postItem WHERE itemID = ?";
		
		PreparedStatement initialps = con.prepareStatement(initialquery);

		initialps.setString(1, itemID);
		
		ResultSet initresult = initialps.executeQuery();
		
		String subcategory ="";
		String endDate = "";
		
		while(initresult.next()){
		
			subcategory = initresult.getString("subcategory");
			endDate = initresult.getString("endDate");
			break;
		}
		
		initialps.close();
		initresult.close();
		
		String query2 ="";
		
		if(subcategory.equals("tops")){
			String query = "SELECT * FROM tops WHERE itemID = ?";
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1,itemID);
			ResultSet result = ps.executeQuery();
			if(result.next()){
			String size = result.getString("size");
			String topType = result.getString("topType");
			String color = result.getString("color");
			String material = result.getString("material");
			ps.close();
			result.close();
			query2 = "SELECT * FROM postItem JOIN " + subcategory +" USING(itemID) WHERE sold='false' AND (size = '"+ size +"' OR topType = '"+ topType +"' OR color = '" +color+ "' OR material = '" + material + "')";}
		}
		else if(subcategory.equals("bottoms")){
			String query = "SELECT * FROM bottoms WHERE itemID = ?";
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1,itemID);
			ResultSet result = ps.executeQuery();
			if(result.next()){
			String waistSize = result.getString("waistSize");
			String length = result.getString("length");
			String color = result.getString("color");
			String material = result.getString("material");
			ps.close();
			result.close();
			query2 = "SELECT * FROM postItem JOIN " + subcategory + " USING(itemID) WHERE sold = 'false' AND (waistSize = "+ waistSize + " OR length = " + length + " OR color = '" + color + "' OR material = '" + material +"')";}
		}
		else{
			String query = "SELECT * FROM shoes WHERE itemID = ?";
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1,itemID);
			ResultSet result = ps.executeQuery();
			if(result.next()){
				float shoeSize = result.getFloat("shoeSize");
				String shoeType = result.getString("shoeType");
				String color = result.getString("color");
				String brand = result.getString("brand");
				ps.close();
				result.close();
				query2 = "SELECT * FROM postItem JOIN '" + subcategory + "' USING(itemID) WHERE sold='false' AND (shoeSize = "+ shoeSize +" OR shoeType = '" + shoeType + "'" + " OR color = '" + color + "' OR brand = '" + brand +"')";
			}
			}
		Statement stmt2 = con.createStatement();
		ResultSet result2 = stmt2.executeQuery(query2);
		%>
	
Similar Items:
<br><br>

	<table border='1'>
		<tr>
			<td>ItemID</td>
			<td>Item Type</td>
			<td>Title</td>
			<td>Current Bidding Price</td>
			<td>End Date</td>
			<% if(subcategory.equals("tops")){%>
					<td>Size</td>
					<td>Top Type</td>
					<td>Color</td>
					<td>Material</td>
				<%}else if(subcategory.equals("bottoms")){ %>
					<td>Waist Size</td>
					<td>Length</td>
					<td>Color</td>
					<td>Material</td>
				<%}else if (subcategory.equals("shoes")){ %>
					<td>Shoe Size</td>
					<td>Shoe Type</td>
					<td>Color</td>
					<td>Brand</td>
				<%}%>
		</tr>

		<%	while (result2.next()) {		%>
			<tr onmouseover="ChangeColor(this, true);"
				onmouseout="ChangeColor(this, false);"
				onclick="doNav(<%=result2.getString("itemID")%>);">
				<td><%=result2.getString("itemID") %></td>
				<td><%=result2.getString("subcategory")%></td>
				<td><%=result2.getString("title") %></td>
				<td><%=result2.getString("currBid") %></td>
				<td><%=result2.getDate("endDate") %></td>
				<%if(subcategory.equals("tops")){ %>
					<td><%=result2.getString("size")%></td>
					<td><%=result2.getString("topType")%></td>
					<td><%=result2.getString("color")%></td>
					<td><%=result2.getString("material")%></td>
				<%}else if(subcategory.equals("bottoms")){ %>
					<td><%=result2.getString("waistSize")%></td>
					<td><%=result2.getString("length")%></td>
					<td><%=result2.getString("color")%></td>
					<td><%=result2.getString("material")%></td>
				<%}else if (subcategory.equals("shoes")){%>
				 	<td><%=result2.getString("shoeSize")%></td>
					<td><%=result2.getString("shoeType")%></td>
					<td><%=result2.getString("color")%></td>
					<td><%=result2.getString("brand")%></td>
				<%}%>
			</tr>
		<% }
		result2.close();
		con.close();%>
	</table>

	<%

	} catch (Exception ex) {
		throw(ex);
		//out.print("Auction History Search Failed :()");
	}
%>

<br><br>
		<form method="get" action="<%=session.getAttribute("userType").toString() %>Session.jsp">
				<input type="submit" value="Return to Home Page">
		</form>


</body>
</html>