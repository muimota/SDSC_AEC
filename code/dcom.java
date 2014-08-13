package com;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


public class dcom extends DatabaseCom {
  
  DashboardListener listener; 
  int heartStatus =  0;
  long lastVerify; //last time db was verified
  
  public dcom(){      
    super();
  }
  public dcom(String _host,String _port,String _dbName,String _username,String _pw){
	  super(_host,_port,_dbName,_username,_pw);
  }
  
  public DashboardListener getListener() {
    return listener;
  }

  public void setDashboardListener(DashboardListener listener) {
    this.listener = listener;
  }
  
  public void start(){
	  super.start();
	  lastVerify = System.currentTimeMillis();
  }
  
  /** just see every once in a while of the DB connection is still valid */
	public void validateDBConnection(){
		
		try {
			boolean isClosed = connection.isClosed();
			System.out.println("DashboardDatabaseCom::validateDBConnection() isClosed=" + isClosed);
			
			//recreate connection of closed 
			if (isClosed) {
				System.out.println("DashboardDatabaseCom::validateDBConnection() recreating... the connection!");
				connection = null;
				Class.forName("com.mysql.jdbc.Driver").newInstance();
				connection = DriverManager.getConnection(connectionURL, username, pw);
				System.out.println(connection.toString());
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (NullPointerException e) {
			e.printStackTrace();
		}
	
}

 
  
/** Downloads from the DB all participants who have submitted feedback for the specified category */
public void run() {
	while (running) {
    	
		Statement stmt   = null;
		ResultSet rs   = null;
		//heart
		try {
			//heart
			int heart = getHeart();
			//has been updated
    	if(heartStatus != heart){
    		heartStatus = heart;
    		listener.specialCategorySelected(heartStatus);
    	}
    	
        //category
    	boolean isCatNew = queryCategory();
        
    	if(activeCategoryID==-1){
    		continue;
    	}
    	
        if (isCatNew) {
          reset(); 
        }
          stmt = connection.createStatement();
        
          String sqlString = "select * from participants where categoryID=" 
          + activeCategoryID 
          + " AND timestamp>" 
          + dbLastTimestamp;
          
          //System.out.println(sqlString);
          
          if (stmt.execute(sqlString)) {
        	  rs = stmt.getResultSet();
	      } else {
	    	  System.err.println("select failed");
	      }
	  
          //------------------------------reset DB communication variables
          int resultCounter = 0;     
          //----------------save current last timestamp for comparison 
          long tmpStamp    = dbLastTimestamp; 
          
          //read new results from DB 
          while (rs.next()) {
            String cardID = rs.getString(1);
            int devID     = rs.getInt(2);
            int catID     = rs.getInt(3);
            int prefID    = rs.getInt(4);
            tmpStamp      = rs.getLong(5);
            
            DatabaseParticipant participant = new DatabaseParticipant(cardID, devID, catID, prefID, tmpStamp);
            dbParticipants.add(participant);
            resultCounter++; 
            dbLastTimestamp = (dbLastTimestamp<tmpStamp) ? tmpStamp : dbLastTimestamp; //having always the most recent tmpStamp 
            
          }
          dbNumNewParticipants = resultCounter;
          
          //If it is not a new category notify all the new participants to the listener 
          if (!isCatNew) {
            int totalParticipants = dbParticipants.size();
            for(int i= totalParticipants - dbNumNewParticipants;i<totalParticipants;i++){
              DatabaseParticipant participant = dbParticipants.get(i);
              listener.sentimentSubmitted(participant.getPrefID(), participant.getCardID());
            }
          }else{
        	  listener.categorySelected(activeCategoryID);
          }
          
          
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
              if (rs != null) {
                  try {
                      rs.close();
                  } catch (SQLException ex) { /* ignore */ }
                  rs = null;
              }
              if (stmt != null) {
                  try {
                      stmt.close();
                  } catch (SQLException ex) { /* ignore */ }
                  stmt = null;
              }
          }
		//verify db connection
		
		long currentTimeMillis = System.currentTimeMillis();
		if((currentTimeMillis-lastVerify)>10000){
			validateDBConnection();
			lastVerify=currentTimeMillis;
		}
    }
  }
  public int getHeart(){
	int num = 0; 
	Statement stmt 	= null;
    ResultSet rs 	= null;
		
      try {
      	 stmt 	= connection.createStatement();
      	 rs 	= stmt.executeQuery("select value from heart");

      	 while (rs.next()) {
      		 num = rs.getInt(1);
      	 }
      } catch (Exception e) {
      	e.printStackTrace(); 
      } finally {
          if (rs != null) {
              try {
                  rs.close();
              } catch (SQLException ex) { /* ignore */ }
              rs = null;
          }
          if (stmt != null) {
              try {
                  stmt.close();
              } catch (SQLException ex) { /* ignore */ }
              stmt = null;
          }
      }
	return num;
  }
  
}

