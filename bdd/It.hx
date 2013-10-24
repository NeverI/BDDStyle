package bdd;

import bdd.expection.Result;

class It extends bdd.event.EventDispatcher implements IRunnable
{
    private var results:Array<Result>;

    private var _isSuccess:Bool;
    private var _isPending:Bool;

    private var _overview:String;
    private var method:Void->Void;

    private var asyncBlockHandler:AsyncBlockHandler;

    public function new(overview:String, ?method:Void->Void, ?asyncBlockHandler:bdd.AsyncBlockHandler)
    {
        super();

        this._overview = overview;
        this.method = method;

        this.results = [];
        this._isPending = true;
        this._isSuccess = true;

        this.asyncBlockHandler = asyncBlockHandler != null ? asyncBlockHandler : new AsyncBlockHandler();
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

    public var isSuccess(get, null):Bool;
    private function get_isSuccess():Bool
    {
        return this._isSuccess;
    }

    public var length(get, null):Int;
    private function get_length():Int
    {
        return this.results.length;
    }

    public function iterator():Iterator<Result>
    {
        return this.results.iterator();
    }

    public function clearMethod():Void
    {
        this.method = null;
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

    public function createAsyncBlock(block:Dynamic->Void, ?timeout:Int):Dynamic->Void
    {
        return this.asyncBlockHandler.createAsyncBlock(block, timeout);
    }

    public function run():Void
    {
        this.trigger('it.start', this);

        if (this.method == null) {
            this.done();
            return;
        }

        this.addListener('asyncBlock.done', this.asyncBlockDone);
        this.asyncBlockHandler.startListen();

        try {
            this.method();
        } catch (e:Dynamic) {
            this.trigger('it.error', e);
        }

        this.asyncBlockHandler.waitForAsync();
    }

    private function done():Void
    {
        this.trigger('it.done', this);
    }

    private function asyncBlockDone(isTimedOut:Bool):Void
    {
        this.removeListener('asyncBlock.done', this.asyncBlockDone);

        if (isTimedOut) {
            this.addResult(Result.Error('Async block is timed out'));
        }

        this.done();
    }
}
