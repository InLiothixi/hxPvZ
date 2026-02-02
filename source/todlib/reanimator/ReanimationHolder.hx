package todlib.reanimator;

class ReanimationHolder
{
    public var reanimations:Array<Reanimation>;

    public function new() {}

    public function initializeHolder() 
    {
        reanimations = [];
    }

    public function disposeHolder() 
    {
        for (reanim in reanimations)
        {
            reanim.reanimationDie();
            reanimations.remove(reanim);
        }

        reanimations = null;
    }

    public function allocReanimation(x:Float, y:Float, order:Int, reanimType:ReanimationType) 
    {
        var aReanim = new Reanimation();
        aReanim.renderOrder = order;
        aReanim.reanimationHolder = this;
        aReanim.reanimationInitializeType(x, y, reanimType);
        reanimations.push(aReanim);
        return aReanim;
    }
}