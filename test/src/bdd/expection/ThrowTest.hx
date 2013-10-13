package src.bdd.expection;

import bdd.expection.Throw;

class ThrowTest extends TestCase
{
    private var target:Throw;

    override public function setup():Void
    {
        super.setup();

        this.target = new Throw();
        this.target.setReporter(this.reporter);
    }

    public function testThrow_CallTheReporterWith_Sucess_WhenThrowAndNothingToExpected():Void
    {
        this.target.throws(function(){ throw  'alma'; });
        this.reporterCalledWithSuccess();
    }

    public function testThrow_CallTheReporterWith_Failure_WhenNotThrowAndNothingToExpexted():Void
    {
        this.target.throws(function(){ var a = 0; });
        this.reporterCalledWithFailure('Expected exception not throwed');
    }

    public function testThrow_CallTheReporterWith_Successs_WhenTheExpectsIsStringAndMatch():Void
    {
        this.target.throws(function(){ throw  'alma korte'; }, '^al.+te$');
        this.reporterCalledWithSuccess();
    }

    public function testThrow_CallTheReporterWith_Failue_WhenTheExpectsIsStringAndDoesNotMatch():Void
    {
        this.target.throws(function(){ throw  'alma'; }, 'korte');
        this.reporterCalledWithFailure('Expected exception korte but got alma');
    }

    public function testThrow_CallTheReporterWith_Success_WhenThrowedTheGivenType():Void
    {
        this.target.throws(function(){ throw  'alma'; }, String);
        this.reporterCalledWithSuccess();
    }

    public function testThrow_CallTheReporterWith_Failue_WhenNotThrowedTheGivenType():Void
    {
        this.target.throws(function(){ throw  'alma'; }, TestCase);
        this.reporterCalledWithFailure('Expected exception type is src.bdd.expection.TestCase but got String');
    }
}
