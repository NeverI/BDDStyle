package bdd.expection;

import haxe.unit.TestCase in HaxeTestCase;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class TestCase extends HaxeTestCase
{
    private var reporter:ItReporter;

    override public function setup():Void
    {
        this.reporter = mock(ItReporter);
    }

    private function reporterCalledWithFailure(msg:String):Void
    {
        this.reporter.report(Result.Failure(msg, null)).verify();
        this.assertTrue(true);
    }

    private function reporterCalledWithSuccess():Void
    {
        this.reporter.report(Result.Success(null)).verify();
        this.assertTrue(true);
    }
}
