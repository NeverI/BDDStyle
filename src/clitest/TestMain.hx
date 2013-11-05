package ;

import bdd.reporter.*;

class TestMain
{
    static function main()
    {
        var reporters = new Map<String, Array<Class<bdd.reporter.helper.Abstract>>>();
        reporters.set('desc', [Descriptive, Error, Summary]);
        reporters.set('dot', [Dot, Error, Summary]);
        reporters.set('silent', [Silent]);

        new bdd.reporter.helper.Factory().createFromList(reporters.get('dot'));

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
        runner.add(cli.tools.AssetsTest);

        runner.add(cli.CommandFactoryTest);
        runner.add(cli.command.CreateTest);
        runner.add(cli.command.RunTest);
        runner.add(cli.command.BuildTest);
        runner.add(cli.command.TestTest);

        runner.run();
    }
}
