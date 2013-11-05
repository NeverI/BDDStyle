package ;

class TestMain
{
    static function main(){ new TestMain(); }

    public function new()
    {
        var reporterFactory:bdd.reporter.helper.Factory = new bdd.reporter.helper.Factory();
        reporterFactory.create(%reporters%);

        var runner = new bdd.Runner();
        runner.add(ExampleTest);

        runner.run();
    }
}
