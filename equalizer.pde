import controlP5.*;
import java.util.Iterator;


AEC aec;

ArrayList<Integer> Votes; //-2 NO,-1 RNO,1 RYES,2 YES
ArrayList<facadeAnimation> animations;
Iterator<facadeAnimation> animationIterator;
facadeAnimation anim;

void setup() {
  frameRate(25);
  size(1200, 400);
  aec = new AEC();
  aec.init();
  animations = new ArrayList<facadeAnimation>();
  
  Votes = generateVotes(.2,1000); 
  animations.add(new starFieldVisualization(#FF0000,#0000FF)); 
  
  animationIterator = animations.iterator();   
  anim = animationIterator.next();
  startAnimation(anim);
}

void draw() {
  anim.update();
  aec.beginDraw();
    background(0,0,0);
    noStroke();
    anim.draw();
  aec.endDraw(); 
  aec.drawSides();
}

ArrayList<Integer> generateVotes(float yesProb,int numOfVotes){
  ArrayList<Integer> votes = new ArrayList<Integer>();
  for(int i=0;i<1000;i++){
    float v = random(1);
    int vote ;
    if(v<yesProb){
      if(v<yesProb/2.0){
        vote=-2;
      }else{
        vote=-1;
      }
    }else{
      if(v>1-(1-yesProb)/2.0){
        vote=1;
      }else{
        vote=2;
      }
    }
    votes.add(vote);
  }
  return votes;
}
void startAnimation(facadeAnimation fa){
  fa.init();
  if (anim instanceof VotesVisualization) {
      VotesVisualization vv = (VotesVisualization)anim;
      vv.updateVotes(Votes);
   }
}

void keyPressed() {
   //aec.keyPressed(key);
   if(key == ' '){
     if(animationIterator.hasNext()==false){
       animationIterator = animations.iterator();   
     }
     anim = animationIterator.next();
     startAnimation(anim);
     
   }
   //save screenshot
   if(key == 's'){
      String filename = String.valueOf(year())+String.valueOf(month())+String.valueOf(day())+String.valueOf(hour())+String.valueOf(minute())+String.valueOf(second())+".png";
      save(filename);
   }
   //voting keys{
     int vote=0;
     boolean hasVoted=true;
   switch(key){
     case 'q':
       vote=-2;
       break;
     case 'w':
       vote=-1;
       break;
     case 'e':
       vote=1;
       break;
     case 'r':
       vote=1;
       break;
     default:
       hasVoted=false;
   } 
   if(hasVoted){
     Votes.add(vote);
     if (anim instanceof VotesVisualization) {
        VotesVisualization vv = (VotesVisualization)anim;
        vv.addVote(vote);
     }
     int positiveVotes = 0; 
     for(int i=0;i<Votes.size();i++){
        if(Votes.get(i)<0){
          positiveVotes++;
        } 
     }
     int percentageOfPositiveVotes  = round(positiveVotes/float(Votes.size())*100);
     println(Votes.size() +" "+ positiveVotes +"  - "+percentageOfPositiveVotes+"% "+(100-percentageOfPositiveVotes)+"%");
   }
}
void mousePressed(){
  println("x:"+mouseX/aec.getScaleX()+" y:"+mouseY/aec.getScaleY());
}
