package cli.project;

interface IProject
{
    public function parse(content:String, path:String=''):Void;
    public function run(paltform:Platform, ?options:Dynamic):Int;
    public function build(paltform:Platform):Void;
    public function getPlatforms():Array<Platform>;
}
