class barVisualization extends facadeVisualization{
  color lineColor,colorYes,colorNo;
  int lineRow,yesRow,noRow;
  int lineWidth;
  int lineAlpha,linePos;//k.i.t.t effect
  
  
  barVisualization(color _colorYes,color _colorNo,color _lineColor, int _lineWidth){ 
    visualizationName = "stripeVisualization";
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
    int time=1;
    lineRow = round(map(yesVotes,0,totalVotes,0,24));
    Ani.killAll();
    AniSequence seq = new AniSequence(Ani.papplet());
    seq.beginSequence();
    yesRow=noRow=0;
    seq.add(Ani.to(this,time ,"yesRow",lineRow ,Ani.LINEAR));
    seq.add(Ani.to(this,time ,"noRow" ,24-lineRow ,Ani.LINEAR));
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
    seq.beginStep();
      seq.add(Ani.to(this,2 ,"yesRow",0 ,Ani.LINEAR));
      seq.add(Ani.to(this,2 ,"noRow" ,0 ,Ani.LINEAR));
    seq.endStep();
    seq.beginStep();
      seq.add(Ani.to(this,1 ,"lineAlpha",255 ,Ani.LINEAR));
      seq.add(Ani.to(this,1 ,"linePos" ,40 ,Ani.LINEAR));
    seq.endStep();
    seq.add(Ani.to(this,1 ,"linePos" ,40*2 ,Ani.LINEAR));
    seq.beginStep();
      seq.add(Ani.to(this,1 ,"lineAlpha",0 ,Ani.LINEAR));
      seq.add(Ani.to(this,1 ,"linePos" ,40*3 ,Ani.LINEAR));
    seq.endStep();
     
    if(vote<0){
      seq.add(Ani.to(this,1 ,"yesRow",lineRow ,Ani.LINEAR));
      seq.add(Ani.to(this,1 ,"noRow" ,24-lineRow ,Ani.LINEAR));
    }else{
      seq.add(Ani.to(this,1 ,"noRow" ,24-lineRow ,Ani.LINEAR));
      seq.add(Ani.to(this,1 ,"yesRow",lineRow ,Ani.LINEAR));
    }
    seq.endSequence();
    seq.start(); 
  }
  
   
  void draw(){
    
   fill(colorYes);
    rect(0,0,40,yesRow);
   fill(colorNo);
   rect(0,24-noRow,40,noRow);
   if(lineAlpha>0){
     int lineLength = 30;
     for(int i=0;i<lineLength;i++){
       fill(color(red(lineColor),green(lineColor),blue(lineColor),map(i,0,lineLength,0,lineAlpha)));
       rect((linePos+i)%40,lineRow-floor(lineWidth/2.0),1,lineWidth);
     }
   }
  
  } 
}
