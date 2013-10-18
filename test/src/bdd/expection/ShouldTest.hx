package src.bdd.expection;

import bdd.expection.Should;

class ShouldTest extends TestCase
{
    private var target:Should;

    override public function setup():Void
    {
        super.setup();

        this.target = new Should();
        this.target.setReporter(this.reporter);
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
        this.target.setIsNegated(true);
        this.target.fail();
        this.reporterCalledWithSuccess();
    }

    public function testSucceed_CallTheReporterWithSuccess():Void
    {
        this.target.success();
        this.reporterCalledWithSuccess();
    }

    public function testNotSucceed_CallTheReporterWitFailure():Void
    {
        this.target.setIsNegated(true);
        this.target.success();
        this.reporterCalledWithFailure('Not expected to succeed');
    }
}
