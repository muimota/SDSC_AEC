
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
  ArrayList<Star> stars;
  int maxStars;
  color starColors[];
  float minSpeed,maxSpeed;
  
 
  starFieldVisualization(color col0,color col1,float _minSpeed,float _maxSpeed, int _maxStars){
    super();
    visualizationName = "starsVisualization";
    
    starColors  =new color[2];
    starColors[0] = col0;
    starColors[1] = col1;
    minSpeed = _minSpeed;
    maxSpeed = _maxSpeed;
    maxStars = _maxStars;
  }
  starFieldVisualization(color col0,color col1,float minSpeed,float maxSpeed ){
    this(col0,col1,minSpeed,maxSpeed,10000);
  }
  
  starFieldVisualization(color col0,color col1,int maxStars){
    this(col0,col1,1,5,maxStars );
  }
  starFieldVisualization(color col0,color col1){
    this(col0,col1,0.1,0.5 );
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
       color voteColor = star.vote<0 ? starColors[0]:starColors[1];  
       
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
  trailsVisualization(color col0,color col1,int maxParticles,float minSpeed,float maxSpeed, int _blurLevel,float _alphaLevel,boolean _pixelate){
    super(col0,col1,minSpeed,maxSpeed,maxParticles );
    blurLevel = _blurLevel;
    alphaLevel = _alphaLevel;
    pixelate = _pixelate;
    visualizationName = "trailsVisualization";
  }
  void initVotes(ArrayList<Integer> votes){
    super.initVotes(votes);
    flashLevel=0;
  }
  void addVote(int vote){
    super.addVote(vote);
    flashLevel=1.0;
    Ani.to(this,1 ,"flashLevel",0,Ani.LINEAR);
    voteColor = vote<0 ? starColors[0]:starColors[1]; 
  }
  void draw(){
    hiFacade.beginDraw();
    hiFacade.noStroke();
    
    hiFacade.fill(color(0,0,0,alphaLevel));
    hiFacade.rectMode(CENTER);
    hiFacade.rect(200,120,400,240);
    
    for(int i=0;i<stars.size();i++){
      Star star = stars.get(i);  
      color voteColor = star.vote<0 ? starColors[0]:starColors[1];  
       
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
  
  plasmaVisualization(color col0,color col1,int maxParticles,float minSpeed,float maxSpeed,float _particleRadius,int _blurLevel,boolean _pixelate){
    super(col0,col1,minSpeed,maxSpeed,maxParticles );
    blurLevel = _blurLevel;
    particleRadius = _particleRadius;
    pixelate = _pixelate;
    visualizationName = "plasmaVisualization";
  }
  void initVotes(ArrayList<Integer> votes){
    super.initVotes(votes);
    flashLevel=0;
  }
  void addVote(int vote){
    super.addVote(vote);
    voteColor = vote<0 ? starColors[0]:starColors[1];  
     flashLevel=1.0;
    Ani.to(this,1 ,"flashLevel",0,Ani.LINEAR);
  }
  void draw(){
    hiFacade.beginDraw();
    hiFacade.background(0);
    hiFacade.noStroke();
    for(int i=0;i<stars.size();i++){
       Star star = stars.get(i); 
       color voteColor = star.vote<0 ? starColors[0]:starColors[1];  
       hiFacade.fill(voteColor);
       float psize = map(star.expression,0,1,particleRadius,particleRadius*1.5);
       hiFacade.ellipse(floor(star.pos.x),floor(star.pos.y),psize,psize);
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
