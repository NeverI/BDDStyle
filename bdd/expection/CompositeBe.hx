package bdd.expection;

import haxe.PosInfos;

class CompositeBe
{
    public var a(default, null):A;
    public var an(default, null):An;

    private var be:Be;
    private var number:Number;
    private var equalChecker:Equal;
    private var collection:Collection;

    public function new(reporter:ItReporter, isNegated:Bool = false)
    {
        this.a = new A(reporter, isNegated);
        this.be = new Be(reporter, isNegated);
        this.an = new An(reporter, isNegated);
        this.number = new Number(reporter, isNegated);
        this.equalChecker = new Equal(reporter, isNegated);
        this.collection = new Collection(reporter, isNegated);
    }

    public function True(actual:Bool, ?pos:PosInfos):Void
    {
        this.be.True(actual, pos);
    }

    public function False(actual:Bool, ?pos:PosInfos):Void
    {
        this.be.False(actual, pos);
    }

    public function equal(expected:Dynamic, actual:Dynamic, ?pos:PosInfos):Void
    {
        this.equalChecker.equal(expected, actual, pos);
    }

    public function empty(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.collection.empty(actual, pos);
    }

    public function first(expected:Dynamic, actual:Dynamic, ?pos:PosInfos):Void
    {
        this.collection.first(expected, actual, pos);
    }

    public function nth(index:Int, expected:Dynamic, actual:Dynamic, ?pos:PosInfos):Void
    {
        this.collection.nth(index, expected, actual, pos);
    }

    public function last(expected:Dynamic, actual:Dynamic, ?pos:PosInfos):Void
    {
        this.collection.last(expected, actual, pos);
    }

    public function below(expected:Float, actual:Float, ?pos:PosInfos):Void
    {
        this.number.below(expected, actual, pos);
    }

    public function above(expected:Float, actual:Float, ?pos:PosInfos):Void
    {
        this.number.above(expected, actual, pos);
    }

    public function whitin(above:Float, actual:Float, below:Float, ?pos:PosInfos):Void
    {
        this.number.whitin(above, actual, below, pos);
    }

    public function floatEqual(expected:Float, actual:Float, margin:Float = 0.00001, ?pos:PosInfos):Void
    {
        this.number.floatEqual(expected, actual, margin, pos);
    }

    public function NaN(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.number.NaN(actual, pos);
    }
}
