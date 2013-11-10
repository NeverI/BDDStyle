package cli.project;

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

    private function createHxml(requestedPlatforms:Array<String>):cli.project.hxml.Project
    {
        return new cli.project.hxml.Project(new cli.project.hxml.Parser(), new cli.project.hxml.Compiled(), new cli.helper.Process(), requestedPlatforms);
    }

    private function createOpenFL(requestedPlatforms:Array<String>):cli.project.openfl.Project
    {
        return new cli.project.openfl.Project(new cli.project.openfl.Parser(), new cli.project.openfl.Compiled(), new cli.helper.Process(), requestedPlatforms);
    }
}
