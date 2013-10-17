package bdd.expection;

import haxe.PosInfos;

class TypeChecker extends Abstract
{
    private function checkType(same:Bool,failText:String, actual:Dynamic, pos:PosInfos):Void
    {
        if (this.condition(same)) {
            return this.succeed(pos);
        }

        var actualType = Type.getClassName(Type.getClass(actual));

        this.failed(this.getFailureText(failText, '', actualType), pos);
    }
}
