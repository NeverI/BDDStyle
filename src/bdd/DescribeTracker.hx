package bdd;

import bdd.event.EventDispatcher;

class DescribeTracker extends EventDispatcher
{
    private var current:Describe;

    public function new()
    {
        super();

        this.addListener('describe.start', this.updateCurrent);
    }

    public function start(describe:Describe):Void
    {
        this.current = describe;
    }

    public var isPending(get, null):Bool;
    private function get_isPending():Bool
    {
        return this.current == null ? true : this.current.isPending;
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

    private function updateCurrent(describe:Describe):Void
    {
        this.current = describe;
    }
}
