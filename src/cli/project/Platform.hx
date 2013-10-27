package cli.project;

class Platform
{
    public var main:String;

    private var sources:Array<String>;
    private var _name:String;
    private var _runnable:String;

    public function new()
    {
        this.sources = [];
    }

    public var name(get, null):String;
    private function get_name():String
    {
        return this._name;
    }

    public var runnable(get, null):String;
    private function get_runnable():String
    {
        return this._runnable;
    }

    public function setSources(sources:Array<String>):Void
    {
        this.sources = sources;
    }

    public function getTestPath():String
    {
        this.checkSources();

        for (path in this.sources) {
            if (sys.FileSystem.exists(path+'/'+this.main+'.hx')) {
                return path;
            }
        }

        throw 'TestMain not found';
    }

    private function checkSources():Void
    {
        if (this.sources.length == 0) {
            throw 'The source pathes are missing';
        }
    }

    public function getSourcePath():String
    {
        this.checkSources();

        for (path in this.sources) {
            if (sys.FileSystem.exists(path+'/Main.hx')) {
                return path;
            }
        }

        for (path in this.sources) {
            if (!sys.FileSystem.exists(path+'/'+this.main+'.hx')) {
                return path;
            }
        }

        return this.sources[0];
    }
}