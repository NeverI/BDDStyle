package bdd;

import bdd.event.EventDispatcher;

class DescribeTracker extends EventDispatcher
{
    public var isPending(get, null):Bool;

    private var current:Describe;
    private var currentIt:It;

    public function new()
    {
        super();

        this.addListener('describe.start', this.updateCurrent);
        this.addListener('it.start', this.updateCurrentIt);
    }

    private function get_isPending():Bool
    {
        return this.current == null ? true : this.current.isPending;
    }

    private function updateCurrent(describe:Describe):Void
    {
        this.current = describe;
    }

    private function updateCurrentIt(it:It):Void
    {
        this.currentIt = it;
    }

    public function start(describe:Describe):Void
    {
        this.current = describe;
    }

    public function addBeforeEach(method:Void->Void):Void
    {
        this.callOnCurrent('addBeforeEach', method);
    }

    private function callOnCurrent(methodName:String, param:Dynamic):Void
    {
        if (this.current == null) {
            throw new bdd.exception.Exception('Tracker does not has a current describe');
        }

        Reflect.callMethod(this.current, Reflect.field(this.current, methodName), [ param ]);
    }

    public function addAfterEach(method:Void->Void):Void
    {
        this.callOnCurrent('addAfterEach', method);
    }

    public function addRunnable(runnable:IRunnable):Void
    {
        this.callOnCurrent('addRunnable', runnable);
    }

    public function createAsyncBlock(block:Dynamic->Void, ?timeout:Int):Dynamic->Void
    {
        return this.currentIt.createAsyncBlock(block, timeout);
    }
}
