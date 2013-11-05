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
        if (this.infoCollector.failedSpecs.length != 0) {
            #if (cpp||neko)
            Sys.exit(1);
            #else
            this.print('failed');
            #end
        }
    }
}
