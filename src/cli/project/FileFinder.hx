package cli.project;

import cli.helper.Args;

class FileFinder
{
    private var args:Args;
    private var validExtensions:Map<String, String>;
    private var filePath:String;

    public function new(args:Args)
    {
        this.args = args;
        this.filePath = '';

        this.fillValidExtensions();
    }

    private function fillValidExtensions():Void
    {
        this.validExtensions = new Map<String, String>();
        this.validExtensions.set('hxml', 'hxml');
        this.validExtensions.set('xml', 'xml');
    }

    public function get():String
    {
        this.handleCommandLineArgument();

        if (this.filePath == '') {
            this.findFile();
        }

        if (this.filePath == '') {
            throw 'Not found any project file';
        }

        return this.filePath;
    }

    private function handleCommandLineArgument():Void
    {
        if (!this.args.has('f')) {
            return;
        }

        var file = this.args.get('f');

        if (!sys.FileSystem.exists(file)) {
            throw 'Invalid project file: '+ file +' is not exists';
        }

        if (!this.validExtensions.exists(haxe.io.Path.extension(file))) {
            throw 'Invalid project file: '+ file +' is not a hxml or an openfl xml file';
        }

        this.filePath = file;
    }

    private function findFile():Void
    {
        for (ext in this.validExtensions) {
            if (sys.FileSystem.exists(this.args.cwd + '/test.'+ext)) {
                this.filePath = this.args.cwd + '/test.'+ext;
                break;
            }
        }
    }
}
