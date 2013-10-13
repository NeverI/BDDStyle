package bdd.exception;

import haxe.CallStack;

class Exception
{
    private var message:String;
    private var stack:Array<StackItem>;

    public function new(msg:String)
    {
        this.message = msg;
        this.stack = CallStack.callStack().slice(3);
    }

    public function toString():String
    {
        return 'message: ' + this.getMessage() + this.getStack();
    }

    public function getMessage():String
    {
        return this.message;
    }

    public function getStack()
    {
        return CallStack.toString(this.stack);
    }

}
