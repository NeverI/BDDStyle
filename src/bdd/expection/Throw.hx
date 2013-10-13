package bdd.expection;

import haxe.PosInfos;

class Throw extends Abstract
{
    public function throws(method: Void->Void, ?expected:Dynamic, ?pos:PosInfos):Void
    {
        try {
            method();
        } catch (e:Dynamic) {
            return this.verify(e, expected);
        }

        this.reportFailed('Expected exception not throwed');
    }

    private function verify(actual:Dynamic, ?expected:Dynamic):Void
    {
        if (expected == null) {
            return this.reportSucceed();
        }

        if (Std.is(expected, String)) {
            return this.verifyString(actual, expected);
        }

        this.verifyType(actual, expected);
    }

    private function verifyString(actual:String, expected:String):Void
    {
        if (this.stringSame(actual, expected)) {
            return this.reportSucceed();
        }

        this.reportFailed('Expected exception ' + expected + ' but got ' + actual);
    }

    private function stringSame(actual:String, expected:String):Bool
    {
        return new EReg(expected, '').match(actual);
    }

    private function verifyType(actual:Dynamic, expected:Dynamic):Void
    {
        if (Std.is(actual, expected)) {
            return this.reportSucceed();
        }

        var actualType = Type.getClassName(Type.getClass(actual));
        var expectedType = Type.getClassName(expected);

        this.reportFailed('Expected exception type is ' + expectedType + ' but got ' + actualType);
    }

    public function notThrows(method: Void->Void, ?expected:Dynamic, ?pos:PosInfos):Void
    {
        try {
            method();
        } catch (e:Dynamic) {
            return this.notVerification(e, expected);
        }

        this.reportSucceed();
    }

    private function notVerification(actual:Dynamic, expected:Dynamic):Void
    {
        if (expected == null) {
            return this.reportFailed('Not expected an exception throwed');
        }

        if (Std.is(expected, String)) {
            return this.notVerificationString(actual, expected);
        }

        this.notVerificationType(actual, expected);
    }

    private function notVerificationString(actual:String, expected:String):Void
    {
        if (!this.stringSame(actual, expected)) {
            this.reportSucceed();
        }

        return this.reportFailed('Not expected to throw the same string: ' + actual);
    }

    private function notVerificationType(actual:Dynamic, expected:Dynamic):Void
    {
        if (!Std.is(actual, expected)) {
            return this.reportSucceed();
        }

        this.reportFailed('Not Expected to throw the same type: ' + Type.getClassName(expected));
    }
}
