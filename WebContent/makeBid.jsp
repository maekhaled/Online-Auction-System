
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.sql.*, java.text.DecimalFormat  "%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>


<% 
 try {
	 if(session.getAttribute("username")==null){
			response.sendRedirect("welcome.jsp");
		}
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			Statement stmt2 = con.createStatement();
			
			String[] strArr = session.getAttribute("controlDetails").toString().split(" ");
			//out.print("hello "+);
			for(String s: strArr){
				//out.println(s+" ");
			}
			
			
			int bidnum=1;
			int bidID =1;
			float currBid = 0;
			float currInc = Float.parseFloat(strArr[3]);
			String str = "Select max(bidID) num from placebidon";
			ResultSet result = stmt.executeQuery(str);
			result.next();
			if(result.getInt(1)!=0){
				bidID = result.getInt(1)+1;
			}
			//Run the query against the database.
			str = "Select max(bidSeq) num, bidPrice, bidID from placebidon where itemID = "+ strArr[1];
			result = stmt.executeQuery(str);
			ResultSet result2;
		
			result.next();
			
			
			
			if(result.getString("num")!=null){
				bidnum = Integer.parseInt( result.getString("num"))+1;
				currBid =  Float.parseFloat( result.getString("bidprice"));
				
			
			}
			else{
				str = "Select i.initialPrice, i.increment from postitem i where i.itemID = "+ strArr[1];
				result2 = stmt2.executeQuery(str);
				result2.next();
				currBid = Float.parseFloat(result2.getString("initialPrice"));
				
			}
			
		

			
		
			 //out.println(Float.parseFloat(request.getParameter("us_bidMax")));
	        str = "INSERT ignore INTO buyer(username) value ('"+session.getAttribute("username").toString()+"')";
			stmt.executeUpdate(str);
			
			
			
			String buyerid = session.getAttribute("username").toString();
			int itemID = Integer.parseInt(strArr[1]);
			float bidprice = Float.parseFloat(request.getParameter("us_bid"));
			float maxprice = Float.parseFloat("0.0");
			
			if(request.getParameter("us_bidMax").isBlank()){
				
				maxprice = bidprice;
			}else{
				maxprice = Float.parseFloat( request.getParameter("us_bidMax"));
			}
			
		
			
			if(bidprice < currBid+currInc || maxprice<bidprice){
				//
				throw new IllegalArgumentException("Your Bid should higher that current Bid and \nMax Price should greater than your Bid");
			}
			
	
			//Make an insert statement for the Sells table:
			String insert = "INSERT INTO placebidon(bidID,bidSeq,itemID,buyerid,bidPrice,max,messaged)"
					+ "VALUES (?,?,?,?,?,?,?)";
			PreparedStatement ps = con.prepareStatement(insert);

			ps.setInt(1,bidID);
			ps.setInt(2,bidnum);
			ps.setInt(3, itemID);
			ps.setString(4, buyerid);
			ps.setFloat(5, bidprice);
			ps.setFloat(6, maxprice);
			ps.setString(7,"false");
			ps.executeUpdate();

			
			out.println("Bid placed!! " + strArr[0] + " "+ buyerid);
			
			
			float postinc = Float.parseFloat(strArr[3]);
			
			float nxtBid = postinc + bidprice;
			
			
			
			//Run the query against the database.
			str = "UPDATE postitem p SET currBid = "+ bidprice +" WHERE p.itemID = " +Integer.parseInt(strArr[1]);
			stmt.executeUpdate(str);
			
			db.closeConnection(con);
		
			db.AutoBidding(Integer.parseInt(strArr[1]), buyerid);
			
			//close the connection.
			
			%>
			Back to sale <a href="sale.jsp">Post</a>
			<% 
			

			
		} catch (Exception e) {
			out.print(e);
		}%>



</body>
</html>