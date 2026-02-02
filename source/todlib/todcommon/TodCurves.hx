package todlib.todcommon;

enum abstract TodCurves(Int) from Int to Int
{
    var CONSTANT;           
    var LINEAR;          
    var EASE_IN;             
    var EASE_OUT;             
    var EASE_IN_OUT;         
    var EASE_IN_OUT_WEAK;    
    var FAST_IN_OUT;        
    var FAST_IN_OUT_WEAK;     
    var WEAK_FAST_IN_OUT;    
    var BOUNCE;         
    var BOUNCE_FAST_MIDDLE;   
    var BOUNCE_SLOW_MIDDLE;  
    var SIN_WAVE;           
    var EASE_SIN_WAVE;  
}