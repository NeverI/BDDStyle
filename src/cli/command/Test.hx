package cli.command;

class Test extends Build
{
    override public function printHelp():Void
    {
        Sys.println('');
        Sys.println('test [-g regexp] build & run');
    }

    override private function processPlatform():Void
    {
        super.processPlatform();
        this.project.run(this.platform, this.tools.getRunOptions(this.args, this.platform));
    }
}
