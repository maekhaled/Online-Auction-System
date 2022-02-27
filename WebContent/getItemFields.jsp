<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.LocalDateTime,java.text.SimpleDateFormat,java.util.Date   "%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<% try {
	if(session.getAttribute("username")==null){
		response.sendRedirect("welcome.jsp");
	}
	
			//Get the database connection
			//ApplicationDB db = new ApplicationDB();	
			//Connection con = db.getConnection();		

			//Statement stmt = con.createStatement();
			
			
			String subCategory = request.getParameter("command");
			session.setAttribute("subCategory", subCategory);
			out.println("<h2>"+subCategory+"</h2><br>" );
			List<String> fields = new ArrayList<String>();
			String[] arr ;
			
			if(subCategory.equals("tops")){ 
				arr = new String[] {"size" , "topType" , "color", "material"};
				fields = Arrays.asList(arr);
				
			}else if(subCategory.equals("bottoms")){  
				arr = new String[] {"waistSize" , "length" , "color", "material"};
				fields =  Arrays.asList(arr);
				
			}else if(subCategory.equals("shoes")){
				arr= new String[] {"shoeSize" , "shoeType", "color", "brand","material"};
				fields = Arrays.asList(arr);
				
			}
			
		
			
		%>
			
			
			<form method="post" action="post_Item.jsp">
			
			Title
			<input type="text"  size="40" required name="title"><br>
			<% session.setAttribute("cols",fields);
			
			
			for(String s: fields){%>
				<%out.println(s+":"); %>
				<input type="text" size="40" name="<%=s %>"  <% if(s.equals("size") && (subCategory.equals("tops"))){
					
					%> placeholder = "x-small, small, medium, large, x-large"
					
					<% 
				} %> > <br>
			
			
			<%}
			
			%><br><br>
			Details
			<textarea  name="dtl"
					rows="6" cols ="33">
			</textarea><br><br><br>
			Initial Price:
			<input type="number" step="0.01" min="0.01" required name="Item_price"><br>
			Minimum Price:
			<input type="number" step="0.01" min="0.01" name="Item_min_price"><br>
			Increment Price:
			<input type="number" step="0.01" min="0.01" required name="Item_inc"><br>
			<br>
			Until:
			<input type="datetime-local" size="40" name="Item_till" placeholder = "yyyy-MM-ddTHH:mm:ss" ><br>
			<input type="submit" value="submit" />
			</form>
			<% 
			
		}catch(Exception e){
			out.println(e.getMessage());
		}
		%>

</body>
</html>