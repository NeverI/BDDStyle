package ;

import cli.*;
import cli.helper.*;

class TestMain
{
    static function main(){ new TestMain(); }

    public function new()
    {
        var reporterFactory:bdd.reporter.helper.Factory = new bdd.reporter.helper.Factory();

        reporterFactory.create(bdd.reporter.Descriptive);
        reporterFactory.create(bdd.reporter.Error);
        reporterFactory.create(bdd.reporter.Summary);

        var runner = new bdd.Runner();
        runner.add(cli.helper.ArgsTest);

        runner.run();
    }
}