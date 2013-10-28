package bdd.reporter;

import bdd.expection.Result;

class Error extends bdd.reporter.helper.Abstract
{
    public function new(printer:bdd.reporter.helper.Printer, infoCollector:bdd.reporter.helper.InfoCollector)
    {
        super(printer, infoCollector);

        this.addListener('runner.done', this.printFailed);
    }

    private function printFailed(event:Dynamic):Void
    {
        var counter:Int = 1;
        this.print('\n');
        for (info in this.infoCollector.failedSpecs) {
            this.print(counter+') ' + info.fullOverview+'\n');
            for (expect in info.failedExpects) {
                switch (expect.result) {
                    case Result.Error:
                        this.printFailedWithException(expect.result);
                    default:
                        this.printFailedWithMessage(expect.result);
                }
            }
            this.print('\n');
            counter++;
        }

    }

    private function printFailedWithException(result:Result):Void
    {
        var error = result.getParameters()[0];

        this.print('Uncaught exception: ');
        if (!Std.is(error, bdd.exception.Exception)) {
            this.print(error+'\n');
        } else {
            this.print(error);
            this.print(cast(error, bdd.exception.Exception).getStack());
            this.print('\n');
        }
    }

    private function printFailedWithMessage(result:Result):Void
    {
        var parameters = result.getParameters();
        this.printer.customTrace(parameters[0], parameters[1]);
    }
}
