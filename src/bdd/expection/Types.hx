package bdd.expection;

import haxe.PosInfos;

class Types extends Abstract
{
    public function new()
    {
        super();

        this.failureText.set('instanceOf', 'Expected %expected% does not instance of %actual%');
        this.failureText.set('not_instanceOf', 'Not expected to be an instance of %expected%');

        this.failureText.set('string', 'Expected to be string got: %actual%');
        this.failureText.set('not_string', 'Not expected to be string');

        this.failureText.set('number', 'Expected to be number got: %actual%');
        this.failureText.set('not_number', 'Not expected to be number');

        this.failureText.set('bool', 'Expected to be bool got: %actual%');
        this.failureText.set('not_bool', 'Not expected to be bool');

        this.failureText.set('object', 'Expected to be object');
        this.failureText.set('not_object', 'Not expected to be object');

        this.failureText.set('function', 'Expected to be function got: %actual%');
        this.failureText.set('not_function', 'Not expected to be function');

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

    public function string(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.checkType(Std.is(actual, String), 'string', actual, pos);
    }

    private function checkType(same:Bool,failText:String, actual:Dynamic, pos:PosInfos):Void
    {
        if (this.condition(same)) {
            return this.succeed(pos);
        }

        var actualType = Type.getClassName(Type.getClass(actual));

        this.failed(this.getFailureText(failText, '', actualType), pos);
    }

    public function number(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.checkType(Std.is(actual, Float),'number', actual, pos);
    }

    public function bool(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.checkType(Std.is(actual, Bool), 'bool', actual, pos);
    }

    public function object(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.checkType(Reflect.isObject(actual), 'object', actual, pos);
    }

    public function Function(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.checkType(Reflect.isFunction(actual), 'function', actual, pos);
    }

    public function Enum(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.checkType(Reflect.isEnumValue(actual), 'enum', actual, pos);
    }
}
