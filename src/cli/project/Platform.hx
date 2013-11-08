package cli.project;

class Platform
{
    private var sourcePathes:Array<String>;

    public var main(default, null):String;
    public var name(default, null):String;
    public var mainHx(default, null):String;
    public var compiledPath(default, null):String;

    public function new(data:PlatformData)
    {
        this.main = data.main;
        this.name = data.name;
        this.sourcePathes = data.sourcePathes;
        this.compiledPath = data.compiledPath;
        this.mainHx = this.main.split('.').join('/') + '.hx';
    }

    public function getTestPath():String
    {
        this.checkSources();

        for (path in this.sourcePathes) {
            if (sys.FileSystem.exists(path+'/'+this.mainHx)) {
                return path;
            }
        }

        throw 'TestMain not found';
    }

    private function checkSources():Void
    {
        if (this.sourcePathes.length == 0) {
            throw 'The source pathes are missing';
        }
    }

    public function getSourcePath():String
    {
        this.checkSources();

        for (path in this.sourcePathes) {
            if (sys.FileSystem.exists(path+'/Main.hx')) {
                return path;
            }
        }

        for (path in this.sourcePathes) {
            if (!sys.FileSystem.exists(path+'/'+this.mainHx)) {
                return path;
            }
        }

        return this.sourcePathes[0];
    }
}


typedef PlatformData = {
    var main:String;
    var name:String;
    var sourcePathes:Array<String>;
    var compiledPath:String;
}
