package bdd;

class Runner extends bdd.event.EventDispatcher
{
    private var groupFactory:ExampleGroupFactory;
    private var groupRunner:ExampleGroupRunner;
    private var groups:Array<ExampleGroup>;

    private var currentGroupIndex:Int;

    public function new()
    {
        super();

        this.groupFactory = new ExampleGroupFactory();
        this.groupRunner = new ExampleGroupRunner();
        this.groups = [];

        this.addListener('group.done', this.runNextGroup);
    }

    private function runNextGroup(?group:ExampleGroup):Void
    {
        if (!this.hasNext()) {
            this.trigger('runner.done',{});
            return;
        }

        this.groupRunner.run(this.getNextGroup());
    }

    private function hasNext():Bool
    {
        return this.currentGroupIndex < this.groups.length;
    }

    private function getNextGroup():ExampleGroup
    {
        return this.groups[this.currentGroupIndex++];
    }

    public function add(cls:Class<ExampleGroup>):Void
    {
        this.groups.push(this.groupFactory.create(cls));
    }

    public function run():Void
    {
        this.currentGroupIndex = 0;
        this.trigger('runner.start',{});
        this.runNextGroup();
    }
}
