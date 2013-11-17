package cli.command;

class Init extends Command
{
    private var gruntIsRequired:Bool;

    private var testPath:String;
    private var sourcePath:String;
    private var exportPath:String;
    private var libs:Array<String>;
    private var gruntPlatforms:Array<String>;
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
        this.checkPhantomJs();
        this.copyAssets();

        Sys.println('done.');
    }

    private function askGrunt():Void
    {
        this.gruntIsRequired = this.tools.askBool('Woud you like to use gruntjs as automatic/colorizer runner?');

        if (!this.gruntIsRequired) {
            return;
        }

        if (!this.isInstalled('grunt')) {
            throw 'You need to install the grunt-cli nodejs package ( http://gruntjs.com )';
        }
    }

    private function isInstalled(name:String):Bool
    {
        var process:sys.io.Process = new sys.io.Process(name, ['--version']);
        return process.stderr.readAll().length == 0;
    }

    private function colletBasicData():Void
    {
        this.testPath = this.tools.ask('test path (default test):', 'test');
        this.sourcePath = this.tools.ask('source path (default src):', 'src');
        this.exportPath = this.tools.ask('export path (default build):', 'build');
        this.libs = this.tools.askArray('haxelibs (other then bdd (commasep list)):');

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

        if (this.format == 'openfl') {
            this.initOpenFL();
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

    private function initOpenFL():Void
    {
        this.gruntPlatforms = ['cpp', 'neko', 'phantomjs', 'swf'];
        this.createProjectFile();
    }

    private function createProjectFile():Void
    {
        this.projectFileContent = this.tools.getAsset('assets/'+this.format+'.tpl', this.projectTemplateData);
    }

    private function initHxml():Void
    {
        var platforms:Array<String> = this.tools.askArray('Which platforms would you like to use (default neko)?', 'neko');

        this.gruntPlatforms = [];
        this.projectFileContent = '';
        for (i in 0...platforms.length) {
            Reflect.setField(this.projectTemplateData, 'platform', this.getHxmlCompiledPath(platforms[i]));

            this.projectFileContent += this.tools.getAsset('assets/hxml.tpl', this.projectTemplateData);

            if (i != platforms.length - 1) {
                this.projectFileContent += '\n--next\n\n';
            }

            this.gruntPlatforms.push(this.convertToGruntPlatform(platforms[i]));
        }

    }

    private function getHxmlCompiledPath(platform:String):String
    {
        return platform + ' ' + this.tools.getCompiledPath('hxml', this.exportPath, platform);
    }

    private function convertToGruntPlatform(platform:String):String
    {
        switch(platform) {
            case 'js':
                for (lib in this.libs)
                    if (lib == 'nodejs')
                        return 'nodejs';
                return 'phantomjs';
            default:
                return platform;
        }
    }

    private function checkPhantomJs():Void
    {
        var isRequested:Bool = false;
        for (platform in this.gruntPlatforms) {
            if (platform == 'phantomjs') {
                isRequested = true;
                break;
            }
        }

        if (!isRequested) {
            return;
        }

        if (!this.isInstalled('phantomjs')) {
            Sys.println('\nDo you know phantomjs? If you install it you can run your javascript with a headless browser.\n');
        }
    }

    private function copyAssets():Void
    {
        this.tools.createDir(this.sourcePath);
        this.tools.createDir(this.exportPath);

        this.copySourceFiles();
        this.copyHtmls();
        this.saveProject();
        this.installGrunt();
    }

    private function copySourceFiles():Void
    {
        this.tools.putContent(this.testPath+'/TestMain.hx', this.tools.getAsset('assets/TestMain.tpl'));
        this.tools.putContent(this.testPath+'/ExampleTest.hx', this.tools.getAsset('assets/ExampleTest.tpl'));
    }

    private function copyHtmls():Void
    {
        var swf:String = '';
        var js:String = '';
        var liveReload:String = this.gruntIsRequired ? '<script src="http://localhost:35729/livereload.js"></script>' : '';

        for (platform in this.gruntPlatforms) {
            var runnable:String = this.tools.getCompiledPath(this.format, this.exportPath, platform == 'phantomjs' ? 'js' : platform);
            var directory:String = haxe.io.Path.directory(runnable);
            runnable = haxe.io.Path.withoutDirectory(runnable);
            switch(platform) {
                case 'swf':
                    swf = runnable;
                    this.tools.putContent(
                        directory + '/swf.html',
                        this.tools.getAsset('assets/swf_html.tpl', {swf: runnable, liveReload: liveReload })
                    );
                case 'phantomjs':
                    js = runnable;
                    this.tools.putContent(
                        directory + '/js.html',
                        this.tools.getAsset('assets/js_html.tpl', {js: runnable, liveReload: liveReload})
                    );
            }
        }

        if (swf != '' && js != '') {
            this.tools.putContent(
                directory + '/swf_js.html',
                this.tools.getAsset('assets/swf_js_html.tpl', {js: js, swf: swf, liveReload: liveReload})
            );
        }
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

        Sys.println('grunt modules will be installed: grunt grunt-contrib-watch grunt-exec tiny-lr');
        new cli.helper.Process().run('npm', ['install', 'grunt', 'grunt-contrib-watch', 'grunt-exec', 'tiny-lr']);
    }

    public function getGruntContent():String
    {
        return this.tools.getAsset('assets/Gruntfile.tpl', {
                test: this.testPath,
                source: this.sourcePath,
                platforms: haxe.Json.stringify(this.gruntPlatforms)
            });
    }
}
