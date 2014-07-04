/***
STACKS
***/

class stackVisualization extends facadeVisualization{
  color yesColor, noColor, lineColor,lineAlpha;
  int yesBricks,noBricks,lineRow;
  int lineWidth;
  String name;
  
  stackVisualization(color _yesColor, color _noColor, color _lineColor, int _lineWidth ){ 
    visualizationName = "stackVisualization";
    yesColor  = _yesColor;
    noColor   = _noColor;
    lineColor = _lineColor;
    lineAlpha = 0;
    lineWidth = _lineWidth;
  }
  
  stackVisualization(color yesColor, color noColor, color lineColor){ 
    this(yesColor,noColor,lineColor,3);
  }
  
  void initVotes(ArrayList<Integer> votes){
    super.initVotes(votes);
    yesBricks = noBricks = 0;
    updateBricks(3);
  }
  
  void updateBricks(float time){
    int totalVotes = yesVotes + noVotes;
    float yesTime = map(yesVotes,0,totalVotes,0,time);
    float noTime  = map( noVotes,0,totalVotes,0,time);
    AniSequence seq = new AniSequence(Ani.papplet());
    seq.beginSequence();
    seq.add(Ani.to(this,yesTime,"yesBricks",map(yesVotes,0,totalVotes,0,24*40),Ani.LINEAR));
    seq.add(Ani.to(this,noTime ,"noBricks",map(noVotes,0,totalVotes,0,24*40)+1,Ani.LINEAR));
    seq.endSequence();
    seq.start(); 
  }
  
  void addVote(int vote){
    super.addVote(vote);
    Ani.killAll() ;
    lineRow = floor(map(yesVotes,0,totalVotes,0,24));
    lineAlpha=255;
    Ani.to(this,2,"lineAlpha",0,Ani.LINEAR,"onEnd:updateBricks");
    //Ani.Ani.EXPO_IN_OUT, "onStart:itsStarted, onEnd:newRandomDiameter"); 
    updateBricks(2);
  }
    
   
  void draw(){
    
   int offset,rows,col;
   
   //YES
   offset=ceil(yesBricks);
   rows = min(24,offset/40);
   col  = offset%40;
   
   fill(yesColor);
   rect(0,0,40,rows);
   rect(0,rows,col,1);
   
   //NO 
   offset=ceil(noBricks);
   rows = min(24,offset/40);
   col  = offset%40;
   
   fill(noColor);
   rect(0,24-rows,40,rows);
   rect(40-col,23-rows,col,1);
   
   fill(color(red(lineColor),green(lineColor),blue(lineColor),lineAlpha));
   rect(0,lineRow-floor(lineWidth/2.0),40,lineWidth);
  } 
}

