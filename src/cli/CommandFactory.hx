package cli;

import cli.command.*;

class CommandFactory
{
    public function new()
    {
    }

    public function create(argList:Array<String>):Command
    {
        var args = this.createArgs(argList);

        if (args.command == '') {
            return new Help(args);
        }

        var className:String = args.command.substr(0, 1).toUpperCase() + args.command.substring(1);
        var cls = Type.resolveClass('cli.command.'+className);

        try {
            return Type.createInstance(cls, [args]);
        } catch(e:Dynamic) {
            return new Help(args);
        }
    }

    private function createArgs(argList:Array<String>):cli.helper.Args
    {
        return new cli.helper.Args(argList);
    }
}