import java.util.Iterator;
import de.looksgood.ani.*;


AEC aec;

ArrayList<Integer> votes; //-2 NO,-1 RNO,1 RYES,2 YES

ArrayList<facadeVisualization> animations;
Iterator<facadeVisualization> animationIterator;

ArrayList<ArrayList<Integer>>  voteSets;
Iterator<ArrayList<Integer>>   voteSetsIterator;

facadeVisualization anim;

int sequenceIndex = 0;
int sequenceTime  = 15000;
int actionIndex   = 0;

Boolean autorun = true;

//martin 23/05/2014
//yes 2 , rather yer 1 , rather no -1 , no -2




void setup() {
  frameRate(25);
  size(1200, 400);
  
  //init AEC facade library
  aec = new AEC();
  aec.init();
  animations = new ArrayList<facadeVisualization>();
  
  //Init Ani library
  Ani.init(this);
  Ani.overwrite();
  
  //Init Votes

  voteSets = new ArrayList<ArrayList<Integer>>();
  //test 20% 50% 80% 100 votes

  
  //test 20% 50% 80% 1000 votes 
  voteSets.add(generateVotes(.2,1000));
  /*voteSets.add(generateVotes(.5,400));
  voteSets.add(generateVotes(.8,100));
  */
  voteSetsIterator = voteSets.iterator();
  votes = new  ArrayList<Integer>(voteSetsIterator.next());
  
  //Init Visualizations
  //starFields positive color, negative color , number of stars
  //animations.add(new starFieldVisualization(#FF0000,#999999,20)); 
  //trails  color0, color 1 , particles, min speed, max speed, blurlevel,alphaLevel pixelate
  animations.add(new trailsVisualization(color(255,0,0,255),color(255,255,255,255),50,0.05,0.02,0,4,true)); 
  animations.add(new trailsVisualization(color(255,0,0,255),color(255,255,255,255),50,0.05,0.02,0,4,false)); 
  animations.add(new trailsVisualization(color(255,0,0,255),color(255,255,255,255),50,0.1,0.2,0,0,false)); 
  //plasma
  //plasma  color0, color 1 , particles, radius, blurlevel, pixelate
  animations.add(new plasmaVisualization(color(255,0,0,126),color(255,255,255,126),50,50,10,false)); 
  
  
  animationIterator = animations.iterator();   
  anim = animationIterator.next();
  anim.initVotes(votes);
  
  
}

void draw() {
  
  background(0);
  anim.update();
  aec.beginDraw();
    noStroke();
    noSmooth();
    anim.draw();
  aec.endDraw(); 
  aec.drawSides();
  if(autorun){
    updateSequence();
  }
  
  pushStyle();
  stroke(255);
  fill(255);
  text(anim.toString(),0,300);
  if(autorun){
    text("autorun:ON",0,330);
  }else{
    text("autorun:OFF",0,330);
  }
  popStyle();
}

ArrayList<Integer> generateVotes(float yesProb,int numOfvotes){
  ArrayList<Integer> votes = new ArrayList<Integer>();
  for(int i=0;i<numOfvotes;i++){
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
     nextScene();
   }
   //save screenshot
   if(key == 's'){
      String filename = String.valueOf(year())+String.valueOf(month())+String.valueOf(day())+String.valueOf(hour())+String.valueOf(minute())+String.valueOf(second())+".png";
      save(filename);
   }
   if(key == 'a'){
      autorun = !autorun;
      if(autorun){
        println("autorun:ON");
      }else{
        println("autorun:OFF");
      }        
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
     addVote(vote);
   }
}

void addVote(int vote){
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

void nextScene(){
  
  if(voteSetsIterator.hasNext() == false){
     voteSetsIterator = voteSets.iterator();
     if(animationIterator.hasNext()==false){
       animationIterator = animations.iterator();   
     }
     anim = animationIterator.next();
   }
   votes = new ArrayList<Integer>(voteSetsIterator.next());
   Ani.killAll();
   anim.initVotes(votes);
   
}

void updateSequence(){
  int auxIndex = millis()/sequenceTime;
  if(auxIndex!=sequenceIndex){
    sequenceIndex = auxIndex;
    actionIndex = (actionIndex+1)%3;
    switch(actionIndex){
      case 0:
        addVote( 2);
        break;
      case 1:
        addVote(-2);
        break;
      case 2:
        nextScene();
        break;
    }
  }
}
void mousePressed(){
  println("x:"+mouseX/aec.getScaleX()+" y:"+mouseY/aec.getScaleY());
}
