class participationModel implements DashboardListener{
  
  ArrayList<facadeVisualization> animations;
  ArrayList<Integer> votes;
  facadeVisualization anim;
  dcom dbCom;
  
  participationModel(ArrayList<facadeVisualization> _animations){
    votes = new ArrayList<Integer>();
    animations =  _animations;
    anim  = animations.get(0);
    anim.initVotes(votes);
  }
  
  void categorySelected(int catID){
    
     Ani.killAll();
     clearAnimationGUI();
     anim = animations.get(catID);
     updateVotes();
      println(catID+" -> "+votes.size() );
     anim.initVotes(votes);
     loadVisualization(anim);
     createAnimationGUI();
     
  }
  void sentimentSubmitted(int prefID, String cardID){
     if(prefID<2){
        anim.addVote(-1);
      }else{
        anim.addVote(1);
      }
      //println("participants:"+dbCom.getParticipants().size());
  }
  void specialCategorySelected(int val){
    println("heart event (" + val +")");
  }
  
  
  //update votes from database
  void updateVotes(){
    votes.clear();
    for(DatabaseParticipant participant: dbCom.getParticipants()){
      //SDSC code votes 0,1,2 here <0 >0 for positive/negative votes
      if(participant.getPrefID()<2){
        votes.add(-1);
      }else{
        votes.add(1);
      }
    }
  }
}
