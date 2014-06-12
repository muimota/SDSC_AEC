//martin 23/05/2014
//yes , rather yer , rather no, no


abstract class facadeAnimation{  
  

  abstract void init();
  abstract void update();
  abstract void draw();
}

/****

EQUALIZERS

*****/

//Basic equalizerAnimation allS pixel of the same color
class equalizerAnimation extends facadeAnimation{
  float[] eqValues;
  float[] peakValues;
  float smoothRatio;
  int frameCounter;
  void init(){
    frameCounter = 0;
    smoothRatio  = .1;
    eqValues = new float[40]; 
    peakValues = new float[40];
    for(int i=0;i<eqValues.length;i++){
      eqValues[i]=peakValues[i]=0;
    }
    
  }
  void update(){
    
    //new values
    if(frameCounter==0){
      for(int i=0;i<eqValues.length;i++){
        peakValues[i]=random(24);
      }
    }
    for(int i=0;i<eqValues.length;i++){
      eqValues[i]=eqValues[i]*(1-smoothRatio) + peakValues[i] * smoothRatio;  
    }
    frameCounter = (frameCounter+1) % 80;
    
  }
  void draw() {
    //draw
    for(int i=0;i<eqValues.length;i++){
      fill(#FFFFFF);
      int eqValue = round(eqValues[i]);
      rect(i,24-eqValue,1,eqValue);
    }
  }
}

//equalizer animation with vertical color 
class equalizerVerticalAnimation extends equalizerAnimation{
  //colors for every collumn of the facade
  color[] vertColors = {color(0xFF,0x00,0x66,0xCC),
                        color(0xFF,0xFF,0x33,0x33),
                        color(0xFF,0x66,0x66,0xCC),
                        color(0xFF,0x00,0xCC,0x99),
                        color(0xFF,0x00,0xCC,0xCC),
                        color(0xFF,0xCC,0xCC,0x66),
                        color(0xFF,0xCC,0xCC,0x99),
                        color(0xFF,0xFF,0xFF,0x00)};
  void draw() {
    //draw
    for(int i=0;i<eqValues.length;i++){
      int eqValue = round(eqValues[i]);
      fill(vertColors[i%vertColors.length]);
      rect(i,24-eqValue,1,eqValue);
    }
  }
}

//equalizer animation with each side of different color
class equalizerSideAnimation extends equalizerVerticalAnimation{
  //colors for every side of the facade
  color[] sideColors;
  equalizerSideAnimation(color side0Color,color side1Color,color side2Color,color side3Color){
    sideColors = new color[4];
    sideColors[0] = side0Color;
    sideColors[1] = side1Color;
    sideColors[2] = side2Color;
    sideColors[3] = side3Color;
  }
  void init(){
    super.init();
    vertColors = new color[40];
    for(int i=0;i<vertColors.length;i++){
      vertColors[i] = sideColors[i/10];
    }
  }
  
}



//equalizer animation with horizontal color 
class equalizerHorizontalAnimation extends equalizerAnimation{
  //colors for every row of the facade
  color[] horizColors;
  
