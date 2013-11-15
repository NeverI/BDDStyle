package cli.project.openfl;

import cli.project.Runnable;

class Compiled implements cli.project.ICompiled
{
    private var args:cli.helper.Args;
    private var platform:cli.project.Platform;

    public function new()
    {
    }

    public function generatePath(platform:String, exportFolder:String):String
    {
        platform = this.translateHaxePlatform(platform);
        exportFolder = exportFolder + '/' + platform + '/bin/TestMain';
        switch(platform) {
            case 'html5': return exportFolder + '.js';
            case 'flash': return exportFolder + '.swf';
        }

        return exportFolder;
    }

    public function translateHaxePlatform(platform:String):String
    {
        switch (platform) {
            case 'cpp': return Sys.systemName().toLowerCase();
            case 'neko': return Sys.systemName().toLowerCase() + ' -neko';
            case 'swf': return 'flash';
            case 'js': return 'html5';
        }

        return platform;
    }

    public function getRunnable(platform:cli.project.Platform, args:cli.helper.Args):Runnable
    {
        this.args = args;
        this.platform = platform;

        switch(platform.name) {
            case 'html5': return this.getJsRunnable();
            case 'flash': return this.getSwfRunnable();
        }

        return { command: '', args:[] };
    }

    private function getJsRunnable():Runnable
    {
        var compiledPath:String = this.platform.compiledPath + '.js';
        var file:String = this.args.has('phantomjs') ? compiledPath : haxe.io.Path.directory(compiledPath) + '/js.html';
        var command:String = '%DEFAULT%';

        if (this.args.has('phantomjs')) {
            command = 'phantomjs';
        }

        return { command: command, args: [ file ] };
    }

    public function getSwfRunnable():Runnable
    {
        var compiledPath:String = this.platform.compiledPath + '.swf';
        var file:String = this.args.has('native') ? compiledPath : haxe.io.Path.directory(compiledPath) + '/swf.html';

        return { command: '%DEFAULT%', args: [ file ] };
    }
}
