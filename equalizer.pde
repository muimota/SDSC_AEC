import java.util.Iterator;
import de.looksgood.ani.*;


AEC aec;


ArrayList<Integer> votes; //-2 NO,-1 RNO,1 RYES,2 YES

participationModel pm;

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
    
    //init dbCom
    dcom dbCom   = new dcom("23karat.de","3306","karat_SCSD","karat_49","****"); 
    
    ArrayList<facadeVisualization> animations = new ArrayList<facadeVisualization>();
    
    animations.add(new trailsVisualization(#004DFF,#999999,50,0.5,10,0,10,true)); 
    animations.add(new trailsVisualization(#00DD63,#999999,50,0.5,10,0,10,true));
    animations.add(new trailsVisualization(#E400E3,#999999,50,0.5,10,0,10,true));
    animations.add(new plasmaVisualization(color(255,0,59,126),color(255,255,255,126),50,0.5,1,50,5,false)); 
    animations.add(new plasmaVisualization(color(255,229,0,126),color(255,255,255,126),50,0.5,0.5,50,5,false)); 
    animations.add(new plasmaVisualization(color(255,229,0,126),color(255,255,255,126),50,0.5,0.5,50,5,false)); 
    
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
  
  void mousePressed(){
    println("x:"+mouseX/aec.getScaleX()+" y:"+mouseY/aec.getScaleY());
  }

