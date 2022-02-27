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
<table>
  <tr>
    <td>
    	<form method="get" action='createTicket.jsp'>
			<label>Submit a Support Ticket:</label><br><br>
			<label>Subject</label><br>
			<input type="text" name="subject" required><br><br>
			<label>Description</label><br>
			<textarea name="desc" cols="40" rows="5" maxlength="4000" onkeyup="textCounter(this, 'counter', 4000);" id="message" required></textarea>
			<br><br>
			<input disabled  maxlength="3" size="5" value="4000" id="counter"><label>/4000 Characters Remaining</label>
			<input type="submit" value="Submit Ticket">
			<script>
				function textCounter(field, field2, maxlimit) {
					var countfield = document.getElementById(field2);
				 	if (field.value.length > maxlimit) {
				 		field.value = field.value.substring( 0, maxlimit );
				  		return false;
				 	} else {
				  		countfield.value = maxlimit - field.value.length;
				 	}
				}
			</script>
		</form>
	</td>
  </tr>
</table>



<br><br>
	<form method="get" action="customerSession.jsp">
			<input type="submit" value="Return to Home Page">
	</form>
	
</body>
</html>