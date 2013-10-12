package ;

import haxe.unit.TestRunner;
import src.bdd.ShouldTest;

class TestMain
{
    static function main(){ new TestMain(); }

    public function new()
    {
         var runner = new TestRunner();

        runner.add(new ShouldTest());

        runner.run();
    }
}
