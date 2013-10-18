package bdd.expection;

import haxe.PosInfos;

class A extends TypeChecker
{
    public function new(reporter:ItReporter, isNegated:Bool = false)
    {
        super(reporter, isNegated);

        this.failureText.set('string', 'Expected to be string got: %actual%');
        this.failureText.set('not_string', 'Not expected to be string');

        this.failureText.set('number', 'Expected to be number got: %actual%');
        this.failureText.set('not_number', 'Not expected to be number');

        this.failureText.set('bool', 'Expected to be bool got: %actual%');
        this.failureText.set('not_bool', 'Not expected to be bool');

        this.failureText.set('function', 'Expected to be function got: %actual%');
        this.failureText.set('not_function', 'Not expected to be function');
    }

    public function string(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.checkType(Std.is(actual, String), 'string', actual, pos);
    }

    public function number(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.checkType(Std.is(actual, Float),'number', actual, pos);
    }

    public function bool(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.checkType(Std.is(actual, Bool), 'bool', actual, pos);
    }

    public function Function(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.checkType(Reflect.isFunction(actual), 'function', actual, pos);
    }
}
