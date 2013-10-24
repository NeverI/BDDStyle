package bdd;

import haxe.unit.TestCase;
import bdd.expection.Result;
import bdd.event.EventDispatcher;

class ItTest extends TestCase
{
    private var target:It;

    public function testConstruct_should_setTheOverviewOfTheIt()
    {
        this.target = new It('foo desc');
        EventDispatcher.removeAllListener();
        this.assertEquals('foo desc', this.target.overview);
    }

    public function testConstruct_should_setTheTestMethodOfTheIt()
    {
        var runned:Bool = false;
        this.target = new It('foo desc', function(){ runned = true; });

        this.target.run();
        this.assertTrue(runned);
    }

    public function testRun_should_triggerItStartAndItDoneEvents()
    {
        this.target = new It('foo desc', function(){});

        var started:Bool = false;
        var done:Bool = false;
        this.target.addListener('it.start', function(it:It){ started = true; this.assertEquals(this.target, it); });
        this.target.addListener('it.done', function(it:It){ done = true; this.assertEquals(this.target, it); });

        this.target.run();

        this.assertTrue(started);
        this.assertTrue(done);
    }

    public function testIsPending_should_stillPendingWhileNotHasAResult()
    {
        this.target = new It('foo desc', function(){});

        this.assertTrue(this.target.isPending);
        this.target.run();
        this.assertTrue(this.target.isPending);

        this.target.addResult(Result.Success(null));

        this.assertFalse(this.target.isPending);
    }

    public function testIterator_should_iterateThroughTheResults()
    {
        this.target = new It('foo', function(){});

        this.target.addResult(Result.Success(null));
        this.target.addResult(Result.Warning('Error', null));

        for(result in this.target) {
            this.assertTrue(Std.is(result, Result));
        }
    }

    public function testIsSuccess_should_returnFalseIfHasAnyNotSuccessResult()
    {
        this.target = new It('foo', function(){});

        this.assertTrue(this.target.isSuccess);
        this.target.addResult(Result.Success(null));
        this.assertTrue(this.target.isSuccess);
        this.target.addResult(Result.Warning('Error', null));
        this.assertFalse(this.target.isSuccess);
        this.target.addResult(Result.Success(null));
        this.assertFalse(this.target.isSuccess);
    }
}
