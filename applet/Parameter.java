//this is in a java file to be able to have static values
class Parameter{
  
  final static int NUMBER = 0;
  final static int COLOR  = 1;
  
  String name;
  int type;
  float minValue;
  float maxValue;
  
  Parameter(String _name,float _minValue,float _maxValue){
    name = _name;
    type = Parameter.NUMBER;
    minValue = _minValue;
    maxValue = _maxValue;
  }
  
  Parameter(String _name,int _type){
    name = _name;
    type = _type;
    minValue = 0;
    maxValue = 100;
  }
  
  
 
}
