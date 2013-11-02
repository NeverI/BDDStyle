package cli.project;

import cli.helper.OpenFLParser;
import cli.project.Platform;

class OpenFLProject implements IProject
{
    private var platforms:Array<Platform>;
    private var requestedPlatforms:Array<String>;

    private var parser:OpenFLParser;

    public function new(parser:OpenFLParser, requestedPlatforms:Array<String>)
    {
        this.parser = parser;
        this.platforms = [];
        this.requestedPlatforms = requestedPlatforms.length == 0 ? [ Sys.systemName().toLowerCase() + ' -neko' ] : requestedPlatforms;
    }

    public function parse(content:String):Void
    {
        var platformData:PlatformData = this.parser.parse(content);

        for (platformName in requestedPlatforms) {
            platformData.name = platformName;
            this.platforms.push(new Platform(platformData));
        }
    }

    public function getPlatforms():Array<Platform>
    {
        return this.platforms;
    }
}
