<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>User History</title>
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
		

		String query = "SELECT itemID, buyerID, sellerID, subcategory, title, bidPrice, sold FROM postItem JOIN placeBidOn USING (itemID) WHERE buyerID = ? OR sellerID = ?";
		
		PreparedStatement ps = con.prepareStatement(query);

		String username = request.getParameter("username");
		ps.setString(1, username);
		ps.setString(2, username);
		
		ResultSet result = ps.executeQuery();
	%>
	

User Bid/Post History
<br><br>
	<table border='1'>
		<tr>
			<td>ItemID</td>
			<td>BuyerID</td>
			<td>SellerID</td>
			<td>Item Type</td>
			<td>Title</td>
			<td>Bid Amount</td>
			<td>Sold</td>
		</tr>

		<% 	while (result.next()) {		%>
			<tr onmouseover="ChangeColor(this, true);"
				onmouseout="ChangeColor(this, false);">
				<td><%=result.getString("itemID") %></td>
				<td><%=result.getString("buyerID") %></td>
				<td><%=result.getString("sellerID") %></td>
				<td><%=result.getString("subcategory") %></td>
				<td><%=result.getString("title") %></td>
				<td><%=result.getString("bidPrice") %></td>
				<td><%=result.getString("sold") %></td>
			</tr>
		<% } 
	
			ps.close();%>
	</table>



	<%

			//close the connection.
			con.close();

	} catch (Exception ex) {
		out.print(ex);
		out.print("Auction History Search Failed :()");
	}
%>

<br><br>
		<form method="get" action="<%=session.getAttribute("userType").toString() %>Session.jsp">
				<input type="submit" value="Return to Home Page">
		</form>


</body>
</html>