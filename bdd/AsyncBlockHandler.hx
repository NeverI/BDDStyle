package bdd;

import bdd.munit.Timer;

class AsyncBlockHandler extends bdd.event.EventDispatcher
{
    private var asyncBlockCount:Int;
    private var finnishedAsyncBlockCount:Int;

    private var timers:Array<Timer>;
    private var isTimedOut:Bool;

    public function new()
    {
        super();

        this.asyncBlockCount = 0;
        this.finnishedAsyncBlockCount = 0;
        this.timers = [];
        this.isTimedOut = false;
    }

    public function startListen():Void
    {
        this.addListener('asyncBlock.finnished', this.asynBlockFinnished);
    }

    private function asynBlockFinnished(timer:Timer):Void
    {
        timer.stop();

        this.finnishedAsyncBlockCount++;

        #if (cpp || neko)
        // because of sleep hack we dispatch the done event in the wait sleep loop
        #else
        if (this.finnishedAsyncBlockCount == this.asyncBlockCount) {
            this.done();
        }
        #end
    }

    private function done():Void
    {
        this.finnishedAsyncBlockCount = this.asyncBlockCount;

        this.removeListener('asyncBlock.finnished', this.asynBlockFinnished);
        this.trigger('asyncBlock.done', this.isTimedOut);
    }

    public function waitForAsync():Void
    {
        if (this.asyncBlockCount == 0) {
            this.done();
            return;
        }

        #if (cpp || neko)
        while (this.finnishedAsyncBlockCount != this.asyncBlockCount) {
            Sys.sleep(0.01);
            if (this.finnishedAsyncBlockCount == this.asyncBlockCount) {
                this.done();
            }
        }
        #end
    }

    public function createAsyncBlock(block:Dynamic->Void, timeout:Int = 400):Dynamic->Void
    {
        this.asyncBlockCount++;

        var timer:Timer = Timer.delay(this.timeoutHandler, timeout);
        this.timers.push(timer);

        return function(?data:Dynamic):Void{
            if (this.isTimedOut) {
                return;
            }

            try {
                block(data);
            } catch (e:Dynamic) {
                this.trigger('it.error', e);
            }

            this.trigger('asyncBlock.finnished' , timer);
        }
    }

    private function timeoutHandler(?data:Dynamic):Void
    {
        this.isTimedOut = true;

        for (timer in this.timers) {
            timer.stop();
        }

        this.done();
    }
}
