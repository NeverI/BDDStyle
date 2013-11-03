package cli;

class Main
{
    static function main()
    {
        try {
            var factory:CommandFactory = new CommandFactory();
            var command:cli.command.Command = factory.create(Sys.args());

            command.run();
        } catch(e:Dynamic) {
            Sys.println(e);
        }
    }
}
