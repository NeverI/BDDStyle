package bdd.expection;

import bdd.exception.ItAbort;
import haxe.PosInfos;

class CompositeShould
{
    public var be(default, null):CompositeBe;
    public var have(default, null):CompositeHave;
    public var not(get, null):CompositeShould;

    private var thrower:Throw;
    private var should:Should;
    private var string:Strings;
    private var collection:Collection;
    private var negatedShould:CompositeShould;

    private var reporter:ItReporter;
    private var isNegated:Bool;

    public function new(reporter:ItReporter, isNegated:Bool = false)
    {
        this.reporter = reporter;
        this.isNegated = isNegated;

        this.should = new Should(reporter, isNegated);
        this.thrower = new Throw(reporter, isNegated);
        this.be = new CompositeBe(reporter, isNegated);
        this.string = new Strings(reporter, isNegated);
        this.have = new CompositeHave(reporter, isNegated);
        this.collection = new Collection(reporter, isNegated);
    }

    private function get_not():CompositeShould
    {
        if (this.negatedShould == null ) {
            this.negatedShould = new CompositeShould(this.reporter, !this.isNegated);
        }
        return this.negatedShould;
    }

    public function success(?pos):Void
    {
        this.should.success(pos);
    }

    public function fail(msg:String = 'Fail anyway', ?pos:PosInfos):Void
    {
        this.should.fail(msg, pos);
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

    public function throws(method: Void->Void, ?expected:Dynamic, ?pos:PosInfos):Void
    {
        this.thrower.throws(method, expected, pos);
    }

    public function contains(expected:Dynamic, actual:Dynamic, ?pos:PosInfos):Void
    {
        this.collection.contains(expected, actual, pos);
    }
}
