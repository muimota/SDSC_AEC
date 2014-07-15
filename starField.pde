
/***
STARFIELD
***/

class starFieldVisualization extends facadeVisualization{
  ArrayList<PVector> stars;
  //stars highlighted because are recent votes
  ArrayList<PVector> votingStars;
  //framenum when the vote was produced, is related with the star 
  ArrayList<Integer> votingFrames;
  //nomber of frames that a new vote glitters
  int glitterFrames  = 200;
  int maxStars;
  
  color[] starColors;
  
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
    this(col0,col1,0.1,0.5,maxStars );
  }
  starFieldVisualization(color col0,color col1){
    this(col0,col1,0.1,0.5 );
  }
  
  void initVotes(ArrayList<Integer> votes){
    super.initVotes(votes);
    stars = new ArrayList<PVector>();
    votingStars  = new ArrayList<PVector>();
    votingFrames = new ArrayList<Integer>();
    int starsCount = min(votes.size(),maxStars);
    
    for(int i=0;i<starsCount;i++){
      PVector star = new PVector();
      star.x = random(40);
      star.y = round(random(24));
      int voteIndex;
      if(starsCount>votes.size()){
        voteIndex = i;
      }else{
        voteIndex = int(random(votes.size()));
      }
      if(votes.get(voteIndex)<0){
        star.z=0;
      }else{
        star.z=1;
      }
      stars.add(star);
    }
  }
  
  void addVote(int vote){
    super.addVote(vote);
    
    PVector star = new PVector();
      star.x = 30;
      star.y = round(random(24));
      if(vote<0){
        star.z=0;
      }else{
        star.z=1;
      }
      votingStars.add(star);
      votingFrames.add(frameCount);
      stars.add(star);
      if(stars.size()>maxStars){
        stars.remove(0);
      }
  }
  
  //checks if a vote has been added
  void update(){
    //update positions
    int numberOfStars = stars.size();
     for(int i=0;i<numberOfStars;i++){
       PVector star = stars.get(i);
       float speed = map(i,-1,numberOfStars-1,minSpeed,maxSpeed);
       star.x = (star.x + speed) % 40.0;
     }
  }
  void draw(){
     
     for(int i=0;i<stars.size();i++){
       PVector star = stars.get(i);
      
       //last vote
       int votingStarIndex = votingStars.indexOf(star);
       if(votingStarIndex!=-1){
         
         float glitter = norm(frameCount-votingFrames.get(votingStarIndex),0,glitterFrames);
         if(glitter>1){
           votingStars.remove(votingStarIndex);
           votingFrames.remove(votingStarIndex);
           println(votingStars.size());
         }
        
         color col = lerpColor(#FFFFFF,starColors[floor(star.z)],glitter);
         fill(col);
       }else{
          fill(starColors[floor(star.z)]);
       }
       if(star.x<10){
         rect(floor(star.x)-floor(star.x)%2,floor(star.y),2,1);
       }else{
         rect(floor(star.x),floor(star.y),1,1);
       }
     }
  } 
}

/*Trails version*/
class trailsVisualization extends starFieldVisualization{
  int blurLevel;
  float alphaLevel;
  boolean pixelate;
  trailsVisualization(color col0,color col1,int maxParticles,float minSpeed,float maxSpeed, int _blurLevel,float _alphaLevel,boolean _pixelate){
    super(col0,col1,minSpeed,maxSpeed,maxParticles );
    blurLevel = _blurLevel;
    alphaLevel = _alphaLevel;
    pixelate = _pixelate;
    visualizationName = "trailsVisualization";
  }
  void draw(){
    hiFacade.beginDraw();
    hiFacade.noStroke();
    hiFacade.fill(color(0,0,0,alphaLevel));
    hiFacade.rect(0,0,400,240);
    for(int i=0;i<stars.size();i++){
       PVector star = stars.get(i).get(); //use a copy of the star
       
      star.x*=10;
      star.y*=10;
       //last vote
       int votingStarIndex = votingStars.indexOf(star);
       if(votingStarIndex!=-1){
         
         float glitter = norm(frameCount-votingFrames.get(votingStarIndex),0,glitterFrames);
         if(glitter>1){
           votingStars.remove(votingStarIndex);
           votingFrames.remove(votingStarIndex);
         }
        
         color col = lerpColor(#FFFFFF,starColors[floor(star.z)],glitter);
         hiFacade.fill(col);
       }else{
         hiFacade.fill(starColors[floor(star.z)]);
       }
       if(star.x<10){
         hiFacade.rect(floor(star.x)-floor(star.x)%2,floor(star.y),10,15);
       }else{
         hiFacade.rect(floor(star.x),floor(star.y),10,10);
       }
      
    }
    hiFacade.filter(BLUR,blurLevel);
    hiFacade.endDraw();
    drawFacade(pixelate);
  }
  
}
/*smooth version*/
class plasmaVisualization extends starFieldVisualization{
  int blurLevel;
  float particleRadius;
  boolean pixelate;
  plasmaVisualization(color col0,color col1,int maxParticles,float minSpeed,float maxSpeed,float _particleRadius,int _blurLevel,boolean _pixelate){
    super(col0,col1,minSpeed,maxSpeed,maxParticles );
    blurLevel = _blurLevel;
    particleRadius = _particleRadius;
    pixelate = _pixelate;
    visualizationName = "plasmaVisualization";
  }
  void draw(){
    hiFacade.beginDraw();
    hiFacade.background(0);
    hiFacade.noStroke();
    for(int i=0;i<stars.size();i++){
       PVector star = stars.get(i).get(); //use a copy of the star
       
      star.x*=10;
      star.y*=10;
       //last vote
       int votingStarIndex = votingStars.indexOf(star);
       if(votingStarIndex!=-1){
         
         float glitter = norm(frameCount-votingFrames.get(votingStarIndex),0,glitterFrames);
         if(glitter>1){
           votingStars.remove(votingStarIndex);
           votingFrames.remove(votingStarIndex);
         }
        
         color col = lerpColor(#FFFFFF,starColors[floor(star.z)],glitter);
         hiFacade.fill(col);
       }else{
         hiFacade.fill(starColors[floor(star.z)]);
       }
       if(star.x<10){
         hiFacade.ellipse(floor(star.x)-floor(star.x)%2,floor(star.y),particleRadius,particleRadius);
       }else{
         hiFacade.ellipse(floor(star.x),floor(star.y),particleRadius,particleRadius);
       }
      
    }
    hiFacade.filter(BLUR,blurLevel);
    hiFacade.endDraw();
    drawFacade(pixelate);
  }
}
