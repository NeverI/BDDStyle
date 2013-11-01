package cli.command;

import cli.helper.Args;
import cli.project.IProject;

class Command
{
    private var args:Args;
    private var project:IProject;

    public function new(args:Args, project:IProject)
    {
        this.args = args;
        this.project = project;
    }

    public function run():Void
    {
    }
}
