package src.bdd.expection;

import bdd.expection.Strings;

class StringsTest extends TestCase
{
    private var target:Strings;
    private var notTarget:Strings;

    override public function setup():Void
    {
        super.setup();

        this.target = new Strings(this.reporter);
        this.notTarget = new Strings(this.reporter, true);
    }

    public function testMatch_Success_WhenTheValuesAreMatches():Void
    {
        this.target.match('al+.', 'alma');
        this.reporterCalledWithSuccess();
    }

    public function testNotMatch_Success_WhenTheValuesAreNotMatches():Void
    {
        this.notTarget.match('alma', 'korte');
        this.reporterCalledWithSuccess();
    }

    public function testMatch_Failure_WhenTheValuesAreNotMatches():Void
    {
        this.target.match('\\d+', 'alma');
        this.reporterCalledWithFailure('Expected \\d+ not match with alma');
    }

    public function testNotMatch_Success_WhenTheValuesAreMatches():Void
    {
        this.notTarget.match('alma', 'alma');
        this.reporterCalledWithFailure('Not expected to match: alma');
    }

    public function testStartWith_Success_WhenTheActualStartedWith():Void
    {
        this.target.startWith('alm', 'alma');
        this.reporterCalledWithSuccess();
    }

    public function testNotStartWith_Success_WhenTheActualNotStartedWith():Void
    {
        this.notTarget.startWith('kor', 'alma');
        this.reporterCalledWithSuccess();
    }

    public function testStartWith_Failure_WhenTheActualNotStartedWith():Void
    {
        this.target.startWith('korte', 'alma');
        this.reporterCalledWithFailure('Expected to alma started with korte');
    }

    public function testNotStartWith_Failue_WhenTheActualStartedWith():Void
    {
        this.notTarget.startWith('al', 'alma');
        this.reporterCalledWithFailure('Not expected to alma started with al');
    }

    public function testEndWith_Success_WhenTheActualEndedWith():Void
    {
        this.target.endWith('ma', 'alma');
        this.reporterCalledWithSuccess();
    }

    public function testNotEndWith_Success_WhenTheActualNotEndedWith():Void
    {
        this.notTarget.endWith('kor', 'alma');
        this.reporterCalledWithSuccess();
    }

    public function testEndWith_Failure_WhenTheActualNotEndedWith():Void
    {
        this.target.endWith('te', 'alma');
        this.reporterCalledWithFailure('Expected to alma ended with te');
    }

    public function testNotEndWith_Failue_WhenTheActualEndedWith():Void
    {
        this.notTarget.endWith('ma', 'alma');
        this.reporterCalledWithFailure('Not expected to alma ended with ma');
    }
}
