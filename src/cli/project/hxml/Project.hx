package cli.project.hxml;

class Project implements cli.project.IProject
{
    private var platforms:Array<Block>;

    private var parser:Parser;
    private var compiled:Compiled;
    private var process:cli.helper.Process;
    private var requestedPlatforms:Array<String>;

    public function new(parser:Parser, compiled:Compiled, process:cli.helper.Process, requestedPlatforms:Array<String>)
    {
        this.parser = parser;
        this.process = process;
        this.compiled = compiled;
        this.requestedPlatforms = requestedPlatforms;
    }

    public function parse(content:String, path:String=''):Void
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

    private function isRequestedPlatform(block:Block):Bool
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

    public function run(platform:Platform, args:cli.helper.Args):Int
    {
        var runnable:cli.project.Runnable = this.compiled.getRunnable(platform, args);
        if (runnable.command == '%DEFAULT%') {
            this.process.runWithDefault(runnable.args[0]);
            return 0;
        }

        return this.process.run(runnable.command, runnable.args);
    }

    public function build(platform:Platform):Void
    {
        this.process.run('haxe', this.getParametersForPlatform(platform));
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

typedef Block = {
    var parameters:Array<String>;
    var platform:Platform;
}
