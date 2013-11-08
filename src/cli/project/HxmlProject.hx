package cli.project;

import cli.helper.Args;
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

    public function run(platform:Platform, args:Args):Int
    {
        switch (platform.name) {
            case 'js':
                return this.runJs(platform.runnable, args);
            case 'swf':
                return this.runSwf(platform.runnable, args);
            case 'neko':
                return new cli.helper.Process().run('neko', [platform.runnable]);
            case 'cpp':
                return new cli.helper.Process().run(platform.runnable);
            case 'php':
                return new cli.helper.Process().run('php', [platform.runnable]);
        }

        return 1;
    }

    private function runJs(runnable:String, args:Args):Int
    {
        if (args.has('nodejs')) {
            return new cli.helper.Process().run('nodejs', [runnable]);
        }

        if (args.has('phantomjs')) {
            runnable = haxe.io.Path.directory(runnable) + '/phatom.html';
            return new cli.helper.Process().run('phantomjs', [runnable]);
        }

        runnable = haxe.io.Path.directory(runnable) + '/js.html';
        return new cli.helper.Process().runWithDefault(runnable);
    }

    private function runSwf(runnable:String, args:Args):Int
    {
        if (args.has('native')) {
            return new cli.helper.Process().runWithDefault(runnable);
        }

        runnable = haxe.io.Path.directory(runnable) + '/swf.html';
        return new cli.helper.Process().runWithDefault(runnable);
    }

    public function build(platform:Platform):Void
    {
        new cli.helper.Process().run('haxe', this.getParametersForPlatform(platform));
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
