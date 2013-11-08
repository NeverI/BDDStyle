package cli.command;

class Run extends Command
{
    override public function printHelp():Void
    {
        Sys.println('');
        Sys.println('run   simple execute the pre-builded platforms (where is possible)');
        Sys.println('      [ phantomjs ] for js target (openfl and hxml)');
        Sys.println('      [ nodejs ] for js target (hxml)');
        Sys.println('      [ native ] for swf target. this will launch the default swf player');
        Sys.println('                 instead of browser. (openfl and hxml)');
    }

    override public function run():Void
    {
        var exitCode:Int = 0;
        for (platform in this.project.getPlatforms()) {
            exitCode += this.project.run(platform, this.args);
        }

        Sys.exit(exitCode);
    }
}
