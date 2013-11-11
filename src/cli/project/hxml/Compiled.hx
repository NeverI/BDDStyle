package cli.project.hxml;

import cli.project.Runnable;

class Compiled implements cli.project.ICompiled
{
    private var args:cli.helper.Args;

    public function new()
    {
    }

    public function generatePath(platform:String, exportFolder:String):String
    {
        switch(platform) {
            case 'js': return exportFolder + '/test.js';
            case 'swf': return exportFolder + '/test.swf';
            case 'neko': return exportFolder + '/test.n';
        }

        return exportFolder + '/' + platform;
    }

    public function getRunnable(platform:cli.project.Platform, args:cli.helper.Args):Runnable
    {
        this.args = args;

        switch(platform.name) {
            case 'neko': return { command: 'neko', args: [platform.compiledPath] };
            case 'php': return { command: 'php', args: [platform.compiledPath + '/index.php'] };
            case 'cpp': return { command: platform.compiledPath + '/' + platform.main, args: [] };
            case 'js': return this.getJsRunnable(platform.compiledPath);
            case 'swf': return this.getSwfRunnable(platform.compiledPath);
        }

        return { command: '', args:[] };
    }

    private function getJsRunnable(compiledPath:String):Runnable
    {
        var file:String = this.args.has('nodejs') || this.args.has('phantomjs') ? compiledPath : haxe.io.Path.directory(compiledPath) + '/js.html';
        var command:String = '%DEFAULT%';

        if (this.args.has('nodejs')) {
            command = 'nodejs';
        } else if (this.args.has('phantomjs')) {
            command = 'phantomjs';
        }

        return { command: command, args: [ file ] };
    }

    private function getSwfRunnable(compiledPath:String):Runnable
    {
        var file:String = this.args.has('native') ? compiledPath : haxe.io.Path.directory(compiledPath) + '/swf.html';

        return { command: '%DEFAULT%', args: [ file ] };
    }
}
