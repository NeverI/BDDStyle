package src.bdd;

import bdd.Describe;
import bdd.DescribeTracker;
import bdd.event.EventDispatcher;

import mockatoo.Mockatoo.*;

import haxe.unit.TestCase;

class DescribeTrackerTest extends TestCase
{
    private var describe:Describe;
    private var target:DescribeTracker;

    override public function setup()
    {
        EventDispatcher.removeAllListener();

        this.describe = mock(Describe);
        this.target = new DescribeTracker();
        this.target.start(this.describe);
    }

    public function testIsPending_should_returnTheCurrentDesribeState()
    {
        this.assertFalse(this.target.isPending);

        returns(this.describe.isPending, true);
        this.assertTrue(this.target.isPending);
    }

    public function testAddBeforeEach_should_addBeforeEachForTheCurrentDescribe()
    {
        var f:Void->Void = function(){};
        this.target.addBeforeEach(f);

        verify(this.describe.addBeforeEach(f));
        this.assertTrue(true);
    }

    public function testAddBeforeEach_should_throwIfNoCurrentDescribe()
    {
        this.target = new DescribeTracker();

        try {
            this.target.addBeforeEach(function(){});
        } catch(e:bdd.exception.SetupError) {
            this.assertTrue(true);
            return;
        }

        this.assertFalse(true);
    }

    public function testAddAfterEach_should_addAfterEachForTheCurrentDescribe()
    {
        var f:Void->Void = function(){};
        this.target.addAfterEach(f);

        verify(this.describe.addAfterEach(f));
        this.assertTrue(true);
    }

    public function testAddRunnable_should_addRunnableForTheCurrentDescribe()
    {
        this.target.addRunnable(this.describe);
        verify(this.describe.addRunnable(this.describe));

        this.assertTrue(true);
    }
}
