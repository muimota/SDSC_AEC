package com;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


public class dcom extends DatabaseCom {
  
  DashboardListener listener; 
  
  public dcom(){      
    super();
  }
  
  public DashboardListener getListener() {
    return listener;
  }

  public void setDashboardListener(DashboardListener listener) {
    this.listener = listener;
  }


 
  
  /** Downloads from the DB all participants who have submitted feedback for the specified category */
  public void run() {
    while (running) {
      Statement stmt   = null;
          ResultSet rs   = null;
      try {
        boolean isCatNew = queryCategory();
        
        if (isCatNew) {
          listener.categorySelected(activeCategoryID);
          reset(); 
        }
        
          stmt = connection.createStatement();
        
          String sqlString = "select * from participants where categoryID=" 
          + activeCategoryID 
          + " AND timestamp>" 
          + dbLastTimestamp;
  
          
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
            dbLastTimestamp = max(dbLastTimestamp,tmpStamp); //having always the most recent tstamp 
            dbParticipants.add(new DatabaseParticipant(cardID, devID, catID, prefID, tmpStamp));
            resultCounter++; 
            
          }
          dbNumNewParticipants = resultCounter;
          
          //If it is not a new category notify all the new participants to the listener 
          if (!isCatNew) {
            int totalParticipants = dbParticipants.size();
            for(int i= totalParticipants - dbNumNewParticipants;i<totalParticipants;i++){
              DatabaseParticipant participant = dbParticipants.get(i);
              listener.sentimentSubmitted(participant.getPrefID(), participant.getCardID());
            }
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
    }
  }
}

