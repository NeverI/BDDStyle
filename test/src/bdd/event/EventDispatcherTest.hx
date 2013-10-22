package src.bdd.event;

import bdd.event.EventDispatcher;

import haxe.unit.TestCase;

class EventDispatcherTest extends TestCase
{
    private var target:EventDispatcher;
    private var eventCallTime:Int;

    override public function setup():Void
    {
        EventDispatcher.removeAllListener();
        this.target = new EventDispatcher();
        this.eventCallTime = 0;
    }

    public function testAddEventListener_should_runMultipleTimesWithOutError():Void
    {
        this.target.addListener('test.event', function(event){});
        this.target.addListener('test.event', this.eventListener);
        this.assertTrue(true);
    }

    private function eventListener(event:Dynamic):Void
    {
        this.eventCallTime++;
    }

    public function testTrigger_should_triggerTheData():Void
    {
        var event2CallTime:Int = 0;
        var eventObject:Dynamic = null;

        this.target.addListener('event', function(event){ this.eventCallTime++; eventObject = event; });
        this.target.addListener('event', this.eventListener);
        this.target.addListener('event', this.eventListener);
        this.target.addListener('event2', function(event){ });

        this.target.trigger('event', 'foo');

        this.assertEquals(0, event2CallTime);
        this.assertEquals(2, this.eventCallTime);

        this.assertEquals('foo', eventObject);
    }

    public function testRemoveEventListener_should_removeAllTheAttachedListeners():Void
    {
        this.target.addListener('event', this.eventListener);
        this.target.removeListener('event');

        this.target.trigger('event', 'foo');
        this.assertEquals(0, this.eventCallTime);
    }

    public function testRemoveEventListener_should_removeTheSpecifiedAttachedListener():Void
    {

        this.target.addListener('event', this.eventListener);
        this.target.removeListener('event', this.eventListener);

        this.target.trigger('event', 'foo');
        this.assertEquals(0, this.eventCallTime);

        this.target.removeListener('event', this.eventListener);
    }
}
