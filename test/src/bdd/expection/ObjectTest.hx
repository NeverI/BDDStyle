package src.bdd.expection;

import bdd.expection.Object;

class ObjectTest extends TestCase
{
    private var target:Object;
    private var notTarget:Object;

    override public function setup():Void
    {
        super.setup();

        this.target = new Object(this.reporter);
        this.notTarget = new Object(this.reporter, true);
    }

    public function testProperty_Success_WhenTheValueHavaProperty():Void
    {
        this.target.property('alma', {alma: 'true'});
        this.reporterCalledWithSuccess();
    }

    public function testNotProperty_Success_WhenTheValueHavaNotProperty():Void
    {
        this.notTarget.property('alma', {});
        this.reporterCalledWithSuccess();
    }

    public function testProperty_Failure_WhenTheValueHavaNotProperty():Void
    {
        this.target.property('alma', {});
        this.reporterCalledWithFailure('Expected object have a property alma');
    }

    public function testNotProperty_Failure_WhenTheValueHavaProperty():Void
    {
        this.notTarget.property('alma', {alma: 'true'});
        this.reporterCalledWithFailure('Not expected object have property alma');
    }

}
