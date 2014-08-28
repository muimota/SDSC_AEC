import java.util.Iterator;
import de.looksgood.ani.*;
import controlP5.*;

AEC aec; 


ArrayList<Integer> votes; //-2 NO,-1 RNO,1 RYES,2 YES

ControlP5 cp5;
participationModel pm;

ArrayList<String> controllerList;

//martin 23/05/2014
//yes 2 , rather yer 1 , rather no -1 , no -2
void setup() {
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
    
    //init dbCom
    //dcom dbCom   = new dcom("23karat.de","3306","karat_SCSD","karat_49","****"); 
    dcom dbCom = new dcom("localhost","3306","SCSD","scsd","scsd");
    ArrayList<facadeVisualization> animations = new ArrayList<facadeVisualization>();
    
    animations.add(new trailsVisualization("Category1",#004DFF,#999999,50,0.5,10,0,10,true)); 
    animations.add(new trailsVisualization("Category2",#00DD63,#999999,50,0.5,10,0,10,true));
    animations.add(new trailsVisualization("Category3",#E400E3,#999999,50,0.5,10,0,10,true));
    animations.add(new trailsVisualization("Category4",#004DFF,#999999,50,0.5,10,0,10,true)); 
    animations.add(new trailsVisualization("Category5",#00DD63,#999999,50,0.5,10,0,10,true));
    animations.add(new trailsVisualization("Category6",#E400E3,#999999,50,0.5,10,0,10,true));
  
    pm = new participationModel(animations);
    pm.dbCom = dbCom;
    dbCom.setDashboardListener(pm);    
    dbCom.start();
   
}
  
  void draw() {
    
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
  
  
  void keyPressed() {
    
     //save screenshot
     if(key == 's'){
        String filename = String.valueOf(year())+String.valueOf(month())+String.valueOf(day())+String.valueOf(hour())+String.valueOf(minute())+String.valueOf(second())+".png";
        save(filename);
     }
     
  }

void clearAnimationGUI(){
  //remove controller from the previus animation
 
  for(Parameter p:pm.anim.parameters){
    cp5.remove(p.name);
  }
 
}


void createAnimationGUI(){
  PVector sliderCol = new PVector(750,0);
  PVector colorCol  = new PVector(sliderCol.x+155,sliderCol.y);
  
  for(Parameter p:pm.anim.parameters){
    println(p.name+" - "+pm.anim.getFloatParameter(p.name));
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

//controlp5 handler

void controlEvent(ControlEvent theEvent) {
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
    //println(parameterName+" -> "+parameterValue);
    //pm.anim.setFloatParameter(parameterName,cp5.get(parameterName).getValue());
    pm.anim.setFloatParameter(parameterName,parameterValue);
  }else if(parameter.type==Parameter.COLOR){
    color col = ((ColorPicker)cp5.get(parameterName)).getColorValue();
    pm.anim.setColorParameter(parameterName,col);
  }  
}

