package src.bdd.expection;

import haxe.unit.TestCase in HaxeTestCase;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

import bdd.expection.ItReporter;
import bdd.expection.Result;

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
