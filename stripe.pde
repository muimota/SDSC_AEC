class stripeVisualization extends facadeVisualization{
  color lineColor;
  int lineRow;
  int lineWidth;
  int lineAlpha,linePos;//k.i.t.t effect
  
  
  
  stripeVisualization(color _lineColor, int _lineWidth ){ 
    visualizationName = "stripeVisualization";
    lineColor = _lineColor;
    lineAlpha = 255;
    lineWidth = _lineWidth;
  }
  
  
  void initVotes(ArrayList<Integer> votes){
    super.initVotes(votes);
    lineRow = round(map(yesVotes,0,totalVotes,0,24));
  }
  
  
  void addVote(int vote){
    super.addVote(vote);
   // lineRow = round(map(yesVotes,0,totalVotes,0,24));
    Ani.to(this,1 ,"lineRow",round(map(yesVotes,0,totalVotes,0,24)),Ani.LINEAR);
   /*
    AniSequence seq = new AniSequence(Ani.papplet());
    seq.beginStep();
      seq.add(Ani.to(this,1 ,"lineAlpha",255 ,Ani.LINEAR));
      seq.add(Ani.to(this,1 ,"linePos" ,40 ,Ani.LINEAR));
    seq.endStep();
    seq.add(Ani.to(this,1 ,"linePos" ,40*2 ,Ani.LINEAR));
    seq.beginStep();
      seq.add(Ani.to(this,1 ,"lineAlpha",0 ,Ani.LINEAR));
      seq.add(Ani.to(this,1 ,"linePos" ,40*3 ,Ani.LINEAR));
    seq.endStep();
   */
  }
    
  void update(){
    linePos +=1;
  }
 
  
  void draw(){
    
   if(lineAlpha>0){
     int lineLength = 30;
     for(int i=0;i<lineLength;i++){
       fill(color(red(lineColor),green(lineColor),blue(lineColor),map(i,0,lineLength,0,lineAlpha)));
       rect((linePos+i)%40,lineRow-floor(lineWidth/2.0),1,lineWidth);
     }
   }
    
  } 
}
