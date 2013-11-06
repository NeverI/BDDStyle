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
        var report:String = this.infoCollector.specCount + ' spec, ';
        report += (this.infoCollector.specCount - this.infoCollector.pendingCount - this.infoCollector.failedSpecs.length)+ ' success, ';
        report += this.infoCollector.pendingCount + ' pending, ';
        report += this.infoCollector.failedSpecs.length + ' failed, ';
        report += this.infoCollector.expectionCount + ' expects.';
        report += '\n';
        report += this.infoCollector.failedSpecs.length == 0 ? 'OK' : 'FAILED';
        report += '\n';

        this.print(report);

        #if (cpp||neko)
        Sys.exit(this.infoCollector.failedSpecs.length);
        #end
    }
}
