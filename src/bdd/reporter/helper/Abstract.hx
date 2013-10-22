package bdd.reporter.helper;

class Abstract extends bdd.event.EventDispatcher
{
    private var printer:Printer;
    private var infoCollector:InfoCollector;

    public function new(printer:Printer, infoCollector:InfoCollector)
    {
        super();

        this.printer = printer;
        this.infoCollector = infoCollector;
    }

    private function print(v:Dynamic):Void
    {
        this.printer.print(v);
    }
}
