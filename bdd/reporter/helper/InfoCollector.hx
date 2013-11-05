package bdd.reporter.helper;

import bdd.expection.Result;

class InfoCollector extends bdd.event.EventDispatcher
{
    public var specCount(default, null):Int;
    public var pendingCount(default, null):Int;
    public var expectionCount(default, null):Int;
    public var failedSpecs(default, null):Array<ItInfo>;

    private var fullOverview:Array<String>;
    private var currentIt:bdd.It;

    public function new()
    {
        super();

        this.addListener('runner.start', this.resetData);
        this.addListener('describe.start', this.expandFullOverview);
        this.addListener('describe.done', this.contractFullOverview);
        this.addListener('it.done', this.collectItData);
    }

    private function resetData(data:Dynamic):Void
    {
        this.specCount = 0;
        this.pendingCount = 0;
        this.expectionCount = 0;
        this.failedSpecs = [];
        this.fullOverview = [];
    }

    private function expandFullOverview(describe:bdd.Describe):Void
    {
        this.fullOverview.push(describe.overview);
    }

    private function contractFullOverview(describe:bdd.Describe):Void
    {
        this.fullOverview.pop();
    }

    private function collectItData(it:bdd.It):Void
    {
        this.specCount++;
        this.expectionCount += it.length;
        this.pendingCount += it.isPending ? 1 : 0;
        this.currentIt = it;

        this.createFailedItInfo();
    }

    private function createFailedItInfo():Void
    {
        if (this.currentIt.isSuccess) {
            return;
        }

        this.failedSpecs.push({
            fullOverview : this.fullOverview.join(' ') + ' ' + this.currentIt.overview,
            failedExpects : this.createFailedResultList()
        });
    }

    private function createFailedResultList():Array<ExpectInfo>
    {
        var counter:Int = -1;
        var infos:Array<ExpectInfo> = [];

        for (result in this.currentIt) {
            counter++;
            switch result {
                case Result.Success:
                    continue;
                default:
                    infos.push({
                        index: counter,
                        result: result
                    });
            }
        }

        return infos;
    }
}

private typedef ItInfo = {
    fullOverview:String,
    failedExpects:Array<ExpectInfo>
}

private typedef ExpectInfo = {
    index:Int,
    result:Result
}

