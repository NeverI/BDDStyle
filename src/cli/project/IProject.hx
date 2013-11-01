package cli.project;

interface IProject
{
    public function parse(content:String):Void;
    public function getPlatforms():Array<Platform>;
}
