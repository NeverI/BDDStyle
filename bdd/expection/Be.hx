package bdd.expection;

import haxe.PosInfos;

class Be extends Abstract
{
    public function new(reporter:ItReporter, isNegated:Bool = false)
    {
        super(reporter, isNegated);

        this.failureText.set('true', 'Expected to be true');
        this.failureText.set('not_true', 'Not expected to be true');

        this.failureText.set('false', 'Expected to be false');
        this.failureText.set('not_false', 'Not expected to be false');
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
}
