package bdd.expection;

class ThrowTest extends TestCase
{
    private var target:Throw;
    private var notTarget:Throw;

    override public function setup():Void
    {
        super.setup();

        this.target = new Throw(this.reporter);
        this.notTarget = new Throw(this.reporter, true);
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

    public function testThrow_CallTheReporterWith_Failure_WhenTheExpectsIsStringAndDoesNotMatch():Void
    {
        this.target.throws(function(){ throw  'alma'; }, 'korte');
        this.reporterCalledWithFailure('Expected exception korte but got alma');
    }

    public function testThrow_CallTheReporterWith_Success_WhenThrowedTheGivenType():Void
    {
        this.target.throws(function(){ throw  'alma'; }, String);
        this.reporterCalledWithSuccess();
    }

    public function testThrow_CallTheReporterWith_Failure_WhenNotThrowedTheGivenType():Void
    {
        this.target.throws(function(){ throw  'alma'; }, TestCase);
        this.reporterCalledWithFailure('Expected exception type is bdd.expection.TestCase but got String');
    }

    public function testNotThrow_CallTheReporterWith_Sucess_WhenNotThrowAndNothingToExpected():Void
    {
        this.notTarget.throws(function(){ var a = 0; });
        this.reporterCalledWithSuccess();
    }

    public function testNotThrow_CallTheReporterWith_Failure_WhenThrowAndNothingToExpexted():Void
    {
        this.notTarget.throws(function(){ throw  'alma'; });
        this.reporterCalledWithFailure('Not expected an exception throwed');
    }

    public function testNotThrow_CallTheReporterWith_Sucess_WhenTheExpectsIsStringAndNotMatch():Void
    {
        this.notTarget.throws(function(){ throw  'alma'; }, 'korte');
        this.reporterCalledWithSuccess();
    }

    public function testNotThrow_CallTheReporterWith_Failure_WhenTheExpectsIsStringAndMatch():Void
    {
        this.notTarget.throws(function(){ throw  'alma'; }, 'alma');
        this.reporterCalledWithFailure('Not expected to throw the same string: alma');
    }

    public function testnotThrow_CallTheReporterWith_Success_WhenThrowedNotTheGivenType():Void
    {
        this.notTarget.throws(function(){ throw  'alma'; }, TestCase);
        this.reporterCalledWithSuccess();
    }

    public function testNotThrow_CallTheReporterWith_Failure_WhenThrowedTheGivenType():Void
    {
        this.notTarget.throws(function(){ throw  'alma'; }, String);
        this.reporterCalledWithFailure('Not expected to throw the same type: String');
    }
}
