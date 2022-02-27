<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE>
<!-- html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" -->

<html>
<head>
<script src="js/scripts.js"></script>


<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sort by Item Type</title>
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
						for (i = 1; i < tr.length; i++) {
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
</head>
<body>
	<%

		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			String subcategory = request.getParameter("subcategory");
			String bidPrice = request.getParameter("bidPrice");
			String sortMethod = request.getParameter("sortMethod");
			
			//String filter_query = "SELECT itemID,subcategory,title,currBid,numBids,endDate FROM postItem JOIN (SELECT itemID, count(*) numBids FROM placeBidOn GROUP BY itemID) USING (itemID) WHERE sold = 'false'";
			String filter_query = "select * from postItem left join tops using (itemID) left join bottoms using (itemID) left join shoes using (itemID) where sold = 'false'";
			String searchTitle = "";
			
			if(!subcategory.equals("all")){
				filter_query += ("AND subcategory=" + "'"+subcategory+"'");
				searchTitle += (" |	|" + " Showing Item Type(s): "+ subcategory.substring(0, 1).toUpperCase() + subcategory.substring(1) + " ");}
			if(!bidPrice.equals("all")){
				filter_query += ("AND currBid <=" + bidPrice);
				searchTitle += (" |	|" + " Showing Bid Prices: $" + bidPrice + " or less " );}
			if(!sortMethod.equals("all")){
				if(sortMethod.equals("pricelh")){
					filter_query += (" ORDER BY currBid ASC");
					searchTitle += (" |	| Sorted : Price: Low to High ");}
				if(sortMethod.equals("pricehl")){
					filter_query += (" ORDER BY currBid DESC");
					searchTitle += (" |	| Sorted: Price: High to Low  ");}
				if(sortMethod.equals("endDateasc")){
					filter_query += (" ORDER BY endDate ASC");
					searchTitle += (" |	| Sorted: End Date: Soonest to Farthest  ");}
				if(sortMethod.equals("endDatedesc")){
					filter_query += (" ORDER BY endDate DESC");
					searchTitle += (" |	| Sorted: End Date: Farthest to Soonest ");}
				if(sortMethod.equals("numBidslh")){
					filter_query += (" ORDER BY numBids ASC");
					searchTitle += (" |	| Sorted: Number of Bids: Lowest to Highest  ");}
				if(sortMethod.equals("numBidshl")){
					filter_query += (" ORDER BY numBids DESC");
					searchTitle += (" |	| Sorted: Number of Bids: Highest to Lowest  ");}	
			}
		 
			
		    if(searchTitle.equals("")){
		    	out.print("All Available Auction Items");
		    }
		    else{
		    	out.print(searchTitle + " |	| ");}
		    
			Statement stmt = con.createStatement();
			ResultSet result = stmt.executeQuery(filter_query);

	%>

<br><br>
Search Auction Items:<input type="text" id="search" onkeyup="myFunction();" placeholder="Search for ..">
<br><br>

	<table id= "table" border='1'>
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

			<% while (result.next()) { %>
			<tr onmouseover="ChangeColor(this, true);"
				onmouseout="ChangeColor(this, false);"
				onclick="doNav(<%=result.getString("itemID")%>);">
				<td><%=result.getString("itemID") %></td>
				<td><%=result.getString("subcategory") %></td>
				<td><%=result.getString("title") %></td>
				<td><%=result.getString("currBid") %></td>
				<td><%=result.getDate("endDate") %></td>
				<%if(subcategory.equals("tops")){ %>
					<td><%=result.getString("size")%></td>
					<td><%=result.getString("topType")%></td>
					<td><%=result.getString("color")%></td>
					<td><%=result.getString("material")%></td>
				<%}else if(subcategory.equals("bottoms")){ %>
					<td><%=result.getString("waistSize")%></td>
					<td><%=result.getString("length")%></td>
					<td><%=result.getString("color")%></td>
					<td><%=result.getString("material")%></td>
				<%}else if (subcategory.equals("shoes")){%>
				 	<td><%=result.getString("shoeSize")%></td>
					<td><%=result.getString("shoeType")%></td>
					<td><%=result.getString("color")%></td>
					<td><%=result.getString("brand")%></td>
				<%}%>
				</tr>
			<% } %>
			</table>

	
	
	<%
			//close the connection.
			stmt.close();
			con.close();
	
		}catch (Exception e) {
			out.print(e);
		}
		
	%>
	
<br><br>
		<form method="get" action="<%=session.getAttribute("userType").toString() %>Session.jsp">
				<input type="submit" value="Return to Home Page">
		</form>
</body>
</html>