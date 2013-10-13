package bdd.expection;

import haxe.PosInfos;

class Strings extends Abstract
{
    public function new()
    {
        super();

        this.failureText.set('match', 'Expected %expected% not match with %actual%');
        this.failureText.set('not_match', 'Not expected to match: %actual%');

        this.failureText.set('startWith', 'Expected to %actual% started with %expected%');
        this.failureText.set('not_startWith', 'Not expected to %actual% started with %expected%');

        this.failureText.set('endWith', 'Expected to %actual% ended with %expected%');
        this.failureText.set('not_endWith', 'Not expected to %actual% ended with %expected%');
    }

    public function match(expected:String, actual:String, ?pos:PosInfos):Void
    {
        if (this.condition(new EReg(expected, '').match(actual))) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('match', expected, actual), pos);
    }

    public function startWith(expected:String, actual:String, ?pos:PosInfos):Void
    {
        if (this.condition(actual.indexOf(expected) == 0)) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('startWith', expected, actual), pos);
    }

    public function endWith(expected:String, actual:String, ?pos:PosInfos):Void
    {
        if (this.condition(this.isEndedWidth(expected, actual))) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('endWith', expected, actual), pos);
    }

    private function isEndedWidth(expected:String, actual:String):Bool
    {
        return actual.lastIndexOf(expected) == actual.length - expected.length;
    }
}
