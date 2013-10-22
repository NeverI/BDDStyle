package src.bdd.expection;

import bdd.expection.Equal;

class EqualTest extends TestCase
{
    private var target:Equal;
    private var notTarget:Equal;

    override public function setup():Void
    {
        super.setup();

        this.target = new Equal(this.reporter);
        this.notTarget = new Equal(this.reporter, true);
    }

    public function testEqual_Success_WhenTheValuesAreEqual():Void
    {
        this.target.equal('alma', 'alma');
        this.reporterCalledWithSuccess();
    }

    public function testNotEqual_Success_WhenTheValuesAreNotEqual():Void
    {
        this.notTarget.equal(1, 2);
        this.reporterCalledWithSuccess();
    }

    public function testEqual_Failure_WhenTheValuesAreNotEqual():Void
    {
        this.target.equal(true, false);
        this.reporterCalledWithFailure('Expected true to be false');
    }

    public function testNotEqual_Failure_WhenTheValuesAreEqual():Void
    {
        this.notTarget.equal(false, false);
        this.reporterCalledWithFailure('Not expected to be an equal: false');
    }

    public function testEqual_Success_WhenTheValuesAreFunctionsAndEquals():Void
    {
        this.target.equal(this.testEqual_Failure_WhenTheValuesAreNotEqual, this.testEqual_Failure_WhenTheValuesAreNotEqual);
        this.reporterCalledWithSuccess();
    }

    public function testNotEqual_Success_WhenTheValuesAreFunctionsAndNotEquals():Void
    {
        var f:Void->Void = function(){};
        this.notTarget.equal(f, function(){});
        this.reporterCalledWithSuccess();
    }

    public function testEqual_Success_WhenTheValuesAreEnumsAndEquals():Void
    {
        this.target.equal(Example.Success, Example.Success);
        this.reporterCalledWithSuccess();
    }

    public function testEqual_Success_WhenTheValuesAreEnumsAndEqualsWithParameter():Void
    {
        this.target.equal(Example.Params('foo'), Example.Params('foo'));
        this.reporterCalledWithSuccess();
    }

    public function testNotEqual_Success_WhenTheValuesAreEnumsAndNotEquals():Void
    {

        this.notTarget.equal(Example.Success,Example.Params('foo'));
        this.reporterCalledWithSuccess();
    }
}

enum Example
{
    Success;
    Params(str:String);
}
