package cli.project;

import cli.helper.HxmlParser;

class HxmlProject implements IProject
{
    private var platforms:Array<HxmlBlock>;
    private var requestedPlatforms:Array<String>;

    private var parser:HxmlParser;

    public function new(parser:HxmlParser, requestedPlatforms:Array<String>)
    {
        this.parser = parser;
        this.requestedPlatforms = requestedPlatforms;
    }

    public function parse(content:String):Void
    {
        this.platforms = this.parser.parse(content);

        if (this.requestedPlatforms.length != 0) {
            this.platforms = this.platforms.filter(this.isRequestedPlatform);
        }
    }

    private function isRequestedPlatform(block:HxmlBlock):Bool
    {
        var platfromName:String = block.platform.name;
        for (requestedPlatformName in this.requestedPlatforms) {
            if (requestedPlatformName == platfromName) {
                return true;
            }
        }

        return false;
    }

    public function getPlatforms():Array<Platform>
    {
        var platforms:Array<Platform> = [];
        for (block in this.platforms) {
            platforms.push(block.platform);
        }
        return platforms;
    }
}

typedef HxmlBlock = {
    var hxml:String;
    var platform:Platform;
}
