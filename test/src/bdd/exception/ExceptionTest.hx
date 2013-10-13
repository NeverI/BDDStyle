package src.bdd.exception;

import haxe.unit.TestCase;
import bdd.exception.Exception;

class ExceptionTest extends TestCase
{
    private var exception:Exception;

    public function testShouldStoreTheMessage():Void
    {
        var message:String = 'this is the message';
        this.exception = new Exception(message);

        this.assertTrue(this.exception.getMessage() == message);
    }

    public function testShouldStoreTheCallStack():Void
    {
        this.exception = new Exception('alma');

        var stack:String = this.exception.getStack();
        this.assertTrue(stack.length >= 0);
        this.assertTrue(stack.indexOf('\nCalled from src/bdd/exception/ExceptionTest.hx') == 0);
    }

    public function testCanBeThrowed():Void
    {
        try {
            throw new Exception('alma');

        } catch(e:Exception) {
            this.assertTrue(e.getMessage() == 'alma');
        }
    }
}
