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
            return this.verify(exception, expected, pos);

        } else if (this.isNegated) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('throw'), pos);
    }

    private function verify(actual:Dynamic, ?expected:Dynamic, pos:PosInfos):Void
    {
        if (expected == null) {
            return this.verifyNullType(pos);
        }

        if (Std.is(expected, String)) {
            return this.verifyString(actual, expected, pos);
        }

        this.verifyType(actual, expected, pos);
    }

    private function verifyNullType(pos:PosInfos):Void
    {
        if (!this.isNegated) {
            return this.succeed(pos);
        }

        if (this.isNegated) {
            return this.failed(this.getFailureText('throw'), pos);
        }
    }

    private function verifyString(actual:String, expected:String, pos:PosInfos):Void
    {
        if (this.condition(this.stringSame(actual, expected))) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('string', expected, actual), pos);
    }

    private function stringSame(actual:String, expected:String):Bool
    {
        return new EReg(expected, '').match(actual);
    }

    private function verifyType(actual:Dynamic, expected:Dynamic, pos:PosInfos):Void
    {
        if (this.condition(Std.is(actual, expected))) {
            return this.succeed(pos);
        }

        var actualType = Type.getClassName(Type.getClass(actual));
        var expectedType = Type.getClassName(expected);

        this.failed(this.getFailureText('type', expectedType, actualType), pos);
    }
}
