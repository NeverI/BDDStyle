package bdd.expection;

import haxe.PosInfos;

class Should extends Abstract
{
    public function success(?pos:PosInfos):Void
    {
        if (this.isNegated) {
            this.failed('Not expected to succeed', pos);
        } else {
            this.succeed(pos);
        }
    }

    public function fail(msg:String = 'Fail anyway', ?pos:PosInfos):Void
    {
        if (this.isNegated) {
            this.succeed(pos);
        } else {
            this.failed(msg, pos);
        }
    }
}
