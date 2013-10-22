package bdd.reporter;

class Dot extends bdd.reporter.helper.Abstract
{
    public function new(printer:bdd.reporter.helper.Printer, infoCollector:bdd.reporter.helper.InfoCollector)
    {
        super(printer, infoCollector);

        this.addListener('it.done', this.itDone);
    }

    private function itDone(it:bdd.It):Void
    {
        var mark:String = it.isPending ? 'P' : ( it.isSuccess ? '.' : 'X' );
        this.print(mark);
    }
}
