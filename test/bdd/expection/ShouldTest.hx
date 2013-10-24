package bdd.expection;

class ShouldTest extends TestCase
{
    private var target:Should;
    private var notTarget:Should;

    override public function setup():Void
    {
        super.setup();

        this.target = new Should(this.reporter);
        this.notTarget = new Should(this.reporter, true);
    }

    public function testFail_CallTheReporterWitFailure():Void
    {
        this.target.fail();
        this.reporterCalledWithFailure('Fail anyway');

        this.target.fail('Just fail');
        this.reporterCalledWithFailure('Just fail');
    }

    public function testNotFail_CallTheReporterWithSuccess():Void
    {
        this.notTarget.fail();
        this.reporterCalledWithSuccess();
    }

    public function testSucceed_CallTheReporterWithSuccess():Void
    {
        this.target.success();
        this.reporterCalledWithSuccess();
    }

    public function testNotSucceed_CallTheReporterWitFailure():Void
    {
        this.notTarget.success();
        this.reporterCalledWithFailure('Not expected to succeed');
    }
}
