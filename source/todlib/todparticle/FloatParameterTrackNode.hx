package todlib.todparticle;

import todlib.todcommon.TodCurves;

class FloatParameterTrackNode
{
    public var time:Float;
    public var lowValue:Float;
    public var highValue:Float;
    public var curveType:TodCurves;
    public var distribution:TodCurves;

    public function new(time:Float, lowValue:Float, highValue:Float, curveType:TodCurves, distribution:TodCurves) 
    {
        this.time = time;
        this.lowValue = lowValue;
        this.highValue = highValue;
        this.curveType = curveType;
        this.distribution = distribution;
    }
}