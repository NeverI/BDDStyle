package bdd;

class ExampleGroupRunner extends bdd.event.EventDispatcher
{
    private var group:ExampleGroup;
    private var runnableMethods:Array<String>;
    private var describeTracker:DescribeTracker;

    private var currentMethodIndex:Int;
    private var rootDesribe:Describe;

    public function new()
    {
        super();
        this.describeTracker = new DescribeTracker();
        ExampleGroup.describeTracker = this.describeTracker;

        this.addListener('describe.done', this.runNextMethodIfNeed);
    }

    private function runNextMethodIfNeed(event:Describe):Void
    {
        if (event != this.rootDesribe) {
            return;
        }

        this.runNextMethod();
    }

    private function runNextMethod():Void
    {
        if (!this.hasNext()) {
            this.trigger('group.done', this.group);
            return;
        }

        this.rootDesribe = new Describe(Type.getClassName(Type.getClass(this.group)), function(){
            Reflect.callMethod(this.group, this.getNextMethod(), []);
        });

        this.describeTracker.start(this.rootDesribe);
        this.rootDesribe.addBeforeEach(this.group.beforeEach);
        this.rootDesribe.addAfterEach(this.group.afterEach);
        this.rootDesribe.run();
    }

    private function hasNext():Bool
    {
        return this.currentMethodIndex < this.runnableMethods.length;
    }

    private function getNextMethod():Void->Void
    {
        return Reflect.field(this.group, this.runnableMethods[this.currentMethodIndex++]);
    }

    public function run(group:ExampleGroup):Void
    {
        this.group = group;
        this.currentMethodIndex = 0;
        this.runnableMethods = Type.getInstanceFields(Type.getClass(group)).filter(this.isRunnable);
        this.runnableMethods.sort(this.sortMethodNames);

        this.trigger('group.start', this.group);
        this.runNextMethod();
    }

    private function isRunnable(name:String):Bool
    {
        return name.indexOf('example') == 0;
    }

    private function sortMethodNames(a:String, b:String):Int
    {
        return a < b ? -1 : 1;
    }
}
