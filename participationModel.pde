class participationModel implements DashboardListener{
  
  ArrayList<facadeVisualization> animations;
  ArrayList<Integer> votes;
  facadeVisualization anim;
  dcom dbCom;
  int catID;
  boolean categoryChanged;
  
  participationModel(ArrayList<facadeVisualization> _animations){
    votes = new ArrayList<Integer>();
    animations =  _animations;
    anim  = animations.get(0);
    anim.initVotes(votes);
    categoryChanged=false;
  }
  
  void categorySelected(int _catID){
    println("categorySelected called");
    catID = _catID;
    categoryChanged = true;
  }
  
  void updateCategory(){
    Ani.killAll();
    clearAnimationGUI();
    anim = animations.get(catID);
    updateVotes();
    println(votes.size());
    anim.initVotes(votes);
    createAnimationGUI(); 
    categoryChanged=false;
  }
  //called from main thread to check if the category has changed 
  void update(){
    if(categoryChanged){
      updateCategory();
    }   
  }
  //in the device 2 (right) negative, 1 (negative positive 
  
  void sentimentSubmitted(int prefID, String cardID){
    println(prefID);
    if(prefID==2){
        anim.addVote(1);
      }else{
        anim.addVote(-1);
      }
  }
  void specialCategorySelected(int val){
    println("heart event (" + val +")");
    if(val==0){
      anim.heart();
    }
  }
  
  
  //update votes from database
  void updateVotes(){
    votes.clear();
    ArrayList<DatabaseParticipant> participants = dbCom.getParticipants();
    
    for(DatabaseParticipant participant: participants){
     //in the device 2 (right) negative, 1 (negative positive 
     println(participant.getPrefID());
      if(participant.getPrefID()==2){
        votes.add(1);
      }else{
        votes.add(-1);
      }
    }
    println("participants:"+participants.size()+" votes:"+votes.size());
  }
}
