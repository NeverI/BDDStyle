package cli.project.hxml;

import cli.helper.Args;

class Project implements cli.project.IProject
{
    private var platforms:Array<Block>;
    private var requestedPlatforms:Array<String>;

    private var parser:Parser;

    public function new(parser:Parser, requestedPlatforms:Array<String>)
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

    public function run(platform:Platform, args:Args):Int
    {
        switch (platform.name) {
            case 'js':
                return this.runJs(platform.compiledPath, args);
            case 'swf':
                return this.runSwf(platform.compiledPath, args);
            case 'neko':
                return new cli.helper.Process().run('neko', [platform.compiledPath]);
            case 'cpp':
                return new cli.helper.Process().run(platform.compiledPath);
            case 'php':
                return new cli.helper.Process().run('php', [platform.compiledPath]);
        }

        return 1;
    }

    private function runJs(compiledPath:String, args:Args):Int
    {
        if (args.has('nodejs')) {
            return new cli.helper.Process().run('nodejs', [compiledPath]);
        }

        var runnable:String = haxe.io.Path.directory(compiledPath) + '/js.html';
        if (args.has('phantomjs')) {
            return new cli.helper.Process().run('phantomjs', [runnable]);
        }

        return new cli.helper.Process().runWithDefault(runnable);
    }

    private function runSwf(compiledPath:String, args:Args):Int
    {
        if (args.has('native')) {
            return new cli.helper.Process().runWithDefault(compiledPath);
        }

        var runnable:String = haxe.io.Path.directory(compiledPath) + '/swf.html';
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

typedef Block = {
    var parameters:Array<String>;
    var platform:Platform;
}
