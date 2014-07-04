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
int sequenceTime  = 6000;
int actionIndex   = 0;

Boolean autorun = false;

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
  voteSets.add(generateVotes(.5,400));
  voteSets.add(generateVotes(.8,100));
  
  voteSetsIterator = voteSets.iterator();
  votes = new  ArrayList<Integer>(voteSetsIterator.next());
  
  //Init Visualizations
  //starFields positive color, negative color , number of stars
  animations.add(new starFieldVisualization(#0C64E8,#0DFFCD,10)); 
  animations.add(new starFieldVisualization(#FF0887,#FF7308,50)); 
  animations.add(new starFieldVisualization(#FF0887,#FF7308,100)); 

  //stripe, color of line , line Width
  animations.add(new stripeVisualization(#FF0000,3));
  
  //stack colorpositive , color negative , color of the line
  animations.add(new stackVisualization(#00B275,#FF7452,#FFFFFF));
  animations.add(new stackVisualization(#9958C4,#FFCD40,#FFFFFF));
  animations.add(new stackVisualization(#FF0000,#0000FF,#FF00FF));
 
   //barVisualization colorpositive , color negative , color of the line, line width
  animations.add(new barVisualization(#9958C4,#FFCD40,#FFFFFF,3));
  //physicsVisualization colorpositive , color negative , color of the line, line width
  animations.add(new physicsVisualization(#00B275,#FF7452,#FFFFFF,3));
 //waveVisualization colorpositive , color negative , color of the line, line width
  animations.add(new waveVisualization(#00B275,#FF7452,#FFFFFF,3));
  
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
  
  if(autorun){
    updateSequence();
  }
  
  pushStyle();
  stroke(255);
  fill(255);
  text(anim.toString(),0,300);
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
