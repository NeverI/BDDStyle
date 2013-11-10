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

        reporters.set('default', reporters.get('desc'));

        new bdd.reporter.helper.Factory().createFromList(reporters.get('default'));

        var runner = new bdd.Runner();
        runner.add(cli.helper.ArgsTest);
        runner.add(cli.project.hxml.ParserTest);
        //runner.add(cli.project.hxml.ProjectTest);
        //runner.add(cli.project.openfl.ProjectTest);
        runner.add(cli.project.openfl.ParserTest);
        runner.add(cli.project.PlatformTest);
        runner.add(cli.project.FileFinderTest);
        runner.add(cli.project.FactoryTest);
        runner.add(cli.tools.FileCreatorTest);
        runner.add(cli.tools.AssetsTest);
        runner.add(cli.CommandFactoryTest);
        runner.add(cli.command.CreateTest);
        runner.add(cli.command.BuildTest);

        runner.run();
    }
}
