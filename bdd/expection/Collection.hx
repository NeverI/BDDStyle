package bdd.expection;

import haxe.PosInfos;

class Collection extends Abstract
{
    public function new(reporter:ItReporter, isNegated:Bool = false)
    {
        super(reporter, isNegated);

        this.failureText.set('empty', 'Expected not be empty got %actual%');
        this.failureText.set('not_empty', 'Not expected to be empty');

        this.failureText.set('length', 'Expected length %expected% not match with %actual%');
        this.failureText.set('not_length', 'Not expected the length to be the same: %actual%');

        this.failureText.set('first', 'Expected first %expected% element not match with %actual%');
        this.failureText.set('not_first', 'Not expected the first element to be the same: %actual%');

        this.failureText.set('nth', 'Expected nth %expected% element not match with %actual%');
        this.failureText.set('not_nth', 'Not expected the nth element to be the same: %actual%');

        this.failureText.set('last', 'Expected last %expected% element not match with %actual%');
        this.failureText.set('not_last', 'Not expected the last element to be the same: %actual%');

        this.failureText.set('contains', 'Expected contains %expected% element in %actual%');
        this.failureText.set('not_contains', 'Not expected to contains the %expected% in %actual%');
    }

    public function empty(actual:Dynamic, ?pos:PosInfos):Void
    {
        this.expectLength(0, actual, 'empty', pos);
    }

    private function expectLength(expected:Int, actual:Dynamic, failText:String, ?pos:PosInfos):Void
    {
        if (!Reflect.hasField(actual, 'length')) {
            this.failed('Object does not has length: ' + Std.string(actual), pos);
        }

        var length:Int = this.getLength(actual);
        if (this.condition(length == expected)) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText(failText, Std.string(expected), Std.string(length)), pos);
    }

    private function getLength(actual:Dynamic):Int
    {
        return Reflect.isFunction(actual.length) ? Reflect.callMethod(actual, Reflect.field(actual, 'length'), []) : actual.length;
    }

    public function length(expected:Int, actual:Dynamic, ?pos:PosInfos):Void
    {
        this.expectLength(expected, actual, 'length', pos);
    }

    public function first(expected:Dynamic, actual:Dynamic, ?pos:PosInfos):Void
    {
        this.expectXElement(0, expected, actual, 'first', pos);
    }

    private function expectXElement(index:Int, expected:Dynamic, actual:Dynamic, failText:String, ?pos:PosInfos):Void
    {
        var iterator:Iterator<Dynamic> = this.getIterable(actual);
        if (iterator == null) {
            return this.failed('Object is not iterable: ' + Std.string(actual), pos);
        }

        var elem:Dynamic = this.tryToGetElementFromIterator(iterator, index);

        if (this.condition(elem == expected)) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText(failText, Std.string(expected), Std.string(elem)), pos);
    }

    private function getIterable(actual:Dynamic):Dynamic
    {
        if (actual == null) {
            return null;
        }

        try {
            if (Reflect.isFunction(actual.iterator)) {
                return actual.iterator();
            }
        } catch(e:Dynamic) {
        }
        try {
            if (Reflect.isFunction(actual.hasNext) && Reflect.isFunction(actual.next))  {
                return actual;
            }
        } catch(e:Dynamic) {
        }

        return null;
    }

    private function tryToGetElementFromIterator(iterator:Iterator<Dynamic>, index:Int = -1):Dynamic
    {
        var counter:Int = 0;
        var v:Dynamic = null;

        while(iterator.hasNext()) {
            if (counter == index) {
                return iterator.next();
            } else {
                v = iterator.next();
            }
            counter++;
        }

        return v;
    }

    public function nth(index:Int, expected:Dynamic, actual:Dynamic, ?pos:PosInfos):Void
    {
        this.expectXElement(index, expected, actual, 'nth', pos);
    }

    public function last(expected:Dynamic, actual:Dynamic, ?pos:PosInfos):Void
    {
        this.expectXElement(-1, expected, actual, 'last', pos);
    }

    public function contains(expected:Dynamic, actual:Dynamic, ?pos:PosInfos):Void
    {
        var iterator:Iterator<Dynamic> = this.getIterable(actual);
        if (iterator == null) {
            return this.failed('Object is not iterable: ' + Std.string(actual), pos);
        }

        var found:Bool = false;
        while(iterator.hasNext()) {
            if (iterator.next() == expected) {
                found = true;
                break;
            }
        }

        if (this.condition(found)) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('contains', Std.string(expected), Std.string(actual)), pos);
    }
}
