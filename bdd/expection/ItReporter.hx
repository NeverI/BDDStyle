package bdd.expection;

import bdd.event.EventDispatcher;

class ItReporter extends EventDispatcher
{
    private var currentIt:It;

    public function new()
    {
        super();
        this.addListener('it.start', this.setCurrent);
        this.addListener('it.error', this.addError);
    }

    private function setCurrent(it:It):Void
    {
        this.currentIt = it;
    }

    public function report(result:Result)
    {
        this.currentIt.addResult(result);
    }

    private function addError(error:Dynamic):Void
    {
        this.currentIt.addResult(Result.Error(error));
    }
}
