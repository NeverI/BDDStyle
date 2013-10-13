package bdd.expection;

import haxe.PosInfos;

class Should extends Abstract
{
    public function success(?pos:PosInfos):Void
    {
        this.succeed(pos);
    }

    public function fail(msg:String = 'Fail anyway', ?pos:PosInfos):Void
    {
        this.failed(msg, pos);
    }
}
