package cli.command;

class Build extends Command
{
    private var matcher:String;
    private var platform:cli.project.Platform;
    private var cache:Map<String, String>;

    override public function printHelp():Void
    {
        Sys.println('');
        Sys.println('build [-g regexp] [-r reporter]');
        Sys.println('                 search for *Test.hx in the test path and build it');
        Sys.println('                 -g it will build only the matching *Test.hx files');
        Sys.println('                 -r reporter list key from your TestMain.hx');
        Sys.println('                    when not specified the default used');
    }

    override public function run():Void
    {
        this.cache = new Map<String, String>();
        this.matcher = (this.args.has('g') ? this.args.get('g') : '.+') + 'Test.hx$';

        for (platform in this.project.getPlatforms()) {
            this.platform = platform;

            this.buildTestMain();
            this.processPlatform();
        }
    }

    private function buildTestMain():Void
    {
        var testPath:String = this.platform.getTestPath();

        if (!this.cache.exists(testPath)) {
            var testMainContent:String = this.tools.fillTemplate(this.getTestMainTemplate(), {fullClassName: this.getClassList()});
            this.cache.set(testPath, testMainContent);
        }

        this.tools.putContent(this.getTestMainPath(), this.cache.get(testPath));
    }

    private function getTestMainTemplate():String
    {
        var sourceLines:Array<String> = this.tools.getContent(this.getTestMainPath()).split('\n');
        var lines:Array<String> = [];

        var needToStore:Bool = true;

        for (line in sourceLines) {
            if (line.indexOf('.createFromList(reporters.get(') != -1) {
                var reporter:String = this.args.has('r') ? this.args.get('r') : 'default';
                line = ~/reporters.get\(['|"](.+)['|"]\)/.replace(line, "reporters.get('"+reporter+"')");
            } else if (line.indexOf('Runner();') != -1) {
                lines.push(line);
                lines.push('        runner.add(%fullClassName%);');
                needToStore = false;
            } else if (line.indexOf('runner.run();') != -1) {
                lines.push('');
                needToStore = true;
            }

            if (needToStore) {
                lines.push(line);
            }
        }

        return lines.join('\n');
    }

    private function getTestMainPath():String
    {
        return this.platform.getTestPath()+'/'+this.platform.mainHx;
    }

    private function getClassList():Array<String>
    {
        var classNameStart:Int = this.platform.getTestPath().length + 1;
        var files:Array<String> = this.tools.getFiles(this.platform.getTestPath(), this.matcher);
        var classes:Array<String> = [];

        for (path in files) {
            var classPath:String = path.substring(classNameStart);
            var className:String = classPath.substr(0, classPath.length - 3);

            classes.push(className.split('/').join('.'));
        }

        return classes;
    }

    private function processPlatform():Void
    {
        this.project.build(this.platform);
    }
}
