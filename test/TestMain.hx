package ;

import haxe.unit.TestRunner;

import bdd.exception.ExceptionTest;
import bdd.expection.*;
import bdd.event.*;
import bdd.*;

class TestMain
{
    static function main(){ new TestMain(); }

    public function new()
    {
        var runner = new TestRunner();

        runner.add(new ExceptionTest());
        runner.add(new ShouldTest());
        runner.add(new ThrowTest());
        runner.add(new StringsTest());
        runner.add(new NumberTest());
        runner.add(new CollectionTest());
        runner.add(new ATest());
        runner.add(new AnTest());
        runner.add(new BeTest());
        runner.add(new EqualTest());
        runner.add(new ObjectTest());
        runner.add(new CompositeShouldTest());
        runner.add(new EventDispatcherTest());
        runner.add(new ItTest());
        runner.add(new DescribeTest());
        runner.add(new DescribeTrackerTest());

        runner.run();
    }
}
