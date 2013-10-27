package cli.command;

class Help extends Command
{
    override public function run():Void
    {
        trace('this is the help command');
    }
}