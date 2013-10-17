package src.bdd.expection;

import bdd.expection.A;

class ATest extends TestCase
{
    private var target:A;

    override public function setup():Void
    {
        super.setup();

        this.target = new A();
        this.target.setReporter(this.reporter);
    }

    public function testString_Success_WhenTheValueIsString():Void
    {
        this.target.string('alma');
        this.reporterCalledWithSuccess();
    }

    public function testNotString_Success_WhenTheValueIsNotString():Void
    {
        this.target.setIsNegated(true);
        this.target.string(-10);
        this.reporterCalledWithSuccess();
    }

    public function testString_Failure_WhenTheValueIsNotString():Void
    {
        this.target.string([]);
        this.reporterCalledWithFailure('Expected to be string got: Array');
    }

    public function testNotString_Failure_WhenTheValueIsString():Void
    {
        this.target.setIsNegated(true);
        this.target.string('alma');
        this.reporterCalledWithFailure('Not expected to be string');
    }

    public function testBool_Success_WhenTheValueIsBool():Void
    {
        this.target.bool(false);
        this.reporterCalledWithSuccess();
    }

    public function testNotBool_Success_WhenTheValueIsNotBool():Void
    {
        this.target.setIsNegated(true);
        this.target.bool(-10);
        this.reporterCalledWithSuccess();
    }

    public function testBool_Failure_WhenTheValueIsNotBool():Void
    {
        this.target.bool('alma');
        this.reporterCalledWithFailure('Expected to be bool got: String');
    }

    public function testNotBool_Failure_WhenTheValueIsBool():Void
    {
        this.target.setIsNegated(true);
        this.target.bool(true);
        this.reporterCalledWithFailure('Not expected to be bool');
    }

    public function testNumber_Success_WhenTheValueNumber():Void
    {
        this.target.number(1.5);
        this.reporterCalledWithSuccess();
    }

    public function testNotNumber_Success_WhenTheValueIsNotNumber():Void
    {
        this.target.setIsNegated(true);
        this.target.number('alma');
        this.reporterCalledWithSuccess();
    }

    public function testNumber_Failure_WhenTheValueIsNotNumber():Void
    {
        this.target.number('alma');
        this.reporterCalledWithFailure('Expected to be number got: String');
    }

    public function testNotNumber_Failure_WhenTheValueIsNumber():Void
    {
        this.target.setIsNegated(true);
        this.target.number(1);
        this.reporterCalledWithFailure('Not expected to be number');
    }

    public function testFunction_Success_WhenTheValueIsFunction():Void
    {
        this.target.Function(this.assertTrue);
        this.reporterCalledWithSuccess();
    }

    public function testNotFunction_Success_WhenTheValueIsNotFunction():Void
    {
        this.target.setIsNegated(true);
        this.target.Function(this);
        this.reporterCalledWithSuccess();
    }

    public function testFunction_Failure_WhenTheValueIsNotFunction():Void
    {
        this.target.Function('alma');
        this.reporterCalledWithFailure('Expected to be function got: String');
    }

    public function testNotFunction_Failure_WhenTheValueIsFunction():Void
    {
        this.target.setIsNegated(true);
        this.target.Function(Math.abs);
        this.reporterCalledWithFailure('Not expected to be function');
    }
}
