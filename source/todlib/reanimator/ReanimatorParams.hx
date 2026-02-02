package todlib.reanimator;

class ReanimatorParams
{
    public var reanimationType:ReanimationType;
    public var reanimFileName:String;
    public var reanimParamFlags:Int;

    public function new(type:ReanimationType, fileName:String, paramFlag:Int = 0) 
    {
        this.reanimationType = type;
        this.reanimFileName = fileName;
        this.reanimParamFlags = paramFlag;    
    }
}