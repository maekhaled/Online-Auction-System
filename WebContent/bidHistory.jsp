<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Auction Bid History</title>
</head>
<body>
<script type="text/javascript">
    function ChangeColor(tableRow, highLight)
    {
    if (highLight)
    {
      tableRow.style.backgroundColor = '#dcfac9';
    }
    else
    {
      tableRow.style.backgroundColor = 'white';
    }
  }
    function doNav(itemId){
        var form = document.createElement("form");
        form.method="get";
        form.action= "viewPost.jsp";
        
        item = document.createElement("input");
        item.value = itemID;
        item.name = "itemID";
        form.appendChild(item);
        
        form.submit();
    }

  </script>
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		String query = "SELECT itemID, buyerID, bidPrice FROM placeBidOn WHERE itemID = ?";
		
		String itemID = request.getParameter("itemID");
		
		PreparedStatement ps = con.prepareStatement(query);

		ps.setString(1, itemID);

		ResultSet result = ps.executeQuery();
	%>
	

Auction Bid History for ItemID: <% out.print(itemID); %>
<br><br>
	<table border='1'>
		<tr>
			<td>ItemID</td>
			<td>BuyerID</td>
			<td>Bid Amount</td>
		</tr>

		<% 	while (result.next()) {		%>
			<tr onmouseover="ChangeColor(this, true);"
				onmouseout="ChangeColor(this, false);">
				<td><%=result.getString("itemID") %></td>
				<td><%=result.getString("buyerID") %></td>
				<td><%=result.getString("bidPrice") %></td>
			</tr>
		<% } %>
	</table>
	<br>


	<%

			//close the connection.
			con.close();

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