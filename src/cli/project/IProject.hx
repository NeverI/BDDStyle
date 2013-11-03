package cli.project;

interface IProject
{
    public function parse(content:String):Void;
    public function run(paltform:Platform):Void;
    public function getPlatforms():Array<Platform>;
}
