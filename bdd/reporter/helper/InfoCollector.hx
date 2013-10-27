package bdd.reporter.helper;

import bdd.expection.Result;

class InfoCollector extends bdd.event.EventDispatcher
{
    private var itCount:Int;
    private var _expectionCount:Int;
    private var _pendingCount:Int;
    private var failedIts:Array<ItInfo>;
    private var fullOverview:String;
    private var currentIt:bdd.It;

    public function new()
    {
        super();

        this.addListener('runner.start', this.resetData);
        this.addListener('describe.start', this.expandFullOverview);
        this.addListener('describe.done', this.contractFullOverview);
        this.addListener('it.done', this.collectItData);
    }

    public var specCount(get, null):Int;
    private function get_specCount():Int
    {
        return this.itCount;
    }

    public var pendingCount(get, null):Int;
    private function get_pendingCount():Int
    {
        return this._pendingCount;
    }

    public var expectionCount(get, null):Int;
    private function get_expectionCount():Int
    {
        return this._expectionCount;
    }

    public var failedSpecs(get, null):Array<ItInfo>;
    private function get_failedSpecs():Array<ItInfo>
    {
        return this.failedIts;
    }

    private function resetData(data:Dynamic):Void
    {
        this.itCount = 0;
        this._pendingCount = 0;
        this._expectionCount = 0;
        this.failedIts = [];
        this.fullOverview = '';
    }

    private function expandFullOverview(describe:bdd.Describe):Void
    {
        this.fullOverview += describe.overview + ' ';
    }

    private function contractFullOverview(describe:bdd.Describe):Void
    {
        var currenDesribeStartIndex:Int = this.fullOverview.lastIndexOf(describe.overview);
        this.fullOverview = this.fullOverview.substring(0, currenDesribeStartIndex - 1);
    }

    private function collectItData(it:bdd.It):Void
    {
        this.itCount++;
        this._expectionCount += it.length;
        this._pendingCount += it.isPending ? 1 : 0;
        this.currentIt = it;

        this.createFailedItInfo();
    }

    private function createFailedItInfo():Void
    {
        if (this.currentIt.isSuccess) {
            return;
        }

        this.failedIts.push({
            fullOverview : this.fullOverview + ' ' + this.currentIt.overview,
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

