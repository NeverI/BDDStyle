package bdd.expection;

import haxe.PosInfos;

class CompositeHave
{
    private var object:Object;
    private var collection:Collection;

    public function new(reporter:ItReporter, isNegated:Bool = false)
    {
        this.object = new Object(reporter, isNegated);
        this.collection = new Collection(reporter, isNegated);
    }

    public function length(expected:Int, actual:Dynamic, ?pos:PosInfos):Void
    {
        this.collection.length(expected, actual, pos);
    }

    public function property(expected:String, actual:Dynamic, ?pos:PosInfos):Void
    {
        this.object.property(expected, actual, pos);
    }

    public function properties(expected:Array<String>, actual:Dynamic, ?pos:PosInfos):Void
    {
        this.object.properties(expected, actual, pos);
    }
}
