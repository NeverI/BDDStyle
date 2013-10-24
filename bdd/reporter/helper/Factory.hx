package bdd.reporter.helper;

class Factory
{
    private var infoCollector:InfoCollector;
    private var printer:Printer;

    public function new()
    {
        this.printer = new Printer();
        this.infoCollector = new InfoCollector();
    }

    public function create(cls:Class<Dynamic>):Abstract
    {
        return Type.createInstance(cls, [this.printer, this.infoCollector ]);
    }
}
