package bdd.expection;

import bdd.It;
import bdd.TestRunner;
import bdd.exception.ItAbort;

class ItReporter
{
    public var runner:TestRunner;

    public function new()
    {
    }

    public function report(result: Result)
    {
        this.currentIt.setResult(result);
    }

    private var currentIt(get, null):It;
    private function get_currentIt():It
    {
        if (this.runner == null || this.runner.currentIt == null) {
            throw new ItAbort('ItReporter does not has runner or runner does not has it');
        }

        return this.runner.currentIt;
    }
}
