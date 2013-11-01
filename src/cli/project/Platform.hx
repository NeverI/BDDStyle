package cli.project;

class Platform
{
    private var _main:String;
    private var _sources:Array<String>;
    private var _name:String;
    private var _runnable:String;

    public function new(data:PlatformData)
    {
        this._main = data.main;
        this._name = data.name;
        this._sources = data.sources;
        this._runnable = data.runnable;
    }

    public var main(get, null):String;
    private function get_main():String
    {
        return this._main;
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

    public function getTestPath():String
    {
        this.checkSources();

        for (path in this._sources) {
            if (sys.FileSystem.exists(path+'/'+this.main+'.hx')) {
                return path;
            }
        }

        throw 'TestMain not found';
    }

    private function checkSources():Void
    {
        if (this._sources.length == 0) {
            throw 'The source pathes are missing';
        }
    }

    public function getSourcePath():String
    {
        this.checkSources();

        for (path in this._sources) {
            if (sys.FileSystem.exists(path+'/Main.hx')) {
                return path;
            }
        }

        for (path in this._sources) {
            if (!sys.FileSystem.exists(path+'/'+this.main+'.hx')) {
                return path;
            }
        }

        return this._sources[0];
    }
}


typedef PlatformData = {
    var main:String;
    var name:String;
    var sources:Array<String>;
    var runnable:String;
}
