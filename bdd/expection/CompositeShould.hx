package bdd.expection;

import bdd.exception.ItAbort;
import haxe.PosInfos;

class CompositeShould
{
    private var _be:CompositeBe;
    private var _have:CompositeHave;
    private var _throw:Throw;
    private var _should:Should;
    private var string:Strings;
    private var _collection:Collection;
    private var _negatedShould:CompositeShould;

    private var reporter:ItReporter;
    private var isNegated:Bool;

    public function new(reporter:ItReporter, isNegated:Bool = false)
    {
        this.reporter = reporter;
        this.isNegated = isNegated;

        this._have = new CompositeHave(reporter, isNegated);
        this._throw = new Throw(reporter, isNegated);
        this.string = new Strings(reporter, isNegated);
        this._should = new Should(reporter, isNegated);
        this._collection = new Collection(reporter, isNegated);
        this._be = new CompositeBe(reporter, isNegated);
    }

    public var be(get, null):CompositeBe;
    private function get_be():CompositeBe
    {
        return this._be;
    }

    public var have(get, null):CompositeHave;
    private function get_have():CompositeHave
    {
        return this._have;
    }

    public var not(get, null):CompositeShould;
    private function get_not():CompositeShould
    {
        if (this._negatedShould == null ) {
            this._negatedShould = new CompositeShould(this.reporter, !this.isNegated);
        }
        return this._negatedShould;
    }

    public function success(?pos):Void
    {
        this._should.success(pos);
    }

    public function fail(msg:String = 'Fail anyway', ?pos:PosInfos):Void
    {
        this._should.fail(msg, pos);
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
        this._throw.throws(method, expected, pos);
    }

    public function contains(expected:Dynamic, actual:Dynamic, ?pos:PosInfos):Void
    {
        this._collection.contains(expected, actual, pos);
    }
}
