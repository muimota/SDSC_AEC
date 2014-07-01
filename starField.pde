
/***
STARFIELD
***/

class starFieldVisualization extends facadeVisualization{
  ArrayList<PVector> stars;
  ArrayList<PVector> votingStars;
  ArrayList<Integer> votingFrames;
  //nomber of frames that a new vote glitters
  int glitterFrames  = 200;
  int maxStars;
  
  color[] starColors;
  
  float minSpeed,maxSpeed;
  
 
  starFieldVisualization(color col0,color col1,float _minSpeed,float _maxSpeed, int _maxStars ){
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
    stars = new ArrayList<PVector>();
    votingStars  = new ArrayList<PVector>();
    votingFrames = new ArrayList<Integer>();
    int starsCount = min(votes.size(),maxStars);
    
    for(int i=0;i<starsCount;i++){
      PVector star = new PVector();
      star.x = random(40);
      star.y = random(24);
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
         float glitter = (frameCount-votingFrames.get(votingStarIndex))/float(glitterFrames);
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

