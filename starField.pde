
/***
STARFIELD
***/
class Star{
  PVector pos;
  PVector speed;
  float   expression;
  int     vote;
  
  Star(){
    pos=new PVector();
    speed =new PVector();
  }
}


class starFieldVisualization extends facadeVisualization{
  ArrayList<Star> stars = null;
  int maxStars;
  color col0,col1;
  float minSpeed,maxSpeed;
  
 
  starFieldVisualization(String _visualizationName,color _col0,color _col1,float _minSpeed,float _maxSpeed, int _maxStars){
    super();
    parameters.add(new Parameter("minSpeed",0,17));
    parameters.add(new Parameter("maxSpeed",0,17));
    parameters.add(new Parameter("col0",Parameter.COLOR));
    parameters.add(new Parameter("col1",Parameter.COLOR));
    visualizationName = _visualizationName;
    col0 = _col0;
    col1 = _col1;
    minSpeed = _minSpeed;
    maxSpeed = _maxSpeed;
    maxStars = _maxStars;
  }
  starFieldVisualization(String _visualizationName,color _col0,color _col1,float minSpeed,float maxSpeed ){
    this(_visualizationName,_col0,_col1,minSpeed,maxSpeed,10000);
  }
  
  starFieldVisualization(String _visualizationName,color _col0,color _col1,int maxStars){
    this(_visualizationName,_col0,_col1,1,5,maxStars );
  }
  starFieldVisualization(String _visualizationName,color _col0,color _col1){
    this(_visualizationName,_col0,_col1,0.1,0.5 );
  }
  
   void setFloatParameter(String parameterName,float parameterValue){
    super.setFloatParameter(parameterName,parameterValue);
   
    float prevMinSpeed = minSpeed;
    float prevMaxSpeed = maxSpeed;
    
    if(parameterName.equals("minSpeed")){
      minSpeed = parameterValue;
    }else if(parameterName.equals("maxSpeed")){
      maxSpeed = parameterValue;
    }
     
    if(prevMinSpeed!=minSpeed){
        int starsCount = min(stars.size(),maxStars);
        if(stars!=null){
          for(int i=0;i<starsCount;i++){
            Star star = stars.get(i);
            star.speed.x=map(star.speed.x,0,prevMinSpeed,0,minSpeed);
          }
        }
    } 
  }
  float getFloatParameter(String parameterName){
     float returnValue = super.getFloatParameter(parameterName);
     if(parameterName.equals("minSpeed")){
       returnValue = minSpeed;
     }else if(parameterName.equals("maxSpeed")){
       returnValue = maxSpeed;
     }
     return returnValue;
  };
  
  void setColorParameter(String parameterName,color parameterValue){
    if(parameterName.equals("col0")){
       col0 = parameterValue;
     }else if(parameterName.equals("col1")){
       col1 = parameterValue;
     }
  }
  
  color getColorParameter(String parameterName){
    color parameterValue = super.getColorParameter(parameterName);
    if(parameterName.equals("col0")){
      parameterValue = col0;
    }else if(parameterName.equals("col1")){
      parameterValue = col1;
    }
    return parameterValue;
  }
  
  void initVotes(ArrayList<Integer> votes){
    super.initVotes(votes);
    stars = new ArrayList<Star>();
    int starsCount = min(votes.size(),maxStars);
    
    for(int i=0;i<starsCount;i++){
      Star star = new Star();
      //position
      star.pos.x = random(400);
      //we round it so in vertizally is always alligned to the facade
      star.pos.y = floor(random(24))*10;
      //speed
      star.speed.x=minSpeed*lerp(random(1),0.8,1.2);
      
      int voteIndex;
      //we will add all the votes
      if(starsCount>votes.size()){
        voteIndex = i;
      }else{
       //if we have to 'cluster' all the vote pick a random sample        
        voteIndex = int(random(votes.size()));
      }
      star.vote = votes.get(voteIndex);
      star.expression = 0;
      stars.add(star);
    }
  }
  
