package bdd.expection;

import haxe.PosInfos;

class Object extends Abstract
{
    public function new()
    {
        super();

        this.failureText.set('property', 'Expected object have a property %expected%');
        this.failureText.set('not_property', 'Not expected object have property %expected%');
    }

    public function property(expected:String, actual:Dynamic, ?pos:PosInfos):Void
    {
        if (this.condition(Reflect.hasField(actual, expected))) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('property', expected, ''), pos);
    }

    public function properties(expected:Array<String>, actual:Dynamic, ?pos:PosInfos):Void
    {
        for (prop in expected) {
            this.property(prop, actual, pos);
        }
    }
}
