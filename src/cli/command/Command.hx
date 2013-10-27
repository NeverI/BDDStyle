package cli.command;

import cli.helper.Args;

class Command
{
    private var args:Args;

    public function new(args:Args)
    {
        this.args = args;
    }

    public function run():Void
    {
    }
}