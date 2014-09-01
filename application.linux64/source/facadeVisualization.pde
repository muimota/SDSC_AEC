
abstract class  facadeVisualization{
  String visualizationName;
  int yesVotes,noVotes,totalVotes;
  
  PGraphics hiFacade;  //hiresolution 400x240
  PImage    lowFacade; //low res 40x24 facade 
  
  ArrayList<Parameter> parameters;
  
  facadeVisualization(){
    hiFacade  = createGraphics(400,240);
    lowFacade = new PImage(40,24);
    parameters = new ArrayList<Parameter>();
  }
  void initVotes(int _yesVotes,int _noVotes){
    yesVotes=_yesVotes;
    noVotes=_noVotes;
    totalVotes=yesVotes+noVotes; 
  }
  void initVotes(ArrayList<Integer> votes){
    int _yesVotes=0;
    int _noVotes=0;
    for (int vote : votes){
      if(vote>0){
        _yesVotes++;
      }else{
        _noVotes++;
      }
    }
    initVotes(_yesVotes,_noVotes); 
  }
 
  
  void addVote(int vote){
    if(vote<0){
      yesVotes++;
    }else{
      noVotes++;
    }
    totalVotes=yesVotes+noVotes;
  }
  

  void  setFloatParameter(String parameterName,float parameterValue){};
  float getFloatParameter(String parameterName){return Float.NaN;};
  
  void   setColorParameter(String parameterName,color parameterValue){}
  color  getColorParameter(String parameterName){return 0;};

  
  void update(){};
  
  abstract void draw();
  
  void heart(){};
  void drawFacade(boolean pixelate){
    //TODO:pixelate should be removed, is not efficent and useless
    if(!pixelate){
      //pixelate
      hiFacade.loadPixels();
      for(int i=0;i<40;i++){
        for(int j=0;j<24;j++){
          int r = 0;
          int g = 0;
          int b = 0;
          for(int k=0;k<10;k+=2){
            for(int l=0;l<10;l+=2){
              int index = (j*400+i)*10+l*400+k;
              color c = hiFacade.pixels[index];
              r += c>>16&0xFF;
              g += c>>8&0xFF;
              b += c&0xFF;
            }
          }
          r /= 20;
          g /= 20;
          b /= 20;
          lowFacade.set(i,j,color(r,g,b));
        }
      }
    }else{
      lowFacade.copy(hiFacade,0,0,400,240,0,0,40,24);
    }
    image(lowFacade,0,0);
  }
  
  String toString(){
    int percentageOfYesVotes = (totalVotes > 0) ? round(yesVotes/float(totalVotes)*100.0) : 0;
    return "name:"+visualizationName +" totalVotes:" +totalVotes +" positiveVotes"+ yesVotes +"("+percentageOfYesVotes+"%) negativeVotes:"+noVotes+"("+(100-percentageOfYesVotes)+"%)";
  }
  
}


