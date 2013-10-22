package bdd.expection;

import haxe.PosInfos;

class TypeChecker extends Abstract
{
    private function checkType(same:Bool,failText:String, actual:Dynamic, pos:PosInfos):Void
    {
        if (this.condition(same)) {
            return this.succeed(pos);
        }

        var actualType = actual;
        try {
            actualType = actual == null ? 'null' : Type.getClassName(Type.getClass(actual));
        } catch(e:Dynamic) {
        }

        this.failed(this.getFailureText(failText, '', actualType), pos);
    }
}
