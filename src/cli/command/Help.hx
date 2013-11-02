package cli.command;

class Help extends Command
{
    override public function printHelp():Void
    {
        trace('Global parameters:');
        trace('-f <filepath> when your project file is not in the cwd or its name is not test');
        trace('-p <platforms> comma separeted list for valid haxe or openfl platforms. Can specified which platfroms would you like run a command. With openfl default is neko.');
    }

    override public function run():Void
    {
        this.printHelp();

        new Create(this.args, this.project, this.tools).printHelp();
    }
}
