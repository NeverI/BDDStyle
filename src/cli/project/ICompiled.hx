package cli.project;

interface ICompiled
{
    public function getRunnable(platform:cli.project.Platform, args:cli.helper.Args):Runnable;
}
