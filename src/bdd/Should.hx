package bdd;

import bdd.exception.TestAbort;

class Should
{
    public var runner:TestRunner;

    private function getRunnerStatus():TestStatus
    {
        if (this.runner == null || this.runner.status == null) {
            throw new TestAbort('Should does not has runner or status');
        }

        return this.runner.status;
    }

    public function new( ) {
    }

    public function beTrue(value:Bool):Bool
    {
        return true;
    }
}
