package src.bdd.expection;

import bdd.expection.An;

class AnTest extends TestCase
{
    private var target:An;
    private var notTarget:An;

    override public function setup():Void
    {
        super.setup();

        this.target = new An(this.reporter);
        this.notTarget = new An(this.reporter, true);
    }

    public function testInstanceOf_Success_WhenTheValueIsInstance():Void
    {
        this.target.instanceOf(An, new An(this.reporter));
        this.reporterCalledWithSuccess();
    }

    public function testNotInstanceOf_Success_WhenTheValueIsNotInstance():Void
    {
        this.notTarget.instanceOf(String, -10);
        this.reporterCalledWithSuccess();
    }

    public function testInstanceOf_Failure_WhenTheValueIsNotInstance():Void
    {
        this.target.instanceOf(Int, []);
        this.reporterCalledWithFailure('Expected Int does not instance of Array');
    }

    public function testNotInstanceOf_Failure_WhenTheValueIsInstance():Void
    {
        this.notTarget.instanceOf(AnTest, this);
        this.reporterCalledWithFailure('Not expected to be an instance of src.bdd.expection.AnTest');
    }

    public function testObject_Success_WhenTheValueIsObject():Void
    {
        this.target.object(this);
        this.reporterCalledWithSuccess();
    }

    public function testNotObject_Success_WhenTheValueIsNotObject():Void
    {
        this.notTarget.object(null);
        this.reporterCalledWithSuccess();
    }

    public function testObject_Failure_WhenTheValueIsNotObject():Void
    {
        this.target.object(1);
        this.reporterCalledWithFailure('Expected to be object');
    }

    public function testNotObject_Failure_WhenTheValueIsObject():Void
    {
        this.notTarget.object({});
        this.reporterCalledWithFailure('Not expected to be object');
    }

    public function testEnum_Success_WhenTheValueIsEnum():Void
    {
        this.target.Enum(Foo.Bar('alma'));
        this.reporterCalledWithSuccess();
    }

    public function testNotEnum_Success_WhenTheValueIsNotEnum():Void
    {
        this.notTarget.Enum('alma');
        this.reporterCalledWithSuccess();
    }

    public function testEnum_Failure_WhenTheValueIsNotEnum():Void
    {
        this.target.Enum('alma');
        this.reporterCalledWithFailure('Expected to be enum got: String');
    }

    public function testNotEnum_Failure_WhenTheValueIsEnum():Void
    {
        this.notTarget.Enum(Foo.Bar('alma'));
        this.reporterCalledWithFailure('Not expected to be enum');
    }
}

enum Foo {
    Bar(msg : String);
}
