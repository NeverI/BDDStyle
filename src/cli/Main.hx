package cli;

class Main
{
    static function main()
    {
        var factory:CommandFactory = new CommandFactory();
        var command:cli.command.Command = factory.create(Sys.args());

        try {
            comamnd.run();
        } catch(e:Dynamic) {
            trace(e);
        }
    }
}
