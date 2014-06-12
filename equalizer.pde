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
  Votes = new ArrayList<Integer>();
 
  
  animations.add(new starFieldVisualization(#FF0000,#0000FF,Votes)); 
  animations.add(new starFieldAnimation(#FF0000,#0000FF,20));
  animations.add(new starFieldAnimation(#FF0000,#0000FF,50));
  animations.add(new starFieldAnimation(#FF0000,#0000FF,100));
  animations.add(new starFieldAnimation(#FF0000,#0000FF,150));
  animations.add(new starFieldAnimation(#FF0000,#0000FF,200));  

  animations.add(new equalizerSideAnimation(#D070FF,#7066E8,#66E8E0,#76FFA3));
 
  color colseq[] = {#7066E8,#7DBDFF,#66E8E0,#76FFA3,#66E8E0,#7DBDFF,#7066E8};
  animations.add(new equalizerHorizontalAnimation(colseq));
  animations.add(new equalizerGradientAnimation(#5ED3FF,#FFEC64));
  animations.add(new equalizerGradientAnimation(#D742FF,#3C85FF));
  animations.add(new equalizerVerticalAnimation());
  animations.add(new equalizerSymetricHorizontalGradientAnimation(#62CC7E,#1C993C,#BDFF94,#9062CC));
  animations.add(new equalizerSymetricHorizontalGradientAnimation(#FFD661,#FF8561,#FF8561,#BB62FF));
  animations.add(new growingLine(#BB62FF));
  animations.add(new growingLine(#FF8561));
/*  animations.add(new starFieldAnimation(#FFFFFF,#999999,#555555,20));
  animations.add(new starFieldAnimation(#FF6045,#FF9D52,#FFC445,20));
  animations.add(new starFieldAnimation(#E84F47,#E847CB,#E04EFF,20));
  */
  
  animationIterator = animations.iterator();   
  anim = animationIterator.next();
  anim.init();
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

void keyPressed() {
   //aec.keyPressed(key);
   if(key == ' '){
     if(animationIterator.hasNext()==false){
       animationIterator = animations.iterator();   
     }
     anim = animationIterator.next();
     anim.init();
   }
   //save screenshot
   if(key == 's'){
      String filename = String.valueOf(year())+String.valueOf(month())+String.valueOf(day())+String.valueOf(hour())+String.valueOf(minute())+String.valueOf(second())+".png";
      save(filename);
   }
   //voting keys{
   switch(key){
     case 'q':
       Votes.add(-2);
       break;
     case 'w':
       Votes.add(-1);      
       break;
     case 'e':
       Votes.add( 1);
       break;
     case 'r':
       Votes.add( 2);
       break;
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
void mousePressed(){
  println("x:"+mouseX/aec.getScaleX()+" y:"+mouseY/aec.getScaleY());
}
