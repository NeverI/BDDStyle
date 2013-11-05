package cli.command;

class Init extends Command
{
    private var gruntIsRequired:Bool;

    private var testPath:String;
    private var sourcePath:String;
    private var exportPath:String;
    private var libs:Array<String>;
    private var reportes:Array<String>;
    private var format:String;

    private var projectFileContent:String;
    private var projectTemplateData:Dynamic;

    override public function printHelp():Void
    {
        Sys.println('');
        Sys.println('init   setup wizard');
    }

    override public function run():Void
    {
        this.askGrunt();
        this.colletBasicData();
        this.init();
        this.copyAssets();
    }

    private function askGrunt():Void
    {
        this.gruntIsRequired = this.tools.askBool('Woud you like to use gruntjs for automatic test running?');

        if (!this.gruntIsRequired) {
            return;
        }

        if (!this.gruntIsInstalled()) {
            throw 'You need to install the grunt-cli nodejs package ( http://gruntjs.com )';
        }
    }

    private function gruntIsInstalled():Bool
    {
        var process:sys.io.Process = new sys.io.Process('grunt', ['-V']);
        return process.stderr.readAll().length == 0;
    }

    private function colletBasicData():Void
    {
        this.testPath = this.tools.ask('test path (default test):', 'test');
        this.sourcePath = this.tools.ask('source path (default src):', 'src');
        this.exportPath = this.tools.ask('export path (default build):', 'build');
        this.libs = this.tools.askArray('haxelibs (other then bdd (commasep list)):');
        this.reportes = this.tools.askArray('Available reporters:\n[Descriptive|Dot], Error, Summary, Silent or any own class\nreporters (default Descriptive,Error,Summary):', 'Descriptive,Error,Summary');

        this.libs.unshift('bdd');

        this.projectTemplateData = {
            sources: [this.testPath, this.sourcePath],
            export: this.exportPath,
            libs: this.libs
        }
    }

    private function init():Void
    {
        this.descideFormat();

        if (this.format != 'hxml') {
            this.createProjectFile();
            return;
        }

        this.initHxml();
    }

    private function descideFormat():Void
    {
        this.format = 'hxml';

        for (lib in this.libs) {
            if (lib == 'openfl') {
                this.format = 'openfl';
                break;
            }
        }
    }

    private function createProjectFile():Void
    {
        this.projectFileContent = this.tools.getAsset('assets/'+this.format+'.tpl', this.projectTemplateData);
    }

    private function initHxml():Void
    {
        var platforms:Array<String> = this.tools.askArray('Which platforms would you like to use (default neko)?');
        if (platforms.length == 0) {
            platforms = ['neko'];
        }

        this.projectFileContent = '';
        for (i in 0...platforms.length) {
            Reflect.setField(this.projectTemplateData, 'platform', this.getHxmlExport(platforms[i]));

            this.projectFileContent += this.tools.getAsset('assets/hxml.tpl', this.projectTemplateData);

            if (i != platforms.length - 1) {
                this.projectFileContent += '\n--next\n';
            }
        }

    }

    private function getHxmlExport(platform:String):String
    {
        switch(platform) {
            case 'js': return 'js '+this.exportPath+'/test.js';
            case 'swf': return 'swf '+this.exportPath+'/test.swf';
            case 'neko': return 'neko '+this.exportPath+'/test.n';
            default: return platform+' '+this.exportPath;
        }
    }

    private function copyAssets():Void
    {
        this.tools.createDir(this.sourcePath);
        this.tools.createDir(this.exportPath);

        this.tools.putContent(this.testPath+'/TestMain.hx', this.getTestMainContent());
        this.tools.putContent(this.testPath+'/ExampleTest.hx', this.tools.getAsset('assets/ExampleTest.tpl'));

        this.saveProject();

        this.installGrunt();
    }

    private function getTestMainContent():String
    {
        return this.tools.getAsset('assets/TestMain.tpl', { reporters: this.getReporters() });
    }

    private function getReporters():Array<String>
    {
        var correctedReporters:Array<String> = [];
        for (reporter in this.reportes) {
            if (this.isBuiltinReporter(reporter)) {
                correctedReporters.push('bdd.reporter.' + reporter);
            } else {
                correctedReporters.push(reporter);
            }
        }

        return correctedReporters;
    }

    private function isBuiltinReporter(reporter:String):Bool
    {
        return reporter == 'Descriptive' || reporter == 'Dot' || reporter == 'Error' || reporter == 'Summary' || reporter == 'Silent';
    }

    private function saveProject():Void
    {
        var ext:String = this.format;
        if (this.format == 'openfl') {
            ext = 'xml';
        }

        this.tools.putContent(this.args.cwd+'/test.'+ext, this.projectFileContent);
    }

    private function installGrunt():Void
    {
        if (!this.gruntIsRequired) {
            return;
        }

        this.tools.putContent(this.args.cwd+'/Gruntfile.js', this.getGruntContent());

        Sys.println('grunt modules will be installed: grunt grunt-contrib-watch grunt-exec');
        new cli.helper.Process().run('npm', ['install', 'grunt', 'grunt-contrib-watch', 'grunt-exec']);
    }

    public function getGruntContent():String
    {
        return this.tools.getAsset('assets/Gruntfile.tpl', { test: this.testPath, source: this.sourcePath });
    }
}
