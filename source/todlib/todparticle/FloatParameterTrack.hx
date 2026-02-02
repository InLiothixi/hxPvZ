package todlib.todparticle;

import todlib.todcommon.TodCurves;

class FloatParameterTrack 
{
    public var nodes:Array<FloatParameterTrackNode>;

    public function new(?nodes:Array<FloatParameterTrackNode>) 
    {
        this.nodes = nodes != null ? nodes : [];
    }

    public static function floatTrackEvaluate(track:FloatParameterTrack, timeValue:Float, interp:Float) : Float
    {
        if (track.nodes.length == 0)
        {
            return 0;
        }

        if (timeValue < track.nodes[0].time)
        {
            return TodCommon.todCurveEvaluate(interp, track.nodes[0].lowValue, track.nodes[0].highValue, track.nodes[0].distribution);
        }

        for (i in 1...track.nodes.length)
        {
           var aNodeNxt = track.nodes[i];
           if (timeValue <= aNodeNxt.time)
           {
                var aNodeCur = track.nodes[i-1];

                var aTimeFraction = (timeValue - aNodeCur.time) / (aNodeNxt.time - aNodeCur.time);
                var aLeftValue = TodCommon.todCurveEvaluate(interp, aNodeCur.lowValue, aNodeCur.highValue, aNodeCur.distribution);
                var aRightValue = TodCommon.todCurveEvaluate(interp, aNodeNxt.lowValue, aNodeNxt.highValue, aNodeNxt.distribution);
                return TodCommon.todCurveEvaluate(aTimeFraction, aLeftValue, aRightValue, aNodeCur.distribution);
           }
        }

        var aLastNode = track.nodes[track.nodes.length - 1];
        return TodCommon.todCurveEvaluate(interp, aLastNode.lowValue, aLastNode.highValue, aLastNode.distribution);
    }

    public static function floatTrackIsSet(track:FloatParameterTrack)
    {
        return track.nodes.length > 0 && track.nodes[0].curveType != TodCurves.CONSTANT;
    }

    public static function floatTrackIsConstantZero(track:FloatParameterTrack)
    {
        return track.nodes.length == 0 || (track.nodes.length == 1 && track.nodes[0].lowValue == 0 && track.nodes[0].highValue == 0);
    }

    public static function floatTrackEvaluateFromLastTime(track:FloatParameterTrack, timeValue:Float, interp:Float)
    {
        return timeValue < 0 ? 0 : floatTrackEvaluate(track, timeValue, interp);
    }
}