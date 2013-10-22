package bdd.reporter;

class Summary extends bdd.reporter.helper.Abstract
{
    public function new(printer:bdd.reporter.helper.Printer, infoCollector:bdd.reporter.helper.InfoCollector)
    {
        super(printer, infoCollector);

        this.addListener('runner.done', this.printFinal);
    }

    private function printFinal(event:Dynamic):Void
    {
        var report:String = this.infoCollector.failedSpecs.length == 0 ? 'OK' : 'Failed';
        report += ' spec: ' + this.infoCollector.specCount;
        report += ' failed: ' + this.infoCollector.failedSpecs.length;
        report += ' success: ' + (this.infoCollector.specCount - this.infoCollector.failedSpecs.length);
        report += ' expects: '+this.infoCollector.expectionCount;

        this.print(report);
    }
}
