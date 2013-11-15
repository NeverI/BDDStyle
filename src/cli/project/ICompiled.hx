package cli.project;

interface ICompiled
{
    public function generatePath(platform:String, exportFolder:String):String;
    public function getRunnable(platform:cli.project.Platform, args:cli.helper.Args):Runnable;
}