  void addVote(int vote){
    super.addVote(vote);
    
    Star star = new Star();
      star.pos.x = 300;
      star.pos.y = floor(random(24))*10;
      star.vote=vote;
      
      star.expression = 1.0;
      Ani.to(star,8 ,"expression",0,Ani.LINEAR);
      
      star.speed.x=maxSpeed;
      Ani.to(star.speed,8 ,"x",minSpeed*lerp(random(1),0.8,1.2),Ani.LINEAR);
      
      stars.add(star);
      //if starcount is exceed remove star
      if(stars.size()>maxStars){
        stars.remove(0);
      }
  }
  
  //checks if a vote has been added
  void update(){
    //update positions
    int numberOfStars = stars.size();
     for(int i=0;i<numberOfStars;i++){
       Star star = stars.get(i);
       star.pos.x = (star.pos.x + star.speed.x) % 400.0;
     }
  }
  void draw(){
     hiFacade.beginDraw();
     hiFacade.background(0);
     hiFacade.rectMode(CENTER);
     for(int i=0;i<stars.size();i++){
       Star star = stars.get(i);  
       color voteColor = star.vote>0 ? col0:col1;  
       
       color col = lerpColor(voteColor,#FFFFFF,star.expression);         
       hiFacade.fill(col);
       
       int size = floor(map(star.expression,0,1,11,50));
       
       
       hiFacade.rect(floor(star.pos.x),floor(star.pos.y),size,size);
       
     }
     
     hiFacade.endDraw();
     drawFacade(true);
  } 
}

/*Trails version */
class trailsVisualization extends starFieldVisualization{
  int blurLevel;
  float alphaLevel;
  boolean pixelate;
  float flashLevel;
  color voteColor;
  
  trailsVisualization(String _visualizationName,color _col0,color _col1,int maxParticles,float minSpeed,float maxSpeed, int _blurLevel,float _alphaLevel,boolean _pixelate){
    super(_visualizationName,_col0,_col1,minSpeed,maxSpeed,maxParticles );
    parameters.add(new Parameter("blurLevel",0,10));
    parameters.add(new Parameter("trailLevel",1,10));
    
    blurLevel = _blurLevel;
    alphaLevel = _alphaLevel;
    pixelate = _pixelate;
  }
  
   void setFloatParameter(String parameterName,float parameterValue){
     
    super.setFloatParameter(parameterName,parameterValue);
    
    if(parameterName.equals("blurLevel")){
      blurLevel = round(parameterValue);
    }else if(parameterName.equals("trailLevel")){
      alphaLevel = map(parameterValue,1,10,10,1);
    }
  }
  float getFloatParameter(String parameterName){
     float returnValue = super.getFloatParameter(parameterName);
     if(parameterName.equals("blurLevel")){
       returnValue = round(blurLevel);
     }else if(parameterName.equals("trailLevel")){
       returnValue = map(alphaLevel,1,10,10,1);
     }
     return returnValue;
  };
  
  void setColorParameter(String parameterName,color parameterValue){
    if(parameterName.equals("col0")){
       col0 = parameterValue;
     }else if(parameterName.equals("col1")){
       col1 = parameterValue;
     }
  }
  
  color getColorParameter(String parameterName){
    color parameterValue = super.getColorParameter(parameterName);
    if(parameterName.equals("col0")){
      parameterValue = col0;
    }else if(parameterName.equals("col1")){
      parameterValue = col1;
    }
    return parameterValue;
  }
  
