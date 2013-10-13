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

    public function testNotThrow_CallTheReporterWith_Sucess_WhenNotThrowAndNothingToExpected():Void
    {
        this.target.setIsNegated(true);
        this.target.throws(function(){ var a = 0; });
        this.reporterCalledWithSuccess();
    }

    public function testNotThrow_CallTheReporterWith_Failure_WhenThrowAndNothingToExpexted():Void
    {
        this.target.setIsNegated(true);
        this.target.throws(function(){ throw  'alma'; });
        this.reporterCalledWithFailure('Not expected an exception throwed');
    }

    public function testNotThrow_CallTheReporterWith_Sucess_WhenTheExpectsIsStringAndNotMatch():Void
    {
        this.target.setIsNegated(true);
        this.target.throws(function(){ throw  'alma'; }, 'korte');
        this.reporterCalledWithSuccess();
    }

    public function testNotThrow_CallTheReporterWith_Failure_WhenTheExpectsIsStringAndMatch():Void
    {
        this.target.setIsNegated(true);
        this.target.throws(function(){ throw  'alma'; }, 'alma');
        this.reporterCalledWithFailure('Not expected to throw the same string: alma');
    }

    public function testnotThrow_CallTheReporterWith_Success_WhenThrowedNotTheGivenType():Void
    {
        this.target.setIsNegated(true);
        this.target.throws(function(){ throw  'alma'; }, TestCase);
        this.reporterCalledWithSuccess();
    }

    public function testNotThrow_CallTheReporterWith_Failue_WhenThrowedTheGivenType():Void
    {
        this.target.setIsNegated(true);
        this.target.throws(function(){ throw  'alma'; }, String);
        this.reporterCalledWithFailure('Not expected to throw the same type: String');
    }
}
