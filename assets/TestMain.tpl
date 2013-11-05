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

        new bdd.reporter.helper.Factory().createFromList(reporters.get('desc'));

        var runner = new bdd.Runner();
        runner.add(ExampleTest);

        runner.run();
    }
}
