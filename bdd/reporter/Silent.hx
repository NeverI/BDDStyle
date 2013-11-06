package bdd.reporter;

class Silent extends bdd.reporter.helper.Abstract
{
    public function new(printer:bdd.reporter.helper.Printer, infoCollector:bdd.reporter.helper.InfoCollector)
    {
        super(printer, infoCollector);

        this.addListener('runner.done', this.printFinal);
    }

    private function printFinal(event:Dynamic):Void
    {
        #if (cpp||neko)
        Sys.exit(this.infoCollector.failedSpecs.length);
        #else
        this.print('failed');
        #end
    }
}
