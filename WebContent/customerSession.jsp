<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%// Authorization variables
Boolean success = false;
String error = "No error found";
String url = "http://localhost:8080/AuctionProject/"; %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Session Page</title>
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

  </script>
</head>
</head>
<body>

<b>Welcome to BuyMe <%=session.getAttribute("username")%>!</b>

<br><br>
Start Browsing Our Active Auctions!
<br><br>



<form method="get" action="sortandsearch.jsp">
	<table>
		<tr>
			<td>Search Filters:</td>
			<td></td>
			<td>Sort By:</td>
		</tr>
		<tr>
			<td>By Type:
					<select name="subcategory" size = 1>
						<option value="all">All</option>
						<option value="tops">Tops</option>
						<option value="bottoms">Bottoms</option>
						<option value="shoes">Shoes</option>
					</select>&nbsp;<br>
			</td>
			<td>By Current Bidding Price:
					<select name="bidPrice" size =1>
						<option value="all">All</option>
						<option value="20">$20 and under</option>
						<option value="50">$50 and under</option>
						<option value="100">$100 and under</option>
					</select>&nbsp;
	
			</td>
			<td>
				<select name="sortMethod" size =1>
					<option value="all">None</option>
					<option value="pricelh">Price: Low to High</option>
					<option value="pricehl">Price: High to Low</option>
					<option value="endDateasc">End Date: Soonest to Farthest</option>
					<option value="endDatedesc">End Date: Farthest to Soonest</option>
					<option value="numBidslh">Number of Bids: Lowest to Highest</option>
					<option value="numBidshl">Number of Bids: Highest to Lowest</option>
				</select>&nbsp;<br>
			</td>
			<td>
				<input type="submit" value="Start Browsing!">
			</td>	
		</tr>
	</table>
</form>
<br><br>
Make a post for item:
<br>
<form method="post" action="getItemFields.jsp">
		<input type="radio" required name="command" value="tops"/>Top
		 <br>
		<input type="radio" name="command" value="bottoms"/>Bottom
		<br>
		<input type="radio" name="command" value="shoes"/>Shoes
		
		<br>
		  <input type="submit" value="Post" />
		</form>

<br>
View Bid History:
<br>
	<form method="get" action="bidHistory.jsp">
		Auction Item ID: <input type="text" name="itemID">
		<input type="submit" value="Get Bid History!">
	</form>
<br>
View User Auction History:
<br>
	<form method="get" action="userHistory.jsp">
		Member Username: <input type="text" name="username">
		<input type="submit" value="Get Auction History!">
	</form>
<br>
View Auction History of Similar Items:
<br>
	<form method="get" action="similarItemHistory.jsp">
		Auction Item ID: <input type="text" name="itemID">
		<input type="submit" value="Find History of Similar Auctions!">
	</form>
<br>

Set Alerts for Item of Type:
<br>
	<form method="get" action="setAlert.jsp">
		<input type="radio" name="command" value="tops"/>Tops
		<input type="radio" name="command" value="bottoms"/>Bottoms
		<input type="radio" name="command" value="shoes"/>Shoes
		<br>
		Title: <input type ="text" name="title"/>
		<br>
		<input type="submit" value="Set Alert">
		
	</form>
<br>

Check Inbox for Messages and Alerts:
<br>
	<form method="get" action="inbox.jsp">
			<input type="submit" value="Inbox">
	</form>
<br>
Need to make a change? <a href="contactSupport.jsp">Contact our support!</a>		
<br><br>
		<form action="teardown.jsp" method ="post">
			<input type ="submit" value="Log Out">
		</form>
<br>
	
</body>
</html>