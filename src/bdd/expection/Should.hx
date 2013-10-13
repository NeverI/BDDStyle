package bdd.expection;

import haxe.PosInfos;

class Should extends Abstract
{
    public function succeed(?pos:PosInfos):Void
    {
        this.reportSucceed(pos);
    }

    public function fail(msg:String = 'Fail anyway', ?pos:PosInfos):Void
    {
        this.reportFailed(msg);
    }
}