  equalizerHorizontalAnimation(color[] _horizColors){
    horizColors = _horizColors;  
  }
  void draw() {
    //draw
    for(int i=0;i<eqValues.length;i++){
      int eqValue = round(eqValues[i]);
      for(int j=0;j<eqValue;j++){
        fill(horizColors[j%horizColors.length]);
        rect(i,24-j,1,1);
      }
    }
  }
}
//gradient
class equalizerGradientAnimation extends equalizerHorizontalAnimation{
  equalizerGradientAnimation(color startColor,color endColor){
    super(null);
    horizColors  = new color[24];
    for(int i=0;i<24;i++){
      horizColors[i] = lerpColor(startColor,endColor,i/24.0);
    }
  }
}

//equalizer animation with horizontal color 
class equalizerSymetricHorizontalAnimation extends equalizerAnimation{
  //colors for every row of the facade
  color[] horizColors = {#FF0000,#00FF00,#0000FF,#FFFF00};
  void draw() {
    //draw
    for(int i=0;i<eqValues.length;i++){
      int eqValue = round(eqValues[i]/2);
      for(int j=0;j<eqValue;j++){
        fill(horizColors[j%horizColors.length]);
        rect(i,12-j,1,1);
        fill(horizColors[(12+j)%horizColors.length]);
        rect(i,12+j,1,1);
      }
    }
  }
}

class equalizerSymetricHorizontalGradientAnimation extends equalizerSymetricHorizontalAnimation{
   equalizerSymetricHorizontalGradientAnimation(color topColor,color middleTopColor,color middleBottomColor,color bottomColor){
    horizColors  = new color[24];
    for(int i=0;i<12;i++){
      horizColors[i] = lerpColor(topColor,middleTopColor,i/12.0);
    }  
    for(int i=0;i<12;i++){
      horizColors[12+i] = lerpColor(middleBottomColor,bottomColor,i/12.0);
    }
  }
}
/***
STARFIELD
***/
class starFieldAnimation extends facadeAnimation{
  ArrayList<PVector> stars;
  
  color[] starColors;
  int numberOfStars;
  starFieldAnimation(color col0,color col1,int _numberOfStars){
    starColors  =new color[2];
    starColors[0] = col0;
    starColors[1] = col1;
    numberOfStars = _numberOfStars;
    stars = new ArrayList<PVector>(_numberOfStars);
    
  }
  void init(){
    println(stars.size());
    for(int i=0;i<numberOfStars;i++){
      PVector star = new PVector();
      star.x = random(40);
      star.y = random(24);
      star.z = random(starColors.length);
      stars.add(star);
    }
  }
  void update(){
    //update positions
     for(int i=0;i<stars.size();i++){
       PVector star = stars.get(i);
         star.x = (star.x + star.z*0.3) % 40.0;
     }
  }
  void draw(){
    
     for(int i=0;i<stars.size();i++){
       PVector star = stars.get(i);
       fill(starColors[floor(star.z)]);
       //if we are drawing in hte first side (x<10) 
       //that has half of resolution, we draw 2 unit width
       if(star.x<10){
         rect(floor(star.x)-floor(star.x)%2,floor(star.y),2,1);
       }else{
         rect(floor(star.x),floor(star.y),1,1);
       }
     }
  } 
}

class starFieldVisualization extends starFieldAnimation{
  int numberOfVotes;
  int frameNumOfLastVote;
  starFieldVisualization(color col0,color col1, ArrayList<Integer> _Votes){
    super(col0,col1,0);
    Votes = _Votes;
    numberOfVotes = Votes.size();
  }
  void init(){
    stars = new ArrayList<PVector>();
    for(int i=0;i<Votes.size();i++){
      PVector star = new PVector();
      star.x = random(40);
      star.y = random(24);
      if(Votes.get(i)<0){
        star.z=0;
      }else{
        star.z=1;
      }
      stars.add(star);
    }
  }
  void addVote(Integer vote){
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
    for(int i = numberOfVotes;i<Votes.size();i++){
      addVote(Votes.get(i));
    }
    numberOfVotes = Votes.size();
    //update positions
     for(int i=0;i<numberOfVotes;i++){
       PVector star = stars.get(i);
       float speed = map(i,0,numberOfVotes,0.1,2);
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

/***
GROWING LINE
***/
class growingLine extends facadeAnimation{
 float speed,position;
 color lineColor;
 
 growingLine(color _lineColor){
   lineColor = _lineColor;
 }
 
 void init(){
   speed=.5;
   position=0;
 } 
 void update(){
   position=(position+speed) % (40*24);
 }
 void draw(){
   int offset=round(position);
   int rows = min(24,offset/40);
   int col  = offset%40;
   fill(lineColor);
   rect(0,0,40,rows);
   rect(0,rows,col,1);
 }
}
