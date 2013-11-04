package cli.command;

class Help extends Command
{
    override public function printHelp():Void
    {
        Sys.println('Global parameters:');
        Sys.println('    -f <filepath> when your project file is not in the cwd');
        Sys.println('                  or its name is not test');
        Sys.println('    -p <platforms> comma separeted list for valid haxe or openfl');
        Sys.println('                  platforms. Can specified which platfroms would');
        Sys.println('                  you like to run a command.');
        Sys.println('                  With openfl default is neko.');
    }

    override public function run():Void
    {
        this.printHelp();

        new Init(this.args, this.project, this.tools).printHelp();

        if (this.project == null) {
            Sys.println('Not found and specified a project file\n');
            return;
        }

        new Create(this.args, this.project, this.tools).printHelp();
        new Run(this.args, this.project, this.tools).printHelp();
        new Build(this.args, this.project, this.tools).printHelp();
        new Test(this.args, this.project, this.tools).printHelp();

        Sys.println('');
    }
}
