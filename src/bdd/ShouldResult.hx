package bdd;

import haxe.PosInfos;

enum ShouldResult {
    Success(pos : PosInfos);
    Failure(msg : String, ?pos : PosInfos);
    Error  (e : Dynamic);
    Warning(msg : String);
}
