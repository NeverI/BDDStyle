package bdd.expection;

import haxe.PosInfos;
import bdd.expection.Result;

class Abstract
{
    private var reporter:ItReporter;

    public function new()
    {
    }

    public function setReporter(reporter:ItReporter):Void
    {
        this.reporter = reporter;
    }

    private function reportSucceed(?pos:PosInfos)
    {
        this.reporter.report(Result.Success(pos));
    }

    private function reportFailed(msg:String, ?pos:PosInfos)
    {
        this.reporter.report(Result.Failure(msg, pos));
    }

    private function reportError(e:bdd.exception.Expect)
    {
        this.reporter.report(Result.Error(e));
    }

    private function reportWarrning(msg:String)
    {
        this.reporter.report(Result.Warning(msg));
    }
}
