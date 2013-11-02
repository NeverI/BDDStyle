package bdd;

class Describe extends bdd.event.EventDispatcher implements IRunnable
{
    public var overview(default, null):String;

    private var currentRunnableIndex:Int;
    private var runnables:Array<IRunnable>;

    private var method:Void->Void;

    private var beforeEaches:Array<Void->Void>;
    private var afterEaches:Array<Void->Void>;

    public var isPending:Bool;

    public function new(overview:String, ?method:Void->Void)
    {
        super();

        this.overview = overview;
        this.method = method;

        this.beforeEaches = [];
        this.afterEaches = [];
        this.runnables = [];

        this.currentRunnableIndex = 0;

        this.isPending = false;
    }

    public function addBeforeEach(method:Void->Void):Void
    {
        this.startListenToItStart();
        this.beforeEaches.push(method);
    }

    private function startListenToItStart():Void
    {
        if (this.beforeEaches.length == 0) {
            this.addListener('it.start', this.runBeforeEach);
        }
    }

    private function runBeforeEach(it:It):Void
    {
        for (method in this.beforeEaches) {
            method();
        }
    }

    public function addAfterEach(method:Void->Void):Void
    {
        this.startListenToItDone();
        this.afterEaches.push(method);
    }

    private function startListenToItDone():Void
    {
        if (this.afterEaches.length == 0) {
            this.unshiftListener('it.done', this.runAfterEach);
        }
    }

    private function runAfterEach(it:It):Void
    {
        for (method in this.afterEaches) {
            method();
        }
    }

    public function addRunnable(runnable:IRunnable):Void
    {
        this.clearMethodFromItIfSelfIsPending(runnable);
        this.runnables.push(runnable);
    }

    private function clearMethodFromItIfSelfIsPending(runnable:IRunnable):Void
    {
        if (this.isPending && Std.is(runnable, It)) {
            cast(runnable, It).clearMethod();
        }
    }

    public function run():Void
    {
        this.trigger('describe.start', this);

        if (this.method == null) {
            this.done();
            return;
        }
        this.method();

        this.addListener('it.done', this.runNext);
        this.addListener('describe.done', this.runNext);

        this.runNext();
    }

    private function done():Void
    {
        this.clearListeners();
        this.trigger('describe.done', this);
    }

    private function clearListeners():Void
    {
        this.removeListener('it.start', this.runBeforeEach);
        this.removeListener('it.done', this.runAfterEach);
        this.removeListener('it.done', this.runNext);
        this.removeListener('describe.done', this.runNext);
    }

    private function runNext(?runnable:Dynamic):Void
    {
        if (runnable != null && !this.isItOwn(runnable)) {
            return;
        }

        if (!this.hasNext()) {
            this.done();
            return;
        }

        this.runnables[this.currentRunnableIndex++].run();
    }

    private function isItOwn(runnable:IRunnable):Bool
    {
        for (r in this.runnables) {
            if (r == runnable) {
                return true;
            }
        }

        return false;
    }

    private function hasNext():Bool
    {
        return this.currentRunnableIndex < this.runnables.length;
    }

}
