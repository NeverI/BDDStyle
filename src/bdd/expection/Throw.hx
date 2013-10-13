package bdd.expection;

import haxe.PosInfos;

class Throw extends Abstract
{
    public function throws(method: Void->Void, ?expect:Dynamic, ?pos:PosInfos):Void
    {
        try {
            method();
        } catch (e:Dynamic) {
            this.verify(e, expect);
            return;
        }

        this.reportFailed('Expected exception not throwed');
    }

    private function verify(actual:Dynamic, ?expect:Dynamic):Void
    {
        if (expect == null) {
            this.reportSucceed();
        } else if (Std.is(expect, String)) {
            this.verifyString(actual, expect);
        } else {
            this.verifyType(actual, expect);
        }
    }

    private function verifyString(actual:String, expected:String):Void
    {
        if (new EReg(expected, '').match(actual)) {
            this.reportSucceed();
            return;
        }

        this.reportFailed('Expected exception ' + expected + ' but got ' + actual);
    }

    private function verifyType(actual:Dynamic, expected:Dynamic):Void
    {
        if (Std.is(actual, expected)) {
            this.reportSucceed();
        } else {
            var actualType = Type.getClassName(Type.getClass(actual));
            var expectedType = Type.getClassName(expected);

            this.reportFailed('Expected exception type is ' + expectedType + ' but got ' + actualType);
        }
    }

}
