package bdd.expection;

import haxe.PosInfos;
import bdd.expection.Result;

class Abstract
{
    private var reporter:ItReporter;
    private var isNegated:Bool;
    private var failureText:Map<String,String>;

    public function new()
    {
        this.isNegated = false;
        this.failureText = new Map();
    }

    public function setReporter(reporter:ItReporter):Void
    {
        this.reporter = reporter;
    }

    public function setIsNegated(value:Bool):Void
    {
        this.isNegated = value;
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

    private function condition(condition:Bool):Bool
    {
        if ((!this.isNegated && condition) || (this.isNegated && !condition)) {
            return true;
        }

        return false;
    }

    private function getFailureText(type:String, expected:String='', actual:String=''):String
    {
        type = this.isNegated ? 'not_' + type : type;

        if (!this.failureText.exists(type)) {
            return 'Expected: ' + expected + ' does not match with actual: ' + actual;
        }

        var text:String = this.failureText.get(type);
        var expectedRegexp = ~/%expected%/;
        var actualRegexp = ~/%actual%/;

        text = expectedRegexp.replace(text, expected);
        text = actualRegexp.replace(text, actual);

        return text;
    }
}
