package ;

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
        runner.add(cli.helper.HxmlParserTest);
        runner.add(cli.helper.OpenFLParserTest);

        runner.add(cli.project.PlatformTest);
        runner.add(cli.project.HxmlProjectTest);
        runner.add(cli.project.OpenFLProjectTest);
        runner.add(cli.project.FileFinderTest);
        runner.add(cli.project.FactoryTest);

        runner.add(cli.tools.FileCreatorTest);

        runner.add(cli.CommandFactoryTest);
        runner.add(cli.command.CreateTest);

        runner.run();
    }
}
