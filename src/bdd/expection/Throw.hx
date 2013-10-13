package bdd.expection;

import haxe.PosInfos;

class Throw extends Abstract
{
    public function new()
    {
        super();

        this.failureText.set('throw', 'Expected exception not throwed');
        this.failureText.set('not_throw', 'Not expected an exception throwed');

        this.failureText.set('string', 'Expected exception %expected% but got %actual%');
        this.failureText.set('not_string', 'Not expected to throw the same string: %actual%');

        this.failureText.set('type', 'Expected exception type is %expected% but got %actual%');
        this.failureText.set('not_type', 'Not expected to throw the same type: %actual%');
    }

    public function throws(method: Void->Void, ?expected:Dynamic, ?pos:PosInfos):Void
    {
        var throwed:Bool = false;
        var exception:Dynamic = null;

        try {
            method();
        } catch (e:Dynamic) {
            throwed = true;
            exception = e;
        }

        if (throwed) {
            return this.verify(exception, expected);

        } else if (this.isNegated) {
            return this.reportSucceed();
        }

        this.reportFailed(this.getFailureText('throw'));
    }

    private function verify(actual:Dynamic, ?expected:Dynamic):Void
    {
        if (expected == null) {
            return this.verifyNullType();
        }

        if (Std.is(expected, String)) {
            return this.verifyString(actual, expected);
        }

        this.verifyType(actual, expected);
    }

    private function verifyNullType():Void
    {
        if (!this.isNegated) {
            return this.reportSucceed();
        }

        if (this.isNegated) {
            return this.reportFailed(this.getFailureText('throw'));
        }
    }

    private function verifyString(actual:String, expected:String):Void
    {
        if (this.condition(this.stringSame(actual, expected))) {
            return this.reportSucceed();
        }

        this.reportFailed(this.getFailureText('string', expected, actual));
    }

    private function stringSame(actual:String, expected:String):Bool
    {
        return new EReg(expected, '').match(actual);
    }

    private function verifyType(actual:Dynamic, expected:Dynamic):Void
    {
        if (this.condition(Std.is(actual, expected))) {
            return this.reportSucceed();
        }

        var actualType = Type.getClassName(Type.getClass(actual));
        var expectedType = Type.getClassName(expected);

        this.reportFailed(this.getFailureText('type', expectedType, actualType));
    }
}
