import controlP5.*;
import java.util.Iterator;


AEC aec;

ArrayList<Integer> votes; //-2 NO,-1 RNO,1 RYES,2 YES
ArrayList<facadeVisualization> animations;
Iterator<facadeVisualization> animationIterator;
facadeVisualization anim;

void setup() {
  frameRate(25);
  size(1200, 400);
  aec = new AEC();
  aec.init();
  animations = new ArrayList<facadeVisualization>();
  
  votes = generateVotes(.2,1000); 
  animations.add(new starFieldVisualization(#FF0000,#0000FF)); 
  
  animationIterator = animations.iterator();   
  anim = animationIterator.next();
  anim.initVotes(votes);
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

ArrayList<Integer> generateVotes(float yesProb,int numOfvotes){
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

void keyPressed() {
   //aec.keyPressed(key);
   if(key == ' '){
     if(animationIterator.hasNext()==false){
       animationIterator = animations.iterator();   
     }
     anim = animationIterator.next();
     anim.initVotes(votes);
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
     votes.add(vote);
     anim.addVote(vote);
     
     int positiveVotes = 0; 
     for(int i=0;i<votes.size();i++){
        if(votes.get(i)<0){
          positiveVotes++;
        } 
     }
     int percentageOfPositiveVotes  = round(positiveVotes/float(votes.size())*100);
     println(votes.size() +" "+ positiveVotes +"  - "+percentageOfPositiveVotes+"% "+(100-percentageOfPositiveVotes)+"%");
   }
}
void mousePressed(){
  println("x:"+mouseX/aec.getScaleX()+" y:"+mouseY/aec.getScaleY());
}
