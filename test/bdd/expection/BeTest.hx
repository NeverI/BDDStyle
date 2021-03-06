package bdd.expection;

class BeTest extends TestCase
{
    private var target:Be;
    private var notTarget:Be;

    override public function setup():Void
    {
        super.setup();

        this.target = new Be(this.reporter);
        this.notTarget = new Be(this.reporter, true);
    }

    public function testTrue_Success_WhenTheValueIsTrue():Void
    {
        this.target.True('alma' == 'alma');
        this.reporterCalledWithSuccess();
    }

    public function testNotTrue_Success_WhenTheValueIsNotTrue():Void
    {
        this.notTarget.True(1 == 2);
        this.reporterCalledWithSuccess();
    }

    public function testTrue_Failure_WhenTheValueIsNotTrue():Void
    {
        this.target.True(false);
        this.reporterCalledWithFailure('Expected to be true');
    }

    public function testNotTrue_Failure_WhenTheValueIsTrue():Void
    {
        this.notTarget.True(true);
        this.reporterCalledWithFailure('Not expected to be true');
    }

    public function testFalse_Success_WhenTheValueIsFalse():Void
    {
        this.target.False('alma' != 'alma');
        this.reporterCalledWithSuccess();
    }

    public function testNotFalse_Success_WhenTheValueIsNotFalse():Void
    {
        this.notTarget.False(1 != 2);
        this.reporterCalledWithSuccess();
    }

    public function testFalse_Failure_WhenTheValueIsNotFalse():Void
    {
        this.target.False(true);
        this.reporterCalledWithFailure('Expected to be false');
    }

    public function testNotFalse_Failure_WhenTheValueIsFalse():Void
    {
        this.notTarget.False(false);
        this.reporterCalledWithFailure('Not expected to be false');
    }
}
