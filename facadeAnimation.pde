//martin 23/05/2014
//yes 2 , rather yer 1 , rather no -1 , no -2


abstract class  facadeVisualization{
 abstract void initVotes(ArrayList<Integer> votes);
 void addVote(int vote){}
 abstract void update();
 abstract void draw();
}

/***
GROWING LINE
***/
class growingLineAnimation extends facadeVisualization{
 float speed,position;
 color lineColor;
 
 growingLineAnimation(color _lineColor){
   lineColor = _lineColor;
 }
 
void initVotes(ArrayList<Integer> votes){
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
