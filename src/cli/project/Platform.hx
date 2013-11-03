package cli.project;

class Platform
{
    private var sources:Array<String>;

    public var main(default, null):String;
    public var name(default, null):String;
    public var mainHx(default, null):String;
    public var runnable(default, null):String;

    public function new(data:PlatformData)
    {
        this.main = data.main;
        this.name = data.name;
        this.sources = data.sources;
        this.runnable = data.runnable;
        this.mainHx = this.main.split('.').join('/') + '.hx';
    }

    public function getTestPath():String
    {
        this.checkSources();

        for (path in this.sources) {
            if (sys.FileSystem.exists(path+'/'+this.mainHx)) {
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
            if (!sys.FileSystem.exists(path+'/'+this.mainHx)) {
                return path;
            }
        }

        return this.sources[0];
    }
}


typedef PlatformData = {
    var main:String;
    var name:String;
    var sources:Array<String>;
    var runnable:String;
}
