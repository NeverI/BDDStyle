package bdd.expection;

import haxe.PosInfos;

class Equal extends Abstract
{
    public function new(reporter:ItReporter, isNegated:Bool = false)
    {
        super(reporter, isNegated);

        this.failureText.set('equal', 'Expected %expected% to be %actual%');
        this.failureText.set('not_equal', 'Not expected to be an equal: %actual%');
    }

    public function equal(expected:Dynamic, actual:Dynamic, ?pos:PosInfos):Void
    {
        if (Reflect.isFunction(expected) && this.functionsAreEqual(expected, actual)) {
            return this.succeed(pos);
        }

        if (this.isEnum(expected) && this.enumsAreEqual(expected, actual)) {
            return this.succeed(pos);
        }

        if (this.condition(expected == actual)) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('equal', Std.string(expected), Std.string(actual)), pos);
    }

    private function functionsAreEqual(expected:Dynamic, actual:Dynamic):Bool
    {
        return  this.condition(Reflect.compareMethods(expected, actual));
    }

    private function isEnum(expected:Dynamic):Bool
    {
        return switch(Type.typeof(expected))
        {
            case TEnum(_): true;
            case _: false;
        }
    }

    private function enumsAreEqual(expected:Dynamic, actual:Dynamic):Bool
    {
        return  this.condition(Type.enumEq(expected, actual));
    }
}
