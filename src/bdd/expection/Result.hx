package bdd.expection;

import haxe.PosInfos;
import bdd.exception.Expect;

enum Result {
    Success(pos : PosInfos);
    Failure(msg : String, ?pos : PosInfos);
    Error  (e : Expect);
    Warning(msg : String);
}
