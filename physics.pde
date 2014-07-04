class physicsVisualization extends facadeVisualization{
  color lineColor,colorYes,colorNo;
  int lineRow,yesRow,noRow;
  int lineWidth;
  int lineAlpha,linePos;//k.i.t.t effect
  
  
  physicsVisualization(color _colorYes,color _colorNo,color _lineColor, int _lineWidth){ 
    visualizationName = "physicsVisualization";
    lineColor = _lineColor;
    lineAlpha = 0;
    lineWidth = _lineWidth;
    colorYes  = _colorYes;
    colorNo   = _colorNo;
    linePos=0;
  }
  
  //animacion de entrada
  void initVotes(ArrayList<Integer> votes){
    super.initVotes(votes);
    int time=2;
    lineRow = round(map(yesVotes,0,totalVotes,0,24));
    Ani.killAll();
    AniSequence seq = new AniSequence(Ani.papplet());
    seq.beginSequence();
    yesRow=noRow=0;
    seq.add(Ani.to(this,time ,"yesRow",lineRow ,Ani.CUBIC_OUT));
    seq.add(Ani.to(this,time ,"noRow" ,24-lineRow ,Ani.CUBIC_OUT));
    seq.endSequence();
    seq.start(); 
  }
  
 void addVote(int vote){
    super.addVote(vote);
    lineRow = round(map(yesVotes,0,totalVotes,0,24));
    linePos = 0;
    Ani.killAll();
    AniSequence seq = new AniSequence(Ani.papplet());
    seq.beginSequence();
      seq.add(Ani.to(this,2 ,"yesRow",   lineRow+4 ,Ani.BACK_IN_OUT));
      seq.add(Ani.to(this,2 ,"yesRow",   lineRow ,Ani.BACK_IN_OUT));
    seq.endSequence();
    seq.start(); 
  }
  
   
  void draw(){
    
   fill(colorYes);
   rect(0,0,40,yesRow);
   fill(colorNo);
   rect(0,yesRow,40,24-yesRow);
  } 
}

