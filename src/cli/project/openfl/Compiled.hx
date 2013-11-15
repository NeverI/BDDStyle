package cli.project.openfl;

import cli.project.Runnable;

class Compiled implements cli.project.ICompiled
{
    private var args:cli.helper.Args;

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
        return { command: '', args:[] };
    }
}
