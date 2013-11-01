package cli.project;

import cli.helper.Args;

class Factory
{
    public function new()
    {
    }

    public function create(filePath:String, requestedPlatforms:Array<String>):IProject
    {
        return this.createProject(haxe.io.Path.extension(filePath), requestedPlatforms);
    }

    private function createProject(ext:String, requestedPlatforms:Array<String>):IProject
    {
        if (ext == 'hxml') {
            return this.createHxml(requestedPlatforms);
        } else if (ext == 'xml') {
            return this.createOpenFL(requestedPlatforms);
        }

        throw 'Invaid project file';
    }

    private function createHxml(requestedPlatforms:Array<String>):HxmlProject
    {
        return new cli.project.HxmlProject(new cli.helper.HxmlParser(), requestedPlatforms);
    }

    private function createOpenFL(requestedPlatforms:Array<String>):OpenFLProject
    {
        return new cli.project.OpenFLProject(new cli.helper.OpenFLParser(), requestedPlatforms);
    }
}
