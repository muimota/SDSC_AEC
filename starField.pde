
/***
STARFIELD
***/

class starFieldVisualization extends facadeVisualization{
  ArrayList<PVector> stars;
  color[] starColors;
  
  float minSpeed,maxSpeed;
  int  frameNumOfLastVote;
  
  starFieldVisualization(color col0,color col1){
    starColors  =new color[2];
    starColors[0] = col0;
    starColors[1] = col1;
    frameNumOfLastVote=0;
    minSpeed = 0.1;
    maxSpeed = 2.0;
  }
  
  void initVotes(ArrayList<Integer> votes){
    stars = new ArrayList<PVector>();
    for(int i=0;i<votes.size();i++){
      PVector star = new PVector();
      star.x = random(40);
      star.y = random(24);
      if(votes.get(i)<0){
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
      frameNumOfLastVote = frameCount;
      stars.add(star);
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
       fill(starColors[floor(star.z)]);
       //last vote
       if(i==(stars.size()-1) && (frameCount-frameNumOfLastVote)<=25){
         color col = lerpColor(#FFFFFF,starColors[floor(star.z)],(frameCount-frameNumOfLastVote)/25.0);
         fill(col);
       }
       if(star.x<10){
         rect(floor(star.x)-floor(star.x)%2,floor(star.y),2,1);
       }else{
         rect(floor(star.x),floor(star.y),1,1);
       }
     }
  } 
}

