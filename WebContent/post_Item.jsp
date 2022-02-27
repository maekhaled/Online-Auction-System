<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.sql.*,java.time.LocalDateTime,java.text.DecimalFormat  "%>

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
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			

		
		int itemid = 111344;
		//out.println(request.getParameter("Item_price"));
		
		
		float itemprice = Float.parseFloat( request.getParameter("Item_price"));
		float itemminprice = Float.parseFloat( "0");
		float iteminc = Float.parseFloat( request.getParameter("Item_inc"));
		String title = request.getParameter("title");
		String detail = request.getParameter("dtl");
		
		if(request.getParameter("Item_min_price").isBlank() ){
			itemminprice = itemprice;
		}else{
			itemminprice = Float.parseFloat(request.getParameter("Item_min_price"));
		}
		
		
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH-mm-ss");
		 
		if(request.getParameter("Item_till").isBlank()){
			throw new IllegalArgumentException("end date : yyyy-MM-dd HH-mm-ss");
		}
		
		LocalDateTime dateTime = LocalDateTime.parse(request.getParameter("Item_till"));
		
		//out.print(session.getAttribute("name")+" "+"<br>"+dateTime);
		
		LocalDateTime dateChk = dateTime.minusHours(1);
		
		
		//out.print("<br>"+dateTime +"<br>"+dateChk +"<br>" +LocalDateTime.now()+"<br>");
		
		if(dateChk.isBefore(LocalDateTime.now())){
			throw new IllegalArgumentException("Auction time should be atleat 1 hour");
		}
		
		String str;
		Boolean error =false;
		out.println(session.getAttribute("subCategory").equals("tops"));
		
		if(session.getAttribute("subCategory").equals("tops")){
			try{
				String size = request.getParameter("size");
				if (!(size.equals("x-small") || size.equals("small") || size.equals("medium") || size.equals("large") || size.equals("x-large")) ){
					throw new IllegalArgumentException("size must be one of 'x-small', 'small', 'medium', 'large', 'x-large' <br>");
				}
				String topType = request.getParameter("topType");
				String color = request.getParameter("color");
				String mat = request.getParameter("material");
			}catch(Exception e){
				error=true;
				out.println("Input Invalid");
				out.println("<br>"+ "Category tops (field:type)  <br>size:string  <br>topType:string <br>color:string <br>material:string <br>");
				out.print("<br>"+e.getMessage());
			}
			
			
		}else if(session.getAttribute("subCategory").equals("bottoms")){
			
			try{
				Float waistSize = Float.parseFloat(request.getParameter("waistSize"));
				Float length = Float.parseFloat(request.getParameter("length"));
				String color = request.getParameter("color");
				String mat = request.getParameter("material");
			}catch(Exception e){
				error=true;
				out.println("Input Invalid");
				out.println("<br>"+ "Category bottoms (field:type)  <br>waistsize:float  <br>length:float <br>color:string <br>material:string <br>");
				out.print("<br>"+e.getMessage());
			}
			
			
		}else if(session.getAttribute("subCategory").equals("shoes")){
			try{
				String color = request.getParameter("color");
				String mat = request.getParameter("material");
				Float shoeSize = Float.parseFloat(request.getParameter("shoeSize"));
				String shoeType = request.getParameter("shoeType");
				String brand = request.getParameter("brand");
			}catch(Exception e){
				error=true;
				out.println("Input Invalid");
				out.println("<br>"+ "Category shoes (field:type)  <br>shoeSize:float  <br>shoeType:string <br>color:string <br>brand:string <br> material:string<br>");
				out.print("<br>"+e.getMessage());
			}
			
			
		}
		
		
		if(error){
			throw new IllegalArgumentException("Invalid");
		}
		
		Statement stmt = con.createStatement();
		//Get the selected radio button from the index.jsp
		
	
		str = "SELECT max(p.itemID) FROM postitem p";
		//Run the query against the database.
		ResultSet result = stmt.executeQuery(str);
		result.next();
		
	
		
		if(result.getInt(1)==0){
			itemid=1;
		}else{
			itemid = result.getInt(1)+1;
		}
		
		//out.print(session.getAttribute("name"));

		
		out.print(str+"<br>");
		str = "INSERT ignore INTO seller(username) value ('"+session.getAttribute("username").toString()+"')";
		stmt.executeUpdate(str);
	
		
		
		
		
		
		String insert = "INSERT INTO postitem(sellerid,itemid,endDate,initialPrice,minPrice,increment,sold,subcategory,title,details,currBid)"
				+ "VALUES (?,?,?,?,?,?,?,?,?,?,?)";
		PreparedStatement ps = con.prepareStatement(insert);
		ps.setString(1, session.getAttribute("username").toString());
		ps.setInt(2, itemid);
		//ps.setString(4, request.getParameter("Item_till"));
		ps.setString(3, formatter.format(dateTime));
		ps.setFloat(4,itemprice);
		ps.setFloat(5,itemminprice);
		ps.setFloat(6,iteminc);
		ps.setString(7,"false");
		ps.setString(8,session.getAttribute("subCategory").toString());
		ps.setString(9,title);
		ps.setString(10,detail);
		ps.setFloat(11,itemprice);
		ps.executeUpdate();	

		
	
		
		
		if(session.getAttribute("subCategory").equals("tops")){
			String size = request.getParameter("size");
			String topType = request.getParameter("topType");
			String color = request.getParameter("color");
			String mat = request.getParameter("material");
			
			str = "INSERT INTO tops(itemID, size, topType, color,material) VALUE" +
				"("+ itemid +",'"+size+"','"+topType+"','"+color+"','"+mat+"')";
			
		}else if(session.getAttribute("subCategory").equals("bottoms")){
			
			Float waistSize = Float.parseFloat(request.getParameter("waistSize"));
			Float length = Float.parseFloat(request.getParameter("length"));
			String color = request.getParameter("color");
			String mat = request.getParameter("material");
			
			str = "INSERT INTO bottoms(itemID, waistSize, length, color,material) VALUE" +
				"("+ itemid +","+waistSize+","+length+",'"+color+"','"+mat+"')";
			
		}else if(session.getAttribute("subCategory").equals("shoes")){
			String color = request.getParameter("color");
			String mat = request.getParameter("material");
			Float shoeSize = Float.parseFloat(request.getParameter("shoeSize"));
			String shoeType = request.getParameter("shoeType");
			String brand = request.getParameter("brand");
			
			str = "INSERT INTO shoes(itemID, shoeSize, shoeType,color,brand,material) VALUE" +
				"("+ itemid +","+shoeSize+", '"+shoeType+"', '" +color+"','"+brand+ "','"+ mat+"')";
			
		}
		
		//out.println(str);
		stmt.executeUpdate(str);
		
		
		db.closeConnection(con);
		session.setAttribute("monitor_Action", "posted_item");
		//response.sendRedirect("page_ItemPost.jsp");
		out.print("<br><br>insert succeeded");
		
	} catch (Exception ex) {
		out.print(ex);
		session.setAttribute("monitor_Action", "invalid_post");
		
		//response.sendRedirect("page_ItemPost.jsp");
		out.print("<br><br>insert failed");
	}
	%>
	
	<br>
	

</body>
</html>