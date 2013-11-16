package cli;

import cli.command.*;
import cli.command.Test;
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
        var cwd:String = Sys.getCwd();
        cwd = cwd.substr(0, cwd.length-1);

        try {
            return Type.createInstance(cls, [args, project, new Tools(cwd)]);
        } catch(e:Dynamic) {
            return new Help(args, project, null);
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

        if (projectFile == '') {
            return null;
        }

        var project:IProject = factory.create(projectFile, this.getRequestedPlatforms(args));

        project.parse(sys.io.File.getContent(projectFile), projectFile);

        return project;
    }

    private function getRequestedPlatforms(args):Array<String>
    {
        return args.has('p') ? args.get('p').split(',') : [];
    }
}
