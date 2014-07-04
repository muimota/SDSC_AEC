class waveVisualization extends facadeVisualization{
  color lineColor,colorYes,colorNo;
  int lineRow,yesRow,noRow;
  int lineWidth;
  int lineAlpha,linePos;//k.i.t.t effect
  int waveRow[];
  
  waveVisualization(color _colorYes,color _colorNo,color _lineColor, int _lineWidth){ 
    visualizationName = "wavesVisualization";
    lineColor = _lineColor;
    lineAlpha = 0;
    lineWidth = _lineWidth;
    colorYes  = _colorYes;
    colorNo   = _colorNo;
    linePos=0;
    waveRow = new int[20];
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
      if(vote<0){
        seq.add(Ani.to(this,2 ,"yesRow",   lineRow+4 ,Ani.BACK_IN_OUT));
        seq.add(Ani.to(this,2 ,"yesRow",   lineRow ,Ani.BACK_IN_OUT));
      }else{
        seq.add(Ani.to(this,2 ,"yesRow",   lineRow-4 ,Ani.BACK_IN_OUT));
        seq.add(Ani.to(this,2 ,"yesRow",   lineRow ,Ani.BACK_IN_OUT));
      }
    seq.endSequence();
    seq.start(); 
  }
  
  void update(){
    
    if(frameCount%2==0){
      for(int i=19;i>0;i--){
          waveRow[i]=waveRow[i-1];
      }
    }
    waveRow[0]=yesRow+round(random(1));
  }
   
  void draw(){
    
   for(int i=0 ;i<20;i++){
     fill(colorYes);
     rect(20+i,0,1,waveRow[i]);
     rect(20-i-1,0,1,waveRow[i]);
     fill(colorNo);
     rect(20+i,waveRow[i],1,24-waveRow[i]);
     rect(20-i-1,waveRow[i],1,24-waveRow[i]);
   } 
  
  } 
}

