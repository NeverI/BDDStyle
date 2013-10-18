package bdd.expection;

import haxe.PosInfos;
import bdd.expection.Result;

class Abstract
{
    private var reporter:ItReporter;
    private var isNegated:Bool;
    private var failureText:Map<String,String>;

    public function new(reporter:ItReporter, isNegated:Bool = false)
    {
        this.reporter = reporter;
        this.isNegated = isNegated;

        this.failureText = new Map();
    }

    private function succeed(?pos:PosInfos)
    {
        this.reporter.report(Result.Success(pos));
    }

    private function failed(msg:String, ?pos:PosInfos)
    {
        this.reporter.report(Result.Failure(msg, pos));
    }

    private function error(e:bdd.exception.Expect)
    {
        this.reporter.report(Result.Error(e));
    }

    private function warrning(msg:String)
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
