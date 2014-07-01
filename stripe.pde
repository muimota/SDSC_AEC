class stripeVisualization extends facadeVisualization{
  color lineColor,lineAlpha;
  int yesVotes,noVotes;
  int lineRow;
  int lineWidth;
  
  
  stripeVisualization(color _lineColor, int _lineWidth ){ 
    lineColor = _lineColor;
    lineAlpha = 1;
    lineWidth = _lineWidth;
  }
  
  
  void initVotes(ArrayList<Integer> votes){
    float ratio;
    int totalVotes = votes.size();
    yesVotes=noVotes=0;
    for(int i=0;i<totalVotes;i++){
      if(votes.get(i)<0){
        yesVotes++;
      }else{
        noVotes++;
      }
    }
    updateLine(3);
  }
  
  
  void updateLine(float time){
    int totalVotes = yesVotes + noVotes;
    Ani.killAll() ;
    Ani.to(this,time,"lineRow",floor(map(yesVotes,0,totalVotes,0,24)));
  }
  
  void addVote(int vote){
    if(vote<0){
      yesVotes++;
    }else{
      noVotes++;
    }
    updateLine(2);
  }
    
   
  void draw(){
    
   lineAlpha  = round(map(sin(frameCount*0.06),-1,1,128,255));
   fill(color(red(lineColor),green(lineColor),blue(lineColor),lineAlpha));
   rect(0,lineRow-floor(lineWidth/2.0),40,lineWidth);
  
  } 
}
