package bdd;

import bdd.expection.CompositeShould;

class ExampleGroup
{
    public static var describeTracker:DescribeTracker;

    private var should:CompositeShould;

    public function new(should:CompositeShould)
    {
        this.should = should;
    }

    public function beforeEach():Void
    {
    }

    public function afterEach():Void
    {
    }

    public function extendBeforeEach(method:Void->Void):Void
    {
        ExampleGroup.describeTracker.addBeforeEach(method);
    }

    public function extendAfterEach(method:Void->Void):Void
    {
        ExampleGroup.describeTracker.addAfterEach(method);
    }

    public function describe(msg:String, ?method:Void->Void):Void
    {
        var describe:Describe = new Describe(msg, method);

        describe.isPending = ExampleGroup.describeTracker.isPending;
        ExampleGroup.describeTracker.addRunnable(describe);
    }

    public function xdescribe(msg:String, ?method:Void->Void):Void
    {
        var describe:Describe = new Describe(msg, method);

        describe.isPending = true;
        ExampleGroup.describeTracker.addRunnable(describe);
    }

    public function it(msg:String, ?method:Void->Void):Void
    {
        ExampleGroup.describeTracker.addRunnable(new It(msg, method));
    }

    public function xit(msg:String, ?method:Void->Void):Void
    {
        ExampleGroup.describeTracker.addRunnable(new It(msg));
    }

    public function createAsyncBlock(block:Dynamic->Void, ?timeout:Int):Dynamic->Void
    {
        #if php
        return block;
        #else
        return ExampleGroup.describeTracker.createAsyncBlock(block, timeout);
        #end
    }
}
