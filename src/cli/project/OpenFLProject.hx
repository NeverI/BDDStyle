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
        if (requestedPlatforms.length == 0) {
            throw 'OpenFL test must has atleast one platform';
        }

        this.parser = parser;
        this.platforms = [];
        this.requestedPlatforms = requestedPlatforms;
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
