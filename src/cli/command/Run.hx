package cli.command;

class Run extends Command
{
    override public function printHelp():Void
    {
        Sys.println('');
        Sys.println('run   simple execute the pre-builded platforms (where is possible)');
        Sys.println('      [ browser|nodejs ] for js target available arguments');
    }

    override public function run():Void
    {
        var exitCode:Int = 0;
        for (platform in this.project.getPlatforms()) {
            exitCode += this.project.run(platform, this.tools.getRunOptions(this.args, platform));
        }

        Sys.exit(exitCode);
    }
}
