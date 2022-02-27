package com.cs336.pkg;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.util.Random;

import com.cs336.pkg.ApplicationDB;
import com.mysql.jdbc.Statement;

public class ApplicationDB {
	
	public ApplicationDB(){
		
		checkPostDeadline();
		
	}

	private void checkPostDeadline() {
		
		//DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");  
		//LocalDateTime now = LocalDateTime.now();  
		//dtf.format(now);
		try {
			//ApplicationDB db = new ApplicationDB();	
			Connection con = getConnection();
			Statement stmt = (Statement) con.createStatement();
			String str = "SELECT *  FROM postitem i where DATE(i.endDate) <= curdate() and sold = 'false'" ;
			str = "SELECT *  FROM postitem i where sold = 'false'" ;
			ResultSet result = stmt.executeQuery(str);
			//List<String> auctionsEnded = new ArrayList<String>();
			
			LocalDateTime time;
			while(result.next()) {
				
				str = result.getString("endDate").substring(0,result.getString("endDate").length()-2).replace(" ","T");
				time =LocalDateTime.parse(str);
				
				if(time.isBefore(LocalDateTime.now())) {
					
				
					float reserve = result.getFloat("minPrice");
					Statement stmt2 = (Statement) con.createStatement();
					ResultSet result2;
					str = "SELECT * from (SELECT max(bidprice) bid, b.buyerID from placebidon b where b.itemID = "+ result.getInt("itemID") + ") t1" ;
					result2 = stmt2.executeQuery(str);
					result2.next();
					String ticketNumber = "" + System.currentTimeMillis() + "" + new Random().nextInt(10);
				
					str = "INSERT INTO tickets(ticketNumber, submissionUser, subject, assignedRep)"
						+ "VALUES (?, ?, ?, ?)";
					PreparedStatement ps = con.prepareStatement(str);
				
					//System.out.print(reserve + " " + result.getInt("itemID") +" "+result2.getFloat("bid"));
					if(result2.getFloat("bid") == 0.0) {
					// no bids and auction ended
				
		
						//System.out.print("ended ");
					
					}else if(result2.getFloat("bid") - reserve >= 0 ) {
						//if no reserve the highest bidder is winner
						str = "You have won the auction!!  Title: " + result.getString("title")+" Sub-Category: "+ result.getString("subcategory")+
							" Details: "+ result.getString("details")+ " Bid At: "+result.getFloat("currBid");
						ps.setString(1, ticketNumber);
						ps.setString(2, result2.getString("buyerID"));
						ps.setString(3, "You have won the auction!! item ID: "+ result.getString("itemID"));
						ps.setString(4, "system");
					
						ps.executeUpdate();
					
						// sold
						Statement stmt3 = (Statement) con.createStatement();
						str = "UPDATE postitem i SET sold ='true' where i.itemID = "+ result.getInt("itemID") ;
						stmt3.executeUpdate(str);
					
					
					
						//System.out.print("price equal or greater ");
								
					}else if(result2.getFloat("bid") - reserve < 0 ) {
						//no winner close auction
						//Statement stmt3 = (Statement) con.createStatement();
						//str = "UPDATE postitem SET "
					
					
						//System.out.print("price is smaller ");
					}
	
				}
			}
		
			closeConnection(con);
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	
	}

	
	public void AutoBidding(int item, String currBidder) {
		
		
		// Pass item ItemID
		
		int itemID = item;
		int bidSeq = 0;
		float currBid = (float) 19.0;
		float inc = (float) 3.4;
		float NEXTBid = currBid + inc;
		
	

		//Create a SQL statement
		Statement stmt;
		String str;
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			stmt = (Statement) con.createStatement();
			str = "SELECT count(*) cnt FROM placebidon where itemID ="+item + " group by itemID";
			ResultSet result = stmt.executeQuery(str);
			
			System.out.println("ff "+ item + " "+ currBidder);
			
			if(result.next()==false){
				// its empty
				
				//System.out.print("<h2> from auto none </h2>");
				db.closeConnection(con);
				return;
			}
			else {
				bidSeq= result.getInt(1);
				//System.out.print("<h2> from auto "+ result.getInt(1) + " "+ currBidder);
				// return if Bids for that auction is only 1, close connection 
			}
			
			
			str = "Select i.increment, i.endDate from postitem i where i.itemID = "+ itemID;
			result = stmt.executeQuery(str);
			result.next();
			inc = result.getFloat("increment");
			
			//DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			//LocalDateTime dateTime = LocalDateTime.parse(result.getDate("endDate"), formatter);
			str = result.getString("endDate");
			
			str = result.getString("endDate").substring(0,result.getString("endDate").length()-2).replace(" ","T");

			LocalDateTime enddateTime = LocalDateTime.parse(str);
			
			
			
			System.out.println("ff1: " + inc);
			
			
			str = "Select max(b.bidPrice) from placebidon b where b.itemID = "+ itemID;
			result = stmt.executeQuery(str);
			result.next();
			currBid = result.getFloat(1);
			
			DecimalFormat df = new DecimalFormat("0.00");
			
			NEXTBid = Float.parseFloat(df.format(currBid + inc));
			
			System.out.println("in bidding "+ NEXTBid + " is the next bid");
			
		
			
			//check that only 1 for that auction is not maxed return when only 1
			//str = "Select distinct b.buyerID, count(*), messaged From bid b where itemID = "+ 1111 + 
			//		" and b.maxprice - "+ NEXTBid +" >= -0.003 group by b.buyerid" ; 
			
			
			
			str = "SELECT distinct b.max, b.buyerID "+
					"From placebidon b "+
					"where b.itemID = " + itemID+ " and b.max - " + NEXTBid + " >= -.003 "+
					"and b.buyerID <> '"+ currBidder +"' "+ 
					"and b.messaged = 'false' "+
					"order by b.max asc";
		
			
			System.out.println(str);
			result = stmt.executeQuery(str);
			int cnt = 0;
			
			
			String bidder="";
			Float bidderMax=(float) 0.0;
			
			while(result.next()) {
				cnt+=1;
				if(cnt ==1){
					bidder = result.getString("buyerID");
					bidderMax = result.getFloat("max");
				}
				
				
			}
			System.out.println("The cnt "+ cnt + " "+ currBid +" "+ NEXTBid + " "+currBidder +" "+ bidder);
			if(cnt ==0) {
				/*
				str = "SELECT distinct b.max, b.buyerID"+
						"From placebidon b "+
						"where b.itemID = " + itemID+
						"and b.buyerID <> '"+ currBidder +"' "+
						"order by b.max asc";
				
				*/
				str = "SELECT DISTINCT * FROM placebidon b where b.itemID = "+itemID+" and b.buyerID <> '"+ currBidder +"' and b.messaged = 'false' "+
						"group by b.buyerID"; 
				Statement stmt3 = (Statement)con.createStatement();
				result = stmt3.executeQuery(str);
				
				//System.out.println(str);
				
				String ticketNumber;
				str = "INSERT INTO tickets(ticketNumber, submissionUser, subject, assignedRep)"
						+ "VALUES (?, ?, ?, ?)";
				PreparedStatement ps = con.prepareStatement(str);
				Statement stmt2 = (Statement)con.createStatement();
				while(result.next()) {
					System.out.println(str);
					ticketNumber = "" + System.currentTimeMillis() + "" + new Random().nextInt(10);
					ps.setString(1, ticketNumber);
					ps.setString(2, result.getString("buyerID"));
					ps.setString(3, "Bid surpassed for  item ID: "+itemID) ;
					ps.setString(4, "system");
						
					ps.executeUpdate();
						
						
					str ="UPDATE placebidon SET messaged = 'true' where itemID = "+itemID+" and buyerID = '"+ result.getString("buyerID")+"' and bidSeq <= "+ bidSeq;
					System.out.println(str);
					
					stmt2.executeUpdate(str);
				}
				
				// the current bidder's bid is equal to its max and other bidder reached max
			}
			if(cnt ==1) {
				// no need to bid since only 1 bid from all the bids in auction, which has maxprice greater than next bid
				//db.closeConnection(con);
				//return;
				 
			}
			if(cnt >= 1) {
				// continue recursing 
				
				
				
				//if enddate reached return
				if(enddateTime.isBefore(LocalDateTime.now())) {
					System.out.println("reched end time");
					db.closeConnection(con);
					return;
				}
				
			
				
				//find a bid which has the smallest difference BidMax - currBid
				//place bid currBid + inc for that user and recurs 
				//str = "Select distinct b.buyerID, b.maxprice, b.maxprice - "+currBid+" diff FROM bid b "
				//		+ "WHERE b.itemID = "+itemID+" and b.maxprice - "+NEXTBid+" >= -0.003 order by diff asc";
				
				

				//str = "SELECT * from bid";
				
				//result = stmt.executeQuery(str);
				//result.next();
				//str = result.getString("buyerID");
				
				// with the buyerID place next bid then recurs.
				
				//String bidder = result.getString("buyerID");
				//Float bidderMax = result.getFloat("maxprice");
				
				// place new bid with inc then recurs
				//System.out.println("next biddddd " + " "+ result.getString("buyerID"));
				
				bidSeq++;
				System.out.println("next biddddd " + bidder+ " maxBid "+ bidderMax + " "+ bidSeq +" nextBid " + NEXTBid + "last bider" + currBidder);
				
				str = "Select max(bidID) num from placebidon";
				result = stmt.executeQuery(str);
				int bidID=1;
				result.next();
				if(result.getInt(1)!=0){
					bidID = result.getInt(1)+1;
				}
				
				
				
				str = "INSERT INTO placebidon(bidID,bidSeq,itemID,buyerID,bidprice,max,messaged)"
								+ "VALUES (?, ?, ?,?,?,?,?)";
				PreparedStatement ps = con.prepareStatement(str);

				//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
				ps.setInt(1, bidID);
				ps.setInt(2, bidSeq);
				ps.setInt(3, itemID);
				ps.setString(4, bidder);
				ps.setFloat(5, NEXTBid);
				ps.setFloat(6, bidderMax);
				ps.setString(7, "false");
				
				
				ps.executeUpdate();	
				
				str = "UPDATE postitem SET currBid = "+NEXTBid+" WHERE itemID = " +itemID;
				stmt.executeUpdate(str);
				
				
				
				str = "SELECT * "+
						"From placebidon b "+
						"where b.itemID = " + itemID+
						" and b.buyerID <> '"+ bidder +"' "+ 
						"and b.messaged = 'false' "+
						"group by b.buyerID";
				
				//System.out.println(str);
				result = stmt.executeQuery(str);
				
				
				str = "INSERT INTO tickets(ticketNumber, submissionUser, subject, assignedRep)"
						+ "VALUES (?, ?, ?, ?)";
				String ticketNumber;
				
				Statement stmt2 = (Statement) con.createStatement();
				ps = con.prepareStatement(str);
				while(result.next()) {
					System.out.println(result.getFloat("max") -  (NEXTBid+inc)+" ");
					if( result.getFloat("max") -  (NEXTBid+inc) < -0.0003) {
						// auto bidder
						
						ticketNumber = "" + System.currentTimeMillis() + "" + new Random().nextInt(10);
						ps.setString(1, ticketNumber);
						ps.setString(2, result.getString("buyerID"));
						ps.setString(3, "Bid surpassed for  item ID: "+result.getInt("itemID")) ;
						ps.setString(4, "system");
							
						ps.executeUpdate();
							
							
						str ="UPDATE placebidon SET messaged = 'true' where itemID = "+itemID+" and buyerID = '"+ result.getString("buyerID")+"' and bidSeq < "+ bidSeq;
						System.out.println(str);
						
						stmt2.executeUpdate(str);
							
							
					}
						
				}
					
					
		
				
				db.closeConnection(con);
				
				
				
				
				// recursing
				AutoBidding(itemID,bidder);
				
				
			}
			
			db.closeConnection(con);
			
			
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		
		
		
		
		
	}
	
	
	
	public Connection getConnection(){
		
		//Create a connection string
		String connectionUrl = "jdbc:mysql://localhost:3306/onlineauctiondemo5";
		Connection connection = null;
		
		try {
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver").newInstance();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			//Create a connection to your DB
			connection = DriverManager.getConnection(connectionUrl, "root", "1Preetpal");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return connection;
		
	}
	
	public void closeConnection(Connection connection){
		try {
			connection.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	
	
	
	public static void main(String[] args) {
		ApplicationDB dao = new ApplicationDB();
		Connection connection = dao.getConnection();
		
		System.out.println(connection);		
		dao.closeConnection(connection);
	}
	
	

}
