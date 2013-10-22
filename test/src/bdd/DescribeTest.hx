package src.bdd;

import bdd.It;
import bdd.Describe;
import bdd.event.EventDispatcher;

import mockatoo.Mockatoo.*;

import haxe.unit.TestCase;

class DescribeTest extends TestCase
{
    private var target:Describe;

    override public function setup()
    {
        this.target = new Describe('foo desc', function(){});
        EventDispatcher.removeAllListener();
    }

    public function testConstruct_should_setTheOverviewOfTheIt()
    {
        this.assertEquals('foo desc', this.target.overview);
    }

    public function testAddBeforeEach_should_callOnItStartEvent()
    {
        var callCount:Int = 0;

        this.target.addBeforeEach(function(){ callCount++; });
        this.target.addBeforeEach(function(){ callCount++; });
        this.target.trigger('it.start', new It('foo'));

        this.assertEquals(2, callCount);
    }

    public function testAddAfterEach_should_callOnItDoneEvent()
    {
        var callCount:Int = 0;

        this.target.addAfterEach(function(){ callCount++; });
        this.target.trigger('it.done', new It('foo'));

        this.assertEquals(1, callCount);
    }

    public function testAddRunnable_should_clearTheItMethodIfDesribeIsPending()
    {
        var it = mock(bdd.It);
        this.target.isPending = true;
        this.target.addRunnable(it);

        verify(it.clearMethod());
        this.assertTrue(true);
    }

    public function testRun_should_triggerDescribeStartAndDescribeDoneEvents()
    {
        var started:Bool = false;
        var done:Bool = false;
        this.target.addListener('describe.start', function(event){ started = true; this.assertEquals(this.target, event); });
        this.target.addListener('describe.done', function(event){ done = true; this.assertEquals(this.target, event); });

        this.target.run();

        this.assertTrue(started);
        this.assertTrue(done);
    }

    public function testRun_should_callTheMethodAndAllRunnableOneByOne()
    {
        var callCount:Int = 0;
        this.target = new Describe('foo', function(){
                this.target.addRunnable(new Describe('foo inner', function(){ callCount++; }));
                this.target.addRunnable(new Describe('foo inner 2', function(){ callCount++; }));
            });

        this.target.run();
        this.assertEquals(2, callCount);
    }
}
