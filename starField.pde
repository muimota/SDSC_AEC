
/***
STARFIELD
***/
class Star{
  PVector pos;
  PVector speed;
  float   expression;
  int     vote;
  boolean stacked;
  Star(){
    pos=new PVector();
    speed =new PVector();
    stacked = false;
  }
}


class starFieldVisualization extends facadeVisualization{
  ArrayList<Star> stars = new ArrayList<Star>();
  int maxStars;
  color col0,col1;
  float minSpeed,maxSpeed;
 
  starFieldVisualization(String _visualizationName,color _col0,color _col1,float _minSpeed,float _maxSpeed, int _maxStars){
    super();
    parameters.add(new Parameter("maxStars",1,200));
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
   
    float prevMinSpeed = this.minSpeed;
    float prevMaxSpeed = this.maxSpeed;
    
    if(parameterName.equals("minSpeed")){
      minSpeed = parameterValue;
    }else if(parameterName.equals("maxSpeed")){
      maxSpeed = parameterValue;
    }else if(parameterName.equals("maxStars")){
      
      maxStars = floor(parameterValue);
      //reduce the number of stars
      if(maxStars<stars.size()){
        int removeCount = stars.size()-maxStars;
        for(int i=0;i<removeCount;i++){
          stars.remove(0); 
        }
      }else if(maxStars<totalVotes){
        initVotes(yesVotes,noVotes);
      }
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
     }else if(parameterName.equals("maxStars")){
       returnValue = maxStars;
   
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
  
  void initVotes(int _yesVotes,int _noVotes){
    super.initVotes(_yesVotes,_noVotes);
    stars = new ArrayList<Star>();
    int starsCount = min(totalVotes,maxStars);
    int yesStars;
    
    if(starsCount>totalVotes){
      yesStars = yesVotes;
    }else{
      yesStars = round((yesVotes/(float)totalVotes)*maxStars);
    }
    
    for(int i=0;i<starsCount;i++){
      Star star = new Star();
      //position
      star.pos.x = random(400);
      //we round it so in vertizally is always alligned to the facade
      star.pos.y = floor(random(24))*10;
      //speed
      star.speed.x=minSpeed*lerp(random(1),0.8,1.2);
      
      
      if(i<yesStars){
        star.vote = 1;
      }else{
        star.vote = -1;
      } 
      star.expression = 0;
      stars.add(star);
    }
  }
  void initVotes(ArrayList<Integer> votes){
    super.initVotes(votes);
    initVotes(yesVotes,noVotes);
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
  int stack;
  boolean heartSeq=false;
  int stacks[];
  int yesRow;
  
  //heart parameters
  float accelerationTime= 1.0;
  float speedFactor     = 1.0;
  float speedUpTime     = 1.0;
  float distributeTime  = 1.0;
  float stackingTime    = 1.0;
  float organizeTime    = 1.0;
  float speedDownTime   = 1.0;
  
  trailsVisualization(String _visualizationName,color _col0,color _col1,int maxParticles,float minSpeed,float maxSpeed, int _blurLevel,float _alphaLevel,boolean _pixelate){
    super(_visualizationName,_col0,_col1,minSpeed,maxSpeed,maxParticles );
    parameters.add(new Parameter("blurLevel",0,10));
    parameters.add(new Parameter("trailLevel",0,10));
    parameters.add(new Parameter("accelerationTime",0,10));
    parameters.add(new Parameter("speedFactor",1,10));  
    parameters.add(new Parameter("speedUpTime",0,10));
    parameters.add(new Parameter("distributeTime",0,10));
    parameters.add(new Parameter("stackingTime",0,10));
    parameters.add(new Parameter("organizeTime",0,10));
    parameters.add(new Parameter("speedDownTime",0,10));
    
    blurLevel = _blurLevel;
    alphaLevel = _alphaLevel;
    pixelate = _pixelate;
    
    stack = 0;
    stacks = new int[24];
    stackReset();
  }
  
  void setFloatParameter(String parameterName,float parameterValue){
     
    super.setFloatParameter(parameterName,parameterValue);
    
    if(parameterName.equals("blurLevel")){
      blurLevel = round(parameterValue);
    }else if(parameterName.equals("trailLevel")){
      alphaLevel = (parameterValue==0)?0:map(parameterValue,1,10,10,1);
    }else if(parameterName.equals("accelerationTime")){
      accelerationTime = parameterValue;
    }else if(parameterName.equals("speedFactor")){
      speedFactor = parameterValue;
    }else if(parameterName.equals("speedUpTime")){
      speedUpTime = parameterValue;
    }else if(parameterName.equals("distributeTime")){
      distributeTime = parameterValue;
    }else if(parameterName.equals("stackingTime")){
      stackingTime = parameterValue;
    }else if(parameterName.equals("organizeTime")){
      organizeTime = parameterValue;
    }else if(parameterName.equals("speedDownTime")){
      speedDownTime = parameterValue;
    }
  }
  float getFloatParameter(String parameterName){
     float returnValue = super.getFloatParameter(parameterName);
     if(parameterName.equals("blurLevel")){
       returnValue = round(blurLevel);
     }else if(parameterName.equals("trailLevel")){
       returnValue =  (alphaLevel==0)?0:map(alphaLevel,1,10,10,1);
     }else if(parameterName.equals("accelerationTime")){
       returnValue =accelerationTime;
     }else if(parameterName.equals("speedFactor")){
       returnValue =speedFactor;
     }else if(parameterName.equals("speedUpTime")){
       returnValue = speedUpTime;
     }else if(parameterName.equals("distributeTime")){
       returnValue = distributeTime;
     }else if(parameterName.equals("stackingTime")){
       returnValue = stackingTime;
     }else if(parameterName.equals("organizeTime")){
       returnValue = organizeTime;
     }else if(parameterName.equals("speedDownTime")){
       returnValue = speedDownTime;
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
  
  void heart(){
    if(heartSeq){
      return;
    }
    
    heartSeq  =true;
    
    int numberOfStars = stars.size();
    float yesRatio = yesVotes/float(totalVotes);
    //kill all previus animation
    Ani.killAll();
    //set all stars speed to normal 
    flashLevel=0;
    for(Star star:stars){
       if(star.expression>0){
         star.expression=0;
         star.speed.x=minSpeed*lerp(random(1),0.8,1.2);
       }
    }
    yesRow=floor(yesRatio*22)*10;    
    println(yesRow);
    for(int i=0;i<numberOfStars;i++){
      Star star = stars.get(i);
      AniSequence seq = new AniSequence(Ani.papplet());
      seq.beginSequence();
     
      int starY;
      if(star.vote>0){
        //starY=round(random(0,yesRatio*230));   
        starY=yesRow;
      }else{
        //starY=round(random(yesRatio*230,230));
        starY=yesRow+10;
      }
       //we have to make copies of variables for Ani return to original values
      float posy = star.pos.y;
      float speedx = star.speed.x;
      //acceleration time to 
      seq.add(Ani.to(star.speed,accelerationTime ,"x",star.speed.x*speedFactor,Ani.LINEAR));
      //move up or down depending in the vote
      seq.add(Ani.to(star.pos  ,distributeTime,speedUpTime ,"y",starY,Ani.LINEAR));
      //stack
      seq.add(Ani.to(this  ,0.001 ,"stack",1,Ani.LINEAR));
      //stop stacking after stackingTime
      seq.add(Ani.to(this  ,0.001 ,stackingTime ,"stack",0,Ani.LINEAR,"onEnd:stackReset"));
      //back to it's original (vertical) position
      seq.add(Ani.to(star.pos  ,organizeTime ,"y",posy,Ani.LINEAR));
      //back to it's original speed
      seq.add(Ani.to(star.speed,speedDownTime ,"x",speedx,Ani.LINEAR));
      
      seq.endSequence();
      seq.start();    
    } 
    
  }
  //reset stack values
  void stackReset(){
    for(int i=0;i<stacks.length;i++){
      stacks[i]=0;
    }
    
    for(int i=0;stars!=null && i<stars.size();i++){
      Star star = stars.get(i);
      star.stacked=false;
    }
    heartSeq = false;
  }
  void update(){
    //update positions
    int numberOfStars = stars.size();
     for(int i=0;i<numberOfStars;i++){
       Star star = stars.get(i);
       //if no stacking
       if(stack==0){
         star.pos.x = (star.pos.x + star.speed.x) % 400.0;
       }else{
         int row = round(star.pos.y/10);
         if(star.pos.x<390-stacks[row]){
            star.pos.x = (star.pos.x + star.speed.x) % 400.0; 
         }else if(!star.stacked){
            stacks[row]+=10;
            star.stacked=true;
         }
       }
     }
  }
    
  void initVotes(ArrayList<Integer> votes){
    super.initVotes(votes);
    flashLevel=0;
  }
  void addVote(int vote){
    //add Vote only if a heart animation is not running
    if(stack==0){
      super.addVote(vote);
      flashLevel=1.0;
      Ani.to(this,1 ,"flashLevel",0,Ani.LINEAR);
      voteColor = vote>0 ? col0:col1;
    } 
  }
  void draw(){
    hiFacade.beginDraw();
    hiFacade.noStroke();
    
    hiFacade.fill(color(0,0,0,alphaLevel));
    hiFacade.rectMode(CENTER);
    hiFacade.rect(200,120,400,240);
    
    for(int i=0;i<stars.size();i++){
      Star star = stars.get(i);  
      if(star.stacked){
        continue;
      }
      color voteColor = star.vote>0 ? col0:col1;  
       
      color col = lerpColor(voteColor,#FFFFFF,star.expression);         
      hiFacade.fill(col);
      int size = floor(map(star.expression,0,1,10,50)); 
      hiFacade.rect(floor(star.pos.x),floor(star.pos.y),size,size);
    }
    //stacks
    if(stack==1){
      hiFacade.rectMode(CORNER);
      for(int i=0;i<24;i++){
        if(i<=yesRow/10){ 
          hiFacade.fill(col0);
        }else{
          hiFacade.fill(col1);
        }
        hiFacade.rect(400-stacks[i],i*10,stacks[i],10);
      }
    }
    hiFacade.rectMode(CENTER);
    hiFacade.filter(BLUR,blurLevel);
    hiFacade.endDraw();
    drawFacade(pixelate);
    
    //flash in votes
    if(flashLevel>0){
      color flashColor=color(red(voteColor),green(voteColor),blue(voteColor),flashLevel*255);
      fill(flashColor);
      rect(0,0,73,28);
    }
  }
}