  void initVotes(ArrayList<Integer> votes){
    super.initVotes(votes);
    flashLevel=0;
  }
  void addVote(int vote){
    super.addVote(vote);
    flashLevel=1.0;
    Ani.to(this,1 ,"flashLevel",0,Ani.LINEAR);
    voteColor = vote>0 ? col0:col1; 
  }
  void draw(){
    hiFacade.beginDraw();
    hiFacade.noStroke();
    
    hiFacade.fill(color(0,0,0,alphaLevel));
    hiFacade.rectMode(CENTER);
    hiFacade.rect(200,120,400,240);
    
    for(int i=0;i<stars.size();i++){
      Star star = stars.get(i);  
      color voteColor = star.vote>0 ? col0:col1;  
       
      color col = lerpColor(voteColor,#FFFFFF,star.expression);         
      hiFacade.fill(col);
      int size = floor(map(star.expression,0,1,10,50)); 
      hiFacade.rect(floor(star.pos.x),floor(star.pos.y),size,size);
    }
    
    hiFacade.filter(BLUR,blurLevel);
    hiFacade.endDraw();
    drawFacade(pixelate);
    if(flashLevel>0){
      color flashColor=color(red(voteColor),green(voteColor),blue(voteColor),flashLevel*255);
      fill(flashColor);
      rect(0,0,40,24);
    }
  }
}
/*smooth version*/
class plasmaVisualization extends starFieldVisualization{
  int blurLevel;
  float particleRadius;
  boolean pixelate;
  float flashLevel;
  color voteColor;
  
  plasmaVisualization(String _visualizationName,color _col0,color _col1,int maxParticles,float _minSpeed,float _maxSpeed,float _particleRadius,int _blurLevel,boolean _pixelate){
    super(_visualizationName,_col0,_col1,_minSpeed,_maxSpeed,maxParticles );
    parameters.add(new Parameter("blurLevel",0,10));
    parameters.add(new Parameter("size",0,100));
    blurLevel = _blurLevel;
    particleRadius = _particleRadius;
    pixelate = _pixelate;
  }
  void setFloatParameter(String parameterName,float parameterValue){ 
    super.setFloatParameter(parameterName,parameterValue);
    if(parameterName.equals("blurLevel")){
      blurLevel = round(parameterValue);
    }
    if(parameterName.equals("size")){
       particleRadius = parameterValue;
    }
  }
  float getFloatParameter(String parameterName){
     float returnValue = super.getFloatParameter(parameterName);
     if(parameterName.equals("blurLevel")){
       returnValue = round(blurLevel);
     }else if(parameterName.equals("size")){
       returnValue = particleRadius;
     }
     return returnValue;
  }; 
 
  
  void initVotes(ArrayList<Integer> votes){
    super.initVotes(votes);
    flashLevel=0;
  }
  void addVote(int vote){
    super.addVote(vote);
    voteColor = vote>0 ? col0:col1;  
     flashLevel=1.0;
    Ani.to(this,1 ,"flashLevel",0,Ani.LINEAR);
  }
  
  void update(){
    //update positions
    int numberOfStars = stars.size();
     for(int i=0;i<numberOfStars;i++){
       Star star = stars.get(i);
       float psize = map(star.expression,0,1,particleRadius,particleRadius*1.5);
       star.pos.x = star.pos.x + star.speed.x;
       if(star.pos.x>(400-psize)){
         star.pos.x-=400;
       }
     }
  }
  void draw(){
    hiFacade.beginDraw();
    hiFacade.background(0);
    hiFacade.noStroke();
    for(int i=0;i<stars.size();i++){
       Star star = stars.get(i); 
       color voteColor = star.vote<0 ? col0:col1;  
       hiFacade.fill(voteColor);
       float psize = map(star.expression,0,1,particleRadius,particleRadius*1.5);
       hiFacade.ellipse(star.pos.x,star.pos.y,psize,psize);
       //is a cloud exits from right side we draw it again in the left side 
      if(star.pos.x<psize){
         hiFacade.ellipse(star.pos.x+400,star.pos.y,psize,psize);
       }
    }
    hiFacade.filter(BLUR,blurLevel);
    hiFacade.endDraw();
    drawFacade(pixelate);
    if(flashLevel>0){
      color flashColor=color(red(voteColor),green(voteColor),blue(voteColor),flashLevel*255);
      fill(flashColor);
      rect(0,0,40,24);
    }
  }
}
