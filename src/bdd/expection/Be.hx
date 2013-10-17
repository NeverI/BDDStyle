package bdd.expection;

import haxe.PosInfos;

class Be extends Abstract
{
    public function new()
    {
        super();

        this.failureText.set('true', 'Expected to be true');
        this.failureText.set('not_true', 'Not expected to be true');

        this.failureText.set('false', 'Expected to be false');
        this.failureText.set('not_false', 'Not expected to be false');

        this.failureText.set('equal', 'Expected %expected% to be %actual%');
        this.failureText.set('not_equal', 'Not expected to be an equal: %actual%');
    }

    public function True(actual:Bool, ?pos:PosInfos):Void
    {
        if (this.condition(actual)) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('true', '', ''), pos);
    }

    public function False(actual:Bool, ?pos:PosInfos):Void
    {
        if (this.condition(!actual)) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('false', '', ''), pos);
    }

    public function equal(expected:Dynamic, actual:Dynamic, ?pos:PosInfos):Void
    {
        if (this.condition(expected == actual)) {
            return this.succeed(pos);
        }

        this.failed(this.getFailureText('equal', Std.string(expected), Std.string(actual)), pos);
    }
}
