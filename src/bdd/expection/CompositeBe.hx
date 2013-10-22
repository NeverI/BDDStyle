package bdd.expection;

import haxe.PosInfos;

class CompositeBe
{
    private var _a:A;
    private var be:Be;
    private var _an:An;
    private var _equal:Equal;
    private var number:Number;
    private var string:Strings;
    private var collection:Collection;

    public function new(reporter:ItReporter, isNegated:Bool = false)
    {
        this._a = new A(reporter, isNegated);
        this.be = new Be(reporter, isNegated);
        this._an = new An(reporter, isNegated);
        this._equal = new Equal(reporter, isNegated);
        this.number = new Number(reporter, isNegated);
        this.string = new Strings(reporter, isNegated);
        this.collection = new Collection(reporter, isNegated);
    }

    public var a(get, null):A;
    private function get_a():A
    {
        return this._a;
    }

    public var an(get, null):An;
    private function get_an():An
    {
        return this._an;
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
        this._equal.equal(expected, actual, pos);
    }

    public function empty(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.collection.empty(actual, pos);
    }

    public function length(expected:Int, actual:Dynamic, ?pos:PosInfos):Void
    {
        this.collection.length(expected, actual, pos);
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

    public function finite(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.number.finite(actual, pos);
    }

    public function match(expected:String, actual:String, ?pos:PosInfos):Void
    {
        this.string.match(expected, actual, pos);
    }

    public function startWith(expected:String, actual:String, ?pos:PosInfos):Void
    {
        this.string.startWith(expected, actual, pos);
    }

    public function endWith(expected:String, actual:String, ?pos:PosInfos):Void
    {
        this.string.endWith(expected, actual, pos);
    }
}
