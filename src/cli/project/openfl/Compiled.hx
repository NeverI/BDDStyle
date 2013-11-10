package cli.project.openfl;

import cli.project.Runnable;

class Compiled implements cli.project.ICompiled
{
    private var args:cli.helper.Args;

    public function new()
    {
    }

    public function getRunnable(platform:cli.project.Platform, args:cli.helper.Args):Runnable
    {
        this.args = args;
        return { command: '', args:[] };
    }
}
