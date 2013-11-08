package cli.command;

class Test extends Build
{
    private var exitCode:Int;

    override public function printHelp():Void
    {
        Sys.println('');
        Sys.println('test    build & run');
    }

    override public function run():Void
    {
        this.exitCode = 0;

        super.run();

        Sys.exit(this.exitCode);
    }

    override private function processPlatform():Void
    {
        super.processPlatform();
        this.exitCode += this.project.run(this.platform, this.args);
    }
}
