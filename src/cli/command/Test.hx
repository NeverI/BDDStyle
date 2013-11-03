package cli.command;

class Test extends Command
{
    private var matcher:String;
    private var platform:cli.project.Platform;
    private var cache:Map<String, String>;

    override public function run():Void
    {
        this.cache = new Map<String, String>();
        this.matcher = (this.args.has('g') ? this.args.get('g') : '.+') + 'Test.hx$';

        for (platform in this.project.getPlatforms()) {
            this.platform = platform;

            this.buildTestMain();
            this.project.run(platform);
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
            if (line.indexOf('Runner();') != -1) {
                lines.push(line);
                lines.push('\t\trunner.add(%fullClassName%);');
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
        var mainName:Array<String> = this.platform.main.split('.');
        return this.platform.getTestPath()+'/'+mainName.join('/')+'.hx';
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
}
