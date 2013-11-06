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
        runner.add(ExampleTest);

        runner.run();
    }
}
