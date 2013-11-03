package cli.command;

class Run extends Command
{
    override public function printHelp():Void
    {
        Sys.println('');
        Sys.println('run   simple execute the pre-builded platforms (where is possible)');
    }

    override public function run():Void
    {
        for (platform in this.project.getPlatforms()) {
            this.project.run(platform);
        }
    }
}