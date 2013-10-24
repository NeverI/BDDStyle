package bdd.expection;

import haxe.PosInfos;

class An extends TypeChecker
{
    public function new(reporter:ItReporter, isNegated:Bool = false)
    {
        super(reporter, isNegated);

        this.failureText.set('instanceOf', 'Expected %expected% does not instance of %actual%');
        this.failureText.set('not_instanceOf', 'Not expected to be an instance of %expected%');

        this.failureText.set('object', 'Expected to be object');
        this.failureText.set('not_object', 'Not expected to be object');

        this.failureText.set('enum', 'Expected to be enum got: %actual%');
        this.failureText.set('not_enum', 'Not expected to be enum');
    }

    public function instanceOf(expected:Dynamic, actual:Dynamic, ?pos:PosInfos):Void
    {
        if (this.condition(Std.is(actual, expected))) {
            return this.succeed(pos);
        }

        var actualType = Type.getClassName(Type.getClass(actual));
        var expectedType = Type.getClassName(expected);

        this.failed(this.getFailureText('instanceOf', expectedType, actualType), pos);
    }

    public function object(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.checkType(Reflect.isObject(actual), 'object', actual, pos);
    }

    public function Enum(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.checkType(Reflect.isEnumValue(actual), 'enum', actual, pos);
    }
}
