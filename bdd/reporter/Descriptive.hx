package bdd.reporter;

class Descriptive extends bdd.reporter.helper.Abstract
{
    private var identation:String;

    public function new(printer:bdd.reporter.helper.Printer, infoCollector:bdd.reporter.helper.InfoCollector)
    {
        super(printer, infoCollector);

        this.addListener('group.start', this.groupStart);
        this.addListener('describe.start', this.describeStart);
        this.addListener('describe.done', this.describeDone);
        this.addListener('it.done', this.itDone);
    }

    private function groupStart(group:ExampleGroup):Void
    {
        this.identation = '';
        this.print('');
    }

    override private function print(s:Dynamic):Void
    {
        super.print(this.identation + Std.string(s)+'\n');
    }

    private function describeStart(describe:Describe):Void
    {
        if (describe.overview == '') {
            return;
        }

        this.print(describe.overview);
        this.identation += '    ';
    }

    private function describeDone(describe:Describe):Void
    {
        this.identation = this.identation.substr(0, this.identation.length - 4);
    }

    private function itDone(it:bdd.It):Void
    {
        var mark:String = it.isPending ? 'P' : (it.isSuccess ? '.' : 'X');
        this.print((mark != '.' ? mark+': ' : '') + it.overview);
    }
}
