package src.bdd.expection;

import bdd.expection.Number;

class NumberTest extends TestCase
{
    private var target:Number;
    private var notTarget:Number;

    override public function setup():Void
    {
        super.setup();

        this.target = new Number(this.reporter);
        this.notTarget = new Number(this.reporter, true);
    }

    public function testBelow_Success_WhenTheValueIsBelow():Void
    {
        this.target.below(5, 10);
        this.reporterCalledWithSuccess();
    }

    public function testNotBelow_Success_WhenTheValueIsNotBelow():Void
    {
        this.notTarget.below(-5, -10);
        this.reporterCalledWithSuccess();
    }

    public function testBelow_Failure_WhenTheValueIsNotBelow():Void
    {
        this.target.below(4.5, -0.7);
        this.reporterCalledWithFailure('Expected 4.5 does not lower then -0.7');
    }

    public function testNotBelow_Failure_WhenTheValueIsBelow():Void
    {
        this.notTarget.below(1.3, 2);
        this.reporterCalledWithFailure('Not expected to 2 is greater then 1.3');
    }

    public function testAbove_Success_WhenTheValueIsAbove():Void
    {
        this.target.above(5.13, 5.12);
        this.reporterCalledWithSuccess();
    }

    public function testNotAbove_Success_WhenTheValueIsNotAbove():Void
    {
        this.notTarget.above(0, 2);
        this.reporterCalledWithSuccess();
    }

    public function testAbove_Failure_WhenTheValueIsNotAbove():Void
    {
        this.target.above(-4.5, 0.7);
        this.reporterCalledWithFailure('Expected -4.5 does not greater then 0.7');
    }

    public function testNotAbove_Failure_WhenTheValueIsAbove():Void
    {
        this.notTarget.above(10, 2);
        this.reporterCalledWithFailure('Not expected to 2 is lower then 10');
    }

    public function testWithin_Success_WhenTheValueIsWhitin():Void
    {
        this.target.whitin(5, 10, 20);
        this.reporterCalledWithSuccess();
    }

    public function testNotWithin_Success_WhenTheValueIsNotWhitin():Void
    {
        this.notTarget.whitin(-5, -20, -10);
        this.reporterCalledWithSuccess();
    }

    public function testWithin_Failure_WhenTheValueIsNotWhitin():Void
    {
        this.target.whitin(4.5, -0.8, -0.7);
        this.reporterCalledWithFailure('Expected -0.8 in range 4.5 - -0.7');
    }

    public function testNotWithin_Failure_WhenTheValueIsWhitin():Void
    {
        this.notTarget.whitin(1.3, 1.5, 2);
        this.reporterCalledWithFailure('Not expected to 1.5 in range 1.3 - 2');
    }

    public function testFloatEqual_Success_WhenTheValueIsEqual():Void
    {
        this.target.floatEqual(5.13, 5.1313, 0.002);
        this.reporterCalledWithSuccess();
    }

    public function testNotFloatEqual_Success_WhenTheValueIsNotEqual():Void
    {
        this.notTarget.floatEqual(5.2, 5.1313, 0.002);
        this.reporterCalledWithSuccess();
    }

    public function testFloatEqual_Failure_WhenTheValueIsNotEqual():Void
    {
        this.target.floatEqual(0.75, 0.7, 0.01);
        this.reporterCalledWithFailure('Expected 0.75 is not equal with 0.7');
    }

    public function testNotFloatEqual_Failure_WhenTheValueIsEqual():Void
    {
        this.notTarget.floatEqual(-0.7002, -0.7, 0.01);
        this.reporterCalledWithFailure('Not expected to -0.7002 is equal with -0.7');
    }

    public function testNaN_Success_WhenTheValueIsNaN():Void
    {
        this.target.NaN(Math.NaN);
        this.reporterCalledWithSuccess();
    }

    public function testNotNaN_Success_WhenTheValueIsNotNaN():Void
    {
        this.notTarget.NaN(123);
        this.reporterCalledWithSuccess();
    }

    public function testNaN_Failure_WhenTheValueIsNotNaN():Void
    {
        this.target.NaN(123);
        this.reporterCalledWithFailure('Expected 123 to be NaN');
    }

    public function testNotNaN_Failure_WhenTheValueIsNaN():Void
    {
        this.notTarget.NaN('xxx');
        this.reporterCalledWithFailure('Not expected xxx to be NaN');
    }
}
