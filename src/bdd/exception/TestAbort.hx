package bdd.exception;

class TestAbort
{
    private var message:String;

    public function new(msg:String)
    {
        this.message = msg;
    }

    public function toString():String
    {
        return this.message;
    }
}
