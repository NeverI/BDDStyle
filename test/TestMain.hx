package ;

import haxe.unit.TestRunner;

import src.bdd.exception.ExceptionTest;
import src.bdd.expection.*;

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

        runner.run();
    }
}
