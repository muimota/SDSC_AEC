
abstract class  facadeVisualization{
  String visualizationName;
  int yesVotes,noVotes,totalVotes;
  void initVotes(ArrayList<Integer> votes){
    yesVotes=noVotes=0;
    for (int vote : votes){
      if(vote<0){
        yesVotes++;
      }else{
        noVotes++;
      }
    }
    totalVotes=yesVotes+noVotes; 
  }
  void addVote(int vote){
    if(vote<0){
      yesVotes++;
    }else{
      noVotes++;
    }
    totalVotes=yesVotes+noVotes;
  }
  void update(){};
  abstract void draw();
  
  String toString(){
 
    int percentageOfYesVotes = (totalVotes > 0) ? round(yesVotes/float(totalVotes)*100.0) : 0;
    return "name:"+visualizationName +" totalVotes:" +totalVotes +" positiveVotes"+ yesVotes +"("+percentageOfYesVotes+"%) negativeVotes:"+noVotes+"("+(100-percentageOfYesVotes)+"%)";
  }
}
