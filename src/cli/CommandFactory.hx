package cli;

import cli.command.*;
import cli.helper.Args;
import cli.project.Factory;
import cli.project.IProject;
import cli.project.FileFinder;
import cli.tools.Tools;

class CommandFactory
{
    public function new()
    {
    }

    public function create(argList:Array<String>):Command
    {
        var args = this.createArgs(argList);

        if (args.command == '') {
            return new Help(args, null, null);
        }

        var project = this.createProject(args);
        var cls = this.getClass(args.command);

        try {
            return Type.createInstance(cls, [args, project, new Tools()]);
        } catch(e:Dynamic) {
            return new Help(args, null, null);
        }
    }

    private function createArgs(argList:Array<String>):Args
    {
        return new Args(argList);
    }

    private function getClass(command:String):Class<Dynamic>
    {
        var className:String = command.substr(0, 1).toUpperCase() + command.substring(1);
        return Type.resolveClass('cli.command.' + className);
    }

    private function createProject(args:Args):IProject
    {
        var factory:Factory = new Factory();
        var projectFile:String = new FileFinder(args).get();

        var project:IProject = factory.create(projectFile, this.getRequestedPlatforms(args));

        project.parse(sys.io.File.getContent(projectFile));

        return project;
    }

    private function getRequestedPlatforms(args):Array<String>
    {
        return args.get('p').split(',');
    }
}
