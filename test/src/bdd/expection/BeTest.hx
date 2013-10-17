package src.bdd.expection;

import bdd.expection.Be;

class BeTest extends TestCase
{
    private var target:Be;

    override public function setup():Void
    {
        super.setup();

        this.target = new Be();
        this.target.setReporter(this.reporter);
    }

    public function testTrue_Success_WhenTheValueIsTrue():Void
    {
        this.target.True('alma' == 'alma');
        this.reporterCalledWithSuccess();
    }

    public function testNotTrue_Success_WhenTheValueIsNotTrue():Void
    {
        this.target.setIsNegated(true);
        this.target.True(1 == 2);
        this.reporterCalledWithSuccess();
    }

    public function testTrue_Failure_WhenTheValueIsNotTrue():Void
    {
        this.target.True(false);
        this.reporterCalledWithFailure('Expected to be true');
    }

    public function testNotTrue_Failure_WhenTheValueIsTrue():Void
    {
        this.target.setIsNegated(true);
        this.target.True(true);
        this.reporterCalledWithFailure('Not expected to be true');
    }

    public function testFalse_Success_WhenTheValueIsFalse():Void
    {
        this.target.False('alma' != 'alma');
        this.reporterCalledWithSuccess();
    }

    public function testNotFalse_Success_WhenTheValueIsNotFalse():Void
    {
        this.target.setIsNegated(true);
        this.target.False(1 != 2);
        this.reporterCalledWithSuccess();
    }

    public function testFalse_Failure_WhenTheValueIsNotFalse():Void
    {
        this.target.False(true);
        this.reporterCalledWithFailure('Expected to be false');
    }

    public function testNotFalse_Failure_WhenTheValueIsFalse():Void
    {
        this.target.setIsNegated(true);
        this.target.False(false);
        this.reporterCalledWithFailure('Not expected to be false');
    }

    public function testEqual_Success_WhenTheValuesAreEqual():Void
    {
        this.target.equal('alma', 'alma');
        this.reporterCalledWithSuccess();
    }

    public function testNotEqual_Success_WhenTheValuesAreNotEqual():Void
    {
        this.target.setIsNegated(true);
        this.target.equal(1, 2);
        this.reporterCalledWithSuccess();
    }

    public function testEqual_Failure_WhenTheValuesAreNotEqual():Void
    {
        this.target.equal(true, false);
        this.reporterCalledWithFailure('Expected true to be false');
    }

    public function testNotEqual_Failure_WhenTheValuesAreEqual():Void
    {
        this.target.setIsNegated(true);
        this.target.equal(false, false);
        this.reporterCalledWithFailure('Not expected to be an equal: false');
    }
}
