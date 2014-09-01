import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Iterator; 
import java.util.Collections; 
import de.looksgood.ani.*; 
import controlP5.*; 
import java.awt.Color; 
import org.aec.facade.*; 

import com.mysql.jdbc.integration.c3p0.*; 
import com.mysql.jdbc.jmx.*; 
import com.*; 
import com.mysql.jdbc.*; 
import com.mysql.jdbc.jdbc2.optional.*; 
import com.mysql.jdbc.util.*; 
import com.mysql.jdbc.profiler.*; 
import com.mysql.jdbc.authentication.*; 
import com.mysql.jdbc.log.*; 
import org.gjt.mm.mysql.*; 
import com.mysql.jdbc.exceptions.*; 
import com.mysql.jdbc.exceptions.jdbc4.*; 
import com.mysql.jdbc.interceptors.*; 
import com.mysql.jdbc.integration.jboss.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class equalizer extends PApplet {







AEC aec; 


ArrayList<Integer> votes; //-2 NO,-1 RNO,1 RYES,2 YES

ControlP5 cp5;
participationModel pm;

ArrayList<String> controllerList;

int prevCategory=-1,category=-1;

//martin 23/05/2014
//yes 2 , rather yer 1 , rather no -1 , no -2
public void setup() {
    frameRate(25);
    size(1200, 400);
    
    //init AEC facade library
    aec = new AEC();
    aec.init();
   
    
    //Init Ani library
    Ani.init(this);
    Ani.overwrite();
    
    //GUI
    cp5 = new ControlP5(this);
    cp5.addButton("SAVE CONFIG", 0, 10, 360, 58, 30);
    
    ArrayList<facadeVisualization> animations = new ArrayList<facadeVisualization>();
    
    animations.add(new trailsVisualization("Category0",0xff004DFF,0xff999999,50,0.5f,10,0,10,true)); 
    animations.add(new trailsVisualization("Category1",0xff00DD63,0xff999999,50,0.5f,10,0,10,true));
    animations.add(new trailsVisualization("Category2",0xffE400E3,0xff999999,50,0.5f,10,0,10,true));
    animations.add(new trailsVisualization("Category3",0xff004DFF,0xff999999,50,0.5f,10,0,10,true)); 
    animations.add(new trailsVisualization("Category4",0xff00DD63,0xff999999,50,0.5f,10,0,10,true));
    animations.add(new trailsVisualization("Category5",0xffE400E3,0xff999999,50,0.5f,10,0,10,true));
    
    for(facadeVisualization vis:animations){
      loadVisualization(vis);
    }
    
    //init dbCom
    //dcom dbCom   = new dcom("23karat.de","3306","karat_SCSD","karat_49","ypbDgAWwQgtVjX41"); 
    dcom dbCom = new dcom("localhost","3306","SCSD","scsd","scsd");
    pm = new participationModel(animations);
    pm.dbCom = dbCom;
    pm.dbCom.setDashboardListener(pm);
    dbCom.start();
    
}
  
  public void draw() {
    //this could be modified 
    pm.update();    
    
    background(0);
    pm.anim.update();
    aec.beginDraw();
      noStroke();
      noSmooth();
      pm.anim.draw();
    aec.endDraw(); 
    aec.drawSides();
    
    pushStyle();
    stroke(255);
    fill(255);
    text(pm.anim.toString(),0,300);
    popStyle();
  }
  
  
  public void keyPressed() {
    
     //save screenshot
     if(key == 's'){
        String filename = String.valueOf(year())+String.valueOf(month())+String.valueOf(day())+String.valueOf(hour())+String.valueOf(minute())+String.valueOf(second())+".png";
        save(filename);
     }
     
  }

public void  clearAnimationGUI(){
  //remove controller from the previus animation
 
  for(Parameter p:pm.anim.parameters){
    cp5.remove(p.name);
  }
 
}


public void createAnimationGUI(){
  PVector sliderCol = new PVector(750,0);
  PVector colorCol  = new PVector(sliderCol.x+155,sliderCol.y);
  
  for(Parameter p:pm.anim.parameters){
    if(p.type==Parameter.COLOR){
      cp5.addColorPicker(p.name)
      .setColorValue(pm.anim.getColorParameter(p.name))
      .setPosition(colorCol.x,colorCol.y);
      colorCol.y+=65;
    }else if(p.type==Parameter.NUMBER){
      cp5.addSlider(p.name).setValue(pm.anim.getFloatParameter(p.name))
      .setPosition(sliderCol.x,sliderCol.y)
      .setRange(p.minValue,p.maxValue);
      sliderCol.y+=15;;    }
  }
}

public void loadVisualization(facadeVisualization vis){
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

public void saveVisualization(facadeVisualization vis){
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

//controlp5 handler

public void controlEvent(ControlEvent theEvent) {
  String parameterName = theEvent.getName();
  
  if(parameterName.equals("SAVE CONFIG")){
    saveVisualization(pm.anim);
    return;
  } 
 
  Parameter parameter = null;
  //find parameter in animation parameters
  for(Parameter p:pm.anim.parameters){
    if(parameterName.equals(p.name)){
      parameter  = p;
      break;
    }
  }
  
  if(parameter.type==Parameter.NUMBER){
    float parameterValue = cp5.get(parameterName).getValue();
    pm.anim.setFloatParameter(parameterName,parameterValue);
  }else if(parameter.type==Parameter.COLOR){
    int col = ((ColorPicker)cp5.get(parameterName)).getColorValue();
    pm.anim.setColorParameter(parameterName,col);
  }  
}





class AEC {
  AECPlugin plugin = new AECPlugin();
  HouseDrawer house = new HouseDrawer(plugin);
  
  public AEC() {
  }

  public void init() {
    plugin.setFrameWidth(width);
    plugin.init();
    loadConfig();
  }
    
  public void loadConfig() {
    plugin.loadConfig();
  }
  
  public void beginDraw() {
    scale(2 * plugin.scale, plugin.scale);
  }
  
  public void endDraw() {
    // reset of the transformation
    resetMatrix();
    
    loadPixels();
    plugin.update(pixels);
  }
  
  public void drawSides() {
    house.draw();
  }
  
  public void keyPressed(int value) {
    plugin.keyPressed(value, keyCode);
    
    if (value == 'i') {
      house.toggleIds();
    }
  }

  public void setActiveColor(Color c) {
    plugin.setActiveColor(c);
  }

  public void setInActiveColor(Color c) {
    plugin.setInActiveColor(c);
  }
  
  public int getScaleX() {
    return 2 * plugin.scale;
  }
  
  public int getScaleY() {
    return plugin.scale;
  }  
}

class HouseDrawer {
  AECPlugin aec;
  int size = 10;  
  PFont font;
  boolean showIds = false;
  
  public HouseDrawer(AECPlugin aec_) {
    aec = aec_;
    font = loadFont("LucidaConsole-8.vlw"); 
  }
  
  public void toggleIds() {
    showIds = !showIds;
  }
  
  public void draw() {
    resetMatrix();
    
    for (int i = 0; i < Building.SIDE.values().length; ++i) {
      Building.SIDE sideEnum = Building.SIDE.values()[i];
      Side side = aec.getSide(sideEnum);
      
      stroke(side.getColor().getRed(), side.getColor().getGreen(), side.getColor().getBlue(), side.getColor().getAlpha());
      noFill();
      drawSide(side);     
    }
  }
  
  public void drawSide(Side s) {
    int[][] adr = s.getWindowAddress();
    int pWidth = s.getPixelWidth();
    int pHeight = s.getPixelHeight();

    for (int y = 0; y < adr.length; ++y) {
      for (int x = 0; x < adr[y].length; ++x) {
        if (adr[y][x] > -1) {
          int fx = (s.getX() + x * pWidth) * aec.scale;
          int fy = (s.getY() + y * pHeight) * aec.scale;
          rect(fx, fy, pWidth * aec.scale, pHeight * aec.scale);
          
          if (showIds) {
            textFont(font, 8); 
            text("" + adr[y][x], fx + pWidth * aec.scale / 4, fy + pHeight * aec.scale * 0.9f);
          }
        }
      }
    }
  }
}

abstract class  facadeVisualization{
  String visualizationName;
  int yesVotes,noVotes,totalVotes;
  
  PGraphics hiFacade;  //hiresolution 400x240
  PImage    lowFacade; //low res 40x24 facade 
  
  ArrayList<Parameter> parameters;
  
  facadeVisualization(){
    hiFacade  = createGraphics(400,240);
    lowFacade = new PImage(40,24);
    parameters = new ArrayList<Parameter>();
  }
  public void initVotes(int _yesVotes,int _noVotes){
    yesVotes=_yesVotes;
    noVotes=_noVotes;
    totalVotes=yesVotes+noVotes; 
  }
  public void initVotes(ArrayList<Integer> votes){
    int _yesVotes=0;
    int _noVotes=0;
    for (int vote : votes){
      if(vote>0){
        _yesVotes++;
      }else{
        _noVotes++;
      }
    }
    initVotes(_yesVotes,_noVotes); 
  }
 
  
  public void addVote(int vote){
    if(vote<0){
      yesVotes++;
    }else{
      noVotes++;
    }
    totalVotes=yesVotes+noVotes;
  }
  

  public void  setFloatParameter(String parameterName,float parameterValue){};
  public float getFloatParameter(String parameterName){return Float.NaN;};
  
  public void   setColorParameter(String parameterName,int parameterValue){}
  public int  getColorParameter(String parameterName){return 0;};

  
  public void update(){};
  
  public abstract void draw();
  
  public void heart(){};
  public void drawFacade(boolean pixelate){
    //TODO:pixelate should be removed, is not efficent and useless
    if(!pixelate){
      //pixelate
      hiFacade.loadPixels();
      for(int i=0;i<40;i++){
        for(int j=0;j<24;j++){
          int r = 0;
          int g = 0;
          int b = 0;
          for(int k=0;k<10;k+=2){
            for(int l=0;l<10;l+=2){
              int index = (j*400+i)*10+l*400+k;
              int c = hiFacade.pixels[index];
              r += c>>16&0xFF;
              g += c>>8&0xFF;
              b += c&0xFF;
            }
          }
          r /= 20;
          g /= 20;
          b /= 20;
          lowFacade.set(i,j,color(r,g,b));
        }
      }
    }else{
      lowFacade.copy(hiFacade,0,0,400,240,0,0,40,24);
    }
    image(lowFacade,0,0);
  }
  
  public String toString(){
    int percentageOfYesVotes = (totalVotes > 0) ? round(yesVotes/PApplet.parseFloat(totalVotes)*100.0f) : 0;
    return "name:"+visualizationName +" totalVotes:" +totalVotes +" positiveVotes"+ yesVotes +"("+percentageOfYesVotes+"%) negativeVotes:"+noVotes+"("+(100-percentageOfYesVotes)+"%)";
  }
  
}


class participationModel implements DashboardListener{
  
  ArrayList<facadeVisualization> animations;
  ArrayList<Integer> votes;
  facadeVisualization anim;
  dcom dbCom;
  int catID;
  boolean categoryChanged;
  
  participationModel(ArrayList<facadeVisualization> _animations){
    votes = new ArrayList<Integer>();
    animations =  _animations;
    anim  = animations.get(0);
    anim.initVotes(votes);
    categoryChanged=false;
  }
  
  public void categorySelected(int _catID){
    println("categorySelected called");
    catID = _catID;
    categoryChanged = true;
  }
  
  public void updateCategory(){
    Ani.killAll();
    clearAnimationGUI();
    anim = animations.get(catID);
    updateVotes();
    println(votes.size());
    anim.initVotes(votes);
    createAnimationGUI(); 
    categoryChanged=false;
  }
  //called from main thread to check if the category has changed 
  public void update(){
    if(categoryChanged){
      updateCategory();
    }   
  }
  public void sentimentSubmitted(int prefID, String cardID){
     if(prefID==0){
        anim.addVote(-1);
      }else{
        anim.addVote(1);
      }
  }
  public void specialCategorySelected(int val){
    println("heart event (" + val +")");
    if(val==0){
      anim.heart();
    }
  }
  
  
  //update votes from database
  public void updateVotes(){
    votes.clear();
    ArrayList<DatabaseParticipant> participants = dbCom.getParticipants();
    
    for(DatabaseParticipant participant: participants){
      //SDSC code votes 0,1,2 here <0 >0 for positive/negative votes
      if(participant.getPrefID()<2){
        votes.add(-1);
      }else{
        votes.add(1);
      }
    }
    println("participants:"+participants.size()+" votes:"+votes.size());
  }
}

/***
STARFIELD
***/
class Star{
  PVector pos;
  PVector speed;
  float   expression;
  int     vote;
  boolean stacked;
  Star(){
    pos=new PVector();
    speed =new PVector();
    stacked = false;
  }
}


class starFieldVisualization extends facadeVisualization{
  ArrayList<Star> stars = new ArrayList<Star>();
  int maxStars;
  int col0,col1;
  float minSpeed,maxSpeed;
 
  starFieldVisualization(String _visualizationName,int _col0,int _col1,float _minSpeed,float _maxSpeed, int _maxStars){
    super();
    parameters.add(new Parameter("maxStars",1,200));
    parameters.add(new Parameter("minSpeed",0,17));
    parameters.add(new Parameter("maxSpeed",0,17));
    parameters.add(new Parameter("col0",Parameter.COLOR));
    parameters.add(new Parameter("col1",Parameter.COLOR));
    visualizationName = _visualizationName;
    col0 = _col0;
    col1 = _col1;
    minSpeed = _minSpeed;
    maxSpeed = _maxSpeed;
    maxStars = _maxStars;
  }
  starFieldVisualization(String _visualizationName,int _col0,int _col1,float minSpeed,float maxSpeed ){
    this(_visualizationName,_col0,_col1,minSpeed,maxSpeed,10000);
  }
  
  starFieldVisualization(String _visualizationName,int _col0,int _col1,int maxStars){
    this(_visualizationName,_col0,_col1,1,5,maxStars );
  }
  starFieldVisualization(String _visualizationName,int _col0,int _col1){
    this(_visualizationName,_col0,_col1,0.1f,0.5f );
  }
  
  public void setFloatParameter(String parameterName,float parameterValue){
    super.setFloatParameter(parameterName,parameterValue);
   
    float prevMinSpeed = this.minSpeed;
    float prevMaxSpeed = this.maxSpeed;
    
    if(parameterName.equals("minSpeed")){
      minSpeed = parameterValue;
    }else if(parameterName.equals("maxSpeed")){
      maxSpeed = parameterValue;
    }else if(parameterName.equals("maxStars")){
      
      maxStars = floor(parameterValue);
      //reduce the number of stars
      if(maxStars<stars.size()){
        int removeCount = stars.size()-maxStars;
        for(int i=0;i<removeCount;i++){
          stars.remove(0); 
        }
      }else if(maxStars<totalVotes){
        initVotes(yesVotes,noVotes);
      }
    }
     
    if(prevMinSpeed!=minSpeed){
        int starsCount = min(stars.size(),maxStars);
        if(stars!=null){
          for(int i=0;i<starsCount;i++){
            Star star = stars.get(i);
            star.speed.x=map(star.speed.x,0,prevMinSpeed,0,minSpeed);
          }
        }
    } 
  }
  public float getFloatParameter(String parameterName){
     float returnValue = super.getFloatParameter(parameterName);
     if(parameterName.equals("minSpeed")){
       returnValue = minSpeed;
     }else if(parameterName.equals("maxSpeed")){
       returnValue = maxSpeed;
     }else if(parameterName.equals("maxStars")){
       returnValue = maxStars;
   
     }
     return returnValue;
  };
  
  public void setColorParameter(String parameterName,int parameterValue){
    if(parameterName.equals("col0")){
       col0 = parameterValue;
     }else if(parameterName.equals("col1")){
       col1 = parameterValue;
     }
  }
  
  public int getColorParameter(String parameterName){
    int parameterValue = super.getColorParameter(parameterName);
    if(parameterName.equals("col0")){
      parameterValue = col0;
    }else if(parameterName.equals("col1")){
      parameterValue = col1;
    }
    return parameterValue;
  }
  
  public void initVotes(int _yesVotes,int _noVotes){
    super.initVotes(_yesVotes,_noVotes);
    stars = new ArrayList<Star>();
    int totalStars = min(totalVotes,maxStars);
    int yesStars;
    
    if(totalStars<totalVotes){
      yesStars = round((yesVotes/(float)totalVotes)*maxStars);
    }else{
      yesStars = yesVotes; 
    }
    for(int i=0;i<totalStars;i++){
      Star star = new Star();
      //position
      star.pos.x = random(400);
      //we round it so in vertizally is always alligned to the facade
      star.pos.y = floor(random(24))*10;
      //speed
      star.speed.x=minSpeed*lerp(random(1),0.8f,1.2f);
     
      if(i<yesStars){
        star.vote = 1;
      }else{
        star.vote = -1;
      } 
      star.expression = 0;
      stars.add(star);
    }
    Collections.shuffle(stars);
  }
  public void initVotes(ArrayList<Integer> votes){
    super.initVotes(votes);
    initVotes(yesVotes,noVotes);
  }
  public void addVote(int vote){
    super.addVote(vote);
    
    
    Star star = new Star();
    star.pos.x = 300;
    star.pos.y = floor(random(24))*10;
    star.vote=vote;
    
    star.expression = 1.0f;
    Ani.to(star,8 ,"expression",0,Ani.LINEAR);
    
    star.speed.x=maxSpeed;
    Ani.to(star.speed,8 ,"x",minSpeed*lerp(random(1),0.8f,1.2f),Ani.LINEAR);
    
    stars.add(star);
    //if starcount is exceed remove star
    if(stars.size()>maxStars){
      stars.remove(0);
    }
  }
  
  //checks if a vote has been added
  public void update(){
    //update positions
    int numberOfStars = stars.size();
     for(int i=0;i<numberOfStars;i++){
       Star star = stars.get(i);
       star.pos.x = (star.pos.x + star.speed.x) % 400.0f;
     }
  }
  public void draw(){
     hiFacade.beginDraw();
     hiFacade.background(0);
     hiFacade.rectMode(CENTER);
     for(int i=0;i<stars.size();i++){
       Star star = stars.get(i);  
       int voteColor = star.vote>0 ? col0:col1;  
       
       int col = lerpColor(voteColor,0xffFFFFFF,star.expression);         
       hiFacade.fill(col);
       
       int size = floor(map(star.expression,0,1,11,50));
       
       
       hiFacade.rect(floor(star.pos.x),floor(star.pos.y),size,size);
       
     }
     
     hiFacade.endDraw();
     drawFacade(true);
  } 
}

/*Trails version */
class trailsVisualization extends starFieldVisualization{
  int blurLevel;
  float alphaLevel;
  boolean pixelate;
  float flashLevel;
  int voteColor;
  int stack;
  boolean heartSeq=false;
  int stacks[];
  int yesRow;
  
  //heart parameters
  float accelerationTime= 1.0f;
  float speedFactor     = 1.0f;
  float speedUpTime     = 1.0f;
  float distributeTime  = 1.0f;
  float stackingTime    = 1.0f;
  float organizeTime    = 1.0f;
  float speedDownTime   = 1.0f;
  
  trailsVisualization(String _visualizationName,int _col0,int _col1,int maxParticles,float minSpeed,float maxSpeed, int _blurLevel,float _alphaLevel,boolean _pixelate){
    super(_visualizationName,_col0,_col1,minSpeed,maxSpeed,maxParticles );
    parameters.add(new Parameter("blurLevel",0,10));
    parameters.add(new Parameter("trailLevel",0,10));
    parameters.add(new Parameter("accelerationTime",0,10));
    parameters.add(new Parameter("speedFactor",1,10));  
    parameters.add(new Parameter("speedUpTime",0,10));
    parameters.add(new Parameter("distributeTime",0,10));
    parameters.add(new Parameter("stackingTime",0,10));
    parameters.add(new Parameter("organizeTime",0,10));
    parameters.add(new Parameter("speedDownTime",0,10));
    
    blurLevel = _blurLevel;
    alphaLevel = _alphaLevel;
    pixelate = _pixelate;
    
    stack = 0;
    stacks = new int[24];
    stackReset();
  }
  
  public void setFloatParameter(String parameterName,float parameterValue){
     
    super.setFloatParameter(parameterName,parameterValue);
    
    if(parameterName.equals("blurLevel")){
      blurLevel = round(parameterValue);
    }else if(parameterName.equals("trailLevel")){
      alphaLevel = (parameterValue==0)?0:map(parameterValue,1,10,10,1);
    }else if(parameterName.equals("accelerationTime")){
      accelerationTime = parameterValue;
    }else if(parameterName.equals("speedFactor")){
      speedFactor = parameterValue;
    }else if(parameterName.equals("speedUpTime")){
      speedUpTime = parameterValue;
    }else if(parameterName.equals("distributeTime")){
      distributeTime = parameterValue;
    }else if(parameterName.equals("stackingTime")){
      stackingTime = parameterValue;
    }else if(parameterName.equals("organizeTime")){
      organizeTime = parameterValue;
    }else if(parameterName.equals("speedDownTime")){
      speedDownTime = parameterValue;
    }
  }
  public float getFloatParameter(String parameterName){
     float returnValue = super.getFloatParameter(parameterName);
     if(parameterName.equals("blurLevel")){
       returnValue = round(blurLevel);
     }else if(parameterName.equals("trailLevel")){
       returnValue =  (alphaLevel==0)?0:map(alphaLevel,1,10,10,1);
     }else if(parameterName.equals("accelerationTime")){
       returnValue =accelerationTime;
     }else if(parameterName.equals("speedFactor")){
       returnValue =speedFactor;
     }else if(parameterName.equals("speedUpTime")){
       returnValue = speedUpTime;
     }else if(parameterName.equals("distributeTime")){
       returnValue = distributeTime;
     }else if(parameterName.equals("stackingTime")){
       returnValue = stackingTime;
     }else if(parameterName.equals("organizeTime")){
       returnValue = organizeTime;
     }else if(parameterName.equals("speedDownTime")){
       returnValue = speedDownTime;
     }
     return returnValue;
  };
  
  public void setColorParameter(String parameterName,int parameterValue){
    if(parameterName.equals("col0")){
       col0 = parameterValue;
     }else if(parameterName.equals("col1")){
       col1 = parameterValue;
     }
  }
  
  public int getColorParameter(String parameterName){
    int parameterValue = super.getColorParameter(parameterName);
    if(parameterName.equals("col0")){
      parameterValue = col0;
    }else if(parameterName.equals("col1")){
      parameterValue = col1;
    }
    return parameterValue;
  }
  
  public void heart(){
    if(heartSeq){
      return;
    }
    
    heartSeq  =true;
    
    int numberOfStars = stars.size();
    float yesRatio = yesVotes/PApplet.parseFloat(totalVotes);
    //kill all previus animation
    Ani.killAll();
    //set all stars speed to normal 
    flashLevel=0;
    for(Star star:stars){
       if(star.expression>0){
         star.expression=0;
         star.speed.x=minSpeed*lerp(random(1),0.8f,1.2f);
       }
    }
    //from row 1 to 22
    yesRow=(23-floor(yesRatio*22))*10;    
    for(int i=0;i<numberOfStars;i++){
      Star star = stars.get(i);
      AniSequence seq = new AniSequence(Ani.papplet());
      seq.beginSequence();
     
      int starY;
      if(star.vote>0){//yes
        //starY=round(random(0,yesRatio*230));   
        starY=yesRow;
      }else{//no
        //starY=round(random(yesRatio*230,230));
        starY=yesRow-10;
      }
       //we have to make copies of variables for Ani return to original values
      float posy = star.pos.y;
      float speedx = star.speed.x;
      //acceleration time to 
      seq.add(Ani.to(star.speed,accelerationTime ,"x",star.speed.x*speedFactor,Ani.LINEAR));
      //move up or down depending in the vote
      seq.add(Ani.to(star.pos  ,distributeTime,speedUpTime ,"y",starY,Ani.LINEAR));
      //stack
      seq.add(Ani.to(this  ,0.001f ,"stack",1,Ani.LINEAR));
      //stop stacking after stackingTime
      seq.add(Ani.to(this  ,0.001f ,stackingTime ,"stack",0,Ani.LINEAR,"onEnd:stackReset"));
      //back to it's original (vertical) position
      seq.add(Ani.to(star.pos  ,organizeTime ,"y",posy,Ani.LINEAR));
      //back to it's original speed
      seq.add(Ani.to(star.speed,speedDownTime ,"x",speedx,Ani.LINEAR));
      
      seq.endSequence();
      seq.start();    
    } 
    
  }
  //reset stack values
  public void stackReset(){
    for(int i=0;i<stacks.length;i++){
      stacks[i]=0;
    }
    
    for(int i=0;stars!=null && i<stars.size();i++){
      Star star = stars.get(i);
      star.stacked=false;
    }
    heartSeq = false;
  }
  public void update(){
    //update positions
    int numberOfStars = stars.size();
     for(int i=0;i<numberOfStars;i++){
       Star star = stars.get(i);
       //if no stacking
       if(stack==0){
         star.pos.x = (star.pos.x + star.speed.x) % 400.0f;
       }else{
         int row = round(star.pos.y/10);
         if(star.pos.x<390-stacks[row]){
            star.pos.x = (star.pos.x + star.speed.x) % 400.0f; 
         }else if(!star.stacked){
            stacks[row]+=10;
            star.stacked=true;
         }
       }
     }
  }
    
  public void initVotes(ArrayList<Integer> votes){
    super.initVotes(votes);
    flashLevel=0;
  }
  public void addVote(int vote){
    //add Vote only if a heart animation is not running
    if(stack==0){
      super.addVote(vote);
      flashLevel=1.0f;
      Ani.to(this,1 ,"flashLevel",0,Ani.LINEAR);
      voteColor = vote>0 ? col0:col1;
    } 
  }
  public void draw(){
    hiFacade.beginDraw();
    hiFacade.noStroke();
    
    hiFacade.fill(color(0,0,0,alphaLevel));
    hiFacade.rectMode(CENTER);
    hiFacade.rect(200,120,400,240);
    
    for(int i=0;i<stars.size();i++){
      Star star = stars.get(i);  
      if(star.stacked){
        continue;
      }
      int voteColor = star.vote>0 ? col0:col1;  
       
      int col = lerpColor(voteColor,0xffFFFFFF,star.expression);         
      hiFacade.fill(col);
      int size = floor(map(star.expression,0,1,10,50)); 
      hiFacade.rect(floor(star.pos.x),floor(star.pos.y),size,size);
    }
    //stacks
    if(stack==1){
      hiFacade.rectMode(CORNER);
      for(int i=0;i<24;i++){
        if(i>=yesRow/10){ 
          hiFacade.fill(col0);
        }else{
          hiFacade.fill(col1);
        }
        hiFacade.rect(400-stacks[i],i*10,stacks[i],10);
      }
    }
    hiFacade.rectMode(CENTER);
    hiFacade.filter(BLUR,blurLevel);
    hiFacade.endDraw();
    drawFacade(pixelate);
    
    //flash in votes
    if(flashLevel>0){
      int flashColor=color(red(voteColor),green(voteColor),blue(voteColor),flashLevel*255);
      fill(flashColor);
      rect(0,0,73,28);
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "equalizer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
