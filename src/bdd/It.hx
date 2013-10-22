package bdd;

import bdd.expection.Result;

class It extends bdd.event.EventDispatcher implements IRunnable
{
    private var results:Array<Result>;

    private var _isDone:Bool;
    private var _isSuccess:Bool;
    private var _isPending:Bool;

    private var _overview:String;
    private var method:Void->Void;

    public function new(overview:String, ?method:Void->Void)
    {
        super();

        this._overview = overview;
        this.method = method;

        this.results = [];
        this._isDone = false;
        this._isPending = true;
        this._isSuccess = true;
    }

    public var overview(get, null):String;
    private function get_overview():String
    {
        return this._overview;
    }

    public var isPending(get, null):Bool;
    private function get_isPending():Bool
    {
        return this._isPending;
    }

    public var isDone(get, null):Bool;
    private function get_isDone():Bool
    {
        return this._isDone;
    }

    public var length(get, null):Int;
    private function get_length():Int
    {
        return this.results.length;
    }

    public function clearMethod():Void
    {
        this.method = null;
    }

    public function run():Void
    {
        if (this._isDone) {
            throw new bdd.exception.ItAbort('It already done');
        }

        this.trigger('it.start', this);

        if (this.method == null) {
            this.done();
            return;
        }

        try {
            this.method();
        } catch (e:Dynamic) {
            this.trigger('it.error', e);
        }
        this.done();
    }

    public function done():Void
    {
        if (this._isDone) {
            throw new bdd.exception.ItAbort('It already done');
        }

        this._isDone = true;
        this.trigger('it.done', this);
    }

    public function addResult(result:Result):Void
    {
        this.results.push(result);
        this._isPending = false;

        switch(result) {
            case Result.Success:
                return;
            default:
                this._isSuccess = false;
        }
    }

    public function iterator():Iterator<Result>
    {
        return this.results.iterator();
    }

    public var isSuccess(get, null):Bool;
    private function get_isSuccess():Bool
    {
        return this._isSuccess;
    }
}
