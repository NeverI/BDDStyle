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

        this.validateRequestedPlatforms();

        if (this.requestedPlatforms.length != 0) {
            this.platforms = this.platforms.filter(this.isRequestedPlatform);
        }
    }

    private function validateRequestedPlatforms():Void
    {
        for (requested in this.requestedPlatforms) {
            var found:Bool = false;
            for (block in this.platforms) {
                if (requested == block.platform.name) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                throw 'Requested ' + requested + ' platform is unavailable';
            }
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

    public function run(platform:Platform):Void
    {
        switch (platform.name) {
            case 'neko':
                this.printProcess(new sys.io.Process('neko', [platform.runnable]));
            case 'cpp':
                this.printProcess(new sys.io.Process(platform.runnable, []));
        }
    }

    private function printProcess(process:sys.io.Process):Void
    {
        var output = process.stderr.readAll();
        if (output.length != 0) {
            throw output;
        }

        Sys.print(process.stdout.readAll());
    }

    public function build(platform:Platform):Void
    {
        this.printProcess(new sys.io.Process('haxe', this.getParametersForPlatform(platform)));
    }

    private function getParametersForPlatform(platform:Platform):Array<String>
    {
        for (block in this.platforms) {
            if (block.platform == platform) {
                return block.parameters;
            }
        }

        throw 'Platform not found';
    }

}

typedef HxmlBlock = {
    var parameters:Array<String>;
    var platform:Platform;
}
