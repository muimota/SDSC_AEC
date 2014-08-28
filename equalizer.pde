import java.util.Iterator;
import de.looksgood.ani.*;

import controlP5.*;

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

Boolean autorun = false;

ControlP5 cp5;

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
  voteSets.add(generateVotes(.2,50));
  voteSets.add(generateVotes(.0,0));
  
  voteSetsIterator = voteSets.iterator();
  votes = new  ArrayList<Integer>(voteSetsIterator.next());
  
  //Init Visualizations
  //starFields positive color, negative color , number of stars
  //animations.add(new starFieldVisualization(#FF0000,#999999,20)); 
  //trails  color0, color 1 , particles, min speed, max speed, blurlevel,alphaLevel(length of the trail) pixelate
  
  animations.add(new trailsVisualization("Category1",#004DFF,#999999,50,0.5,10,0,10,true)); 
  animations.add(new trailsVisualization("Category2",#00DD63,#999999,50,0.5,10,0,10,true));
  animations.add(new trailsVisualization("Category3",#E400E3,#999999,50,0.5,10,0,10,true));

  for(facadeVisualization vis:animations){
    vis.initVotes(votes); 
    loadVisualization(vis);
  }

  animationIterator = animations.iterator();   
  anim = animationIterator.next();
  anim.initVotes(votes); 
  //GUI
  cp5 = new ControlP5(this);
  cp5.addButton("SAVE CONFIG", 0, 10, 360, 58, 30);
  createAnimationGUI();
  
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
   
   if(key == 'h'){
     anim.heart();
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
     votes.add(vote);
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
  
  clearAnimationGUI();
 
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
    createAnimationGUI();   
   }
void clearAnimationGUI(){
  //remove controller from the previus animation
  for(Parameter p:anim.parameters){
    cp5.remove(p.name);
  }
}

void createAnimationGUI(){
  PVector sliderCol = new PVector(750,0);
   PVector colorCol  = new PVector(sliderCol.x+155,sliderCol.y);

   for(Parameter p:anim.parameters){
     if(p.type==Parameter.COLOR){
       cp5.addColorPicker(p.name)
       .setColorValue(anim.getColorParameter(p.name))
       .setPosition(colorCol.x,colorCol.y);
       colorCol.y+=65;
     }else if(p.type==Parameter.NUMBER){
       cp5.addSlider(p.name).setValue(anim.getFloatParameter(p.name))
         .setPosition(sliderCol.x,sliderCol.y)
         .setRange(p.minValue,p.maxValue);
         sliderCol.y+=15;
     }
   }
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

void loadVisualization(facadeVisualization vis){
  String filePath = dataPath("visualizations/"+vis.visualizationName+".cfg");
  File file = new File(filePath);
  if(!file.exists()){
    println("no config file for:"+vis.visualizationName);
    return;
  }
  String[] params = loadStrings(filePath);
  
  for(String param:params){
    String chunks[] = param.split(":");
    vis.setColorParameter(chunks[0],parseInt(chunks[1]));
    vis.setFloatParameter(chunks[0],parseFloat(chunks[1]));
  }
}

void saveVisualization(facadeVisualization vis){
  String[] params = new String[vis.parameters.size()];
  for(int i=0;i<vis.parameters.size();i++){
    Parameter param = vis.parameters.get(i);
    String name = param.name;
    String value;
    if(param.type==Parameter.COLOR){
      value = Integer.toString(vis.getColorParameter(param.name));
    }else{
      value = Float.toString(vis.getFloatParameter(param.name));
    }
    params[i] = name+":"+value;
  } 
  saveStrings("data/visualizations/"+vis.visualizationName+".cfg",params);
}

void controlEvent(ControlEvent theEvent) {
  String parameterName = theEvent.getName();
  
  if(parameterName.equals("SAVE CONFIG")){
    saveVisualization(anim);
    return;
  } 
 
  Parameter parameter = null;
  //find parameter in animation parameters
  for(Parameter p:anim.parameters){
    if(parameterName.equals(p.name)){
      parameter  = p;
      break;
    }
  }
  if(parameter.type==Parameter.NUMBER){
    anim.setFloatParameter(parameterName,cp5.get(parameterName).getValue());
  }else if(parameter.type==Parameter.COLOR){
    color col = ((ColorPicker)cp5.get(parameterName)).getColorValue();
    anim.setColorParameter(parameterName,col);
  }
  
}
