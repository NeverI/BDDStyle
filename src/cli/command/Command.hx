package cli.command;

import cli.helper.Args;
import cli.project.IProject;
import cli.tools.Tools;

class Command
{
    private var args:Args;
    private var project:IProject;
    private var tools:Tools;

    public function new(args:Args, project:IProject, tools:Tools)
    {
        this.args = args;
        this.project = project;
        this.tools = tools;

        Sys.setCwd(this.args.cwd);
    }

    public function printHelp():Void
    {
    }

    public function run():Void
    {
    }
}
