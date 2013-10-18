package bdd.expection;

import haxe.PosInfos;

class Number extends Abstract
{
    public function new(reporter:ItReporter, isNegated:Bool = false)
    {
        super(reporter, isNegated);

        this.failureText.set('below', 'Expected %expected% does not lower then %actual%');
        this.failureText.set('not_below', 'Not expected to %actual% is greater then %expected%');

        this.failureText.set('above', 'Expected %expected% does not greater then %actual%');
        this.failureText.set('not_above', 'Not expected to %actual% is lower then %expected%');

        this.failureText.set('whitin', 'Expected %actual% in range %expected%');
        this.failureText.set('not_whitin', 'Not expected to %actual% in range %expected%');

        this.failureText.set('floatEqual', 'Expected %expected% is not equal with %actual%');
        this.failureText.set('not_floatEqual', 'Not expected to %expected% is equal with %actual%');

        this.failureText.set('NaN', 'Expected %actual% to be NaN');
        this.failureText.set('not_NaN', 'Not expected %actual% to be NaN');

        this.failureText.set('finite', 'Expected %actual% to be finite');
        this.failureText.set('not_finite', 'Not expected %actual% to be finite');
    }

    public function below(expected:Float, actual:Float, ?pos:PosInfos):Void
    {
        if (this.condition(expected < actual)) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('below', Std.string(expected), Std.string(actual)), pos);
    }

    public function above(expected:Float, actual:Float, ?pos:PosInfos):Void
    {
        if (this.condition(expected > actual)) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('above', Std.string(expected), Std.string(actual)), pos);
    }

    public function whitin(above:Float, actual:Float, below:Float, ?pos:PosInfos):Void
    {
        if (this.condition(actual > above && actual < below)) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('whitin', Std.string(above)+' - '+Std.string(below), Std.string(actual)), pos);
    }

    public function floatEqual(expected:Float, actual:Float, margin:Float = 0.00001, ?pos:PosInfos):Void
    {
        if (this.condition(this.isFloatEqual(expected, actual, margin))) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('floatEqual', Std.string(expected), Std.string(actual)), pos);
    }

    private function isFloatEqual(expected:Float, actual:Float, margin:Float):Bool
    {
        return expected - margin < actual && actual < expected + margin;
    }

    public function NaN(actual:Dynamic, ?pos:PosInfos):Void
    {
        var value:Float = Std.is(actual, String) ? Std.parseFloat(actual) : actual;

        if (this.condition(Math.isNaN(value))) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('NaN', '', Std.string(actual)), pos);
    }

    public function finite(actual:Dynamic, ?pos:PosInfos):Void
    {
        var value:Float = Std.is(actual, String) ? Std.parseFloat(actual) : actual;

        if (this.condition(Math.isFinite(value))) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('finite', '', Std.string(actual)), pos);
    }
}
