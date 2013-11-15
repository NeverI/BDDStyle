package cli.tools;

class Tools
{
    private var assets:Assets;
    private var fileCreator:FileCreator;
    private var hxmlCompiled:cli.project.hxml.Compiled;
    private var openflCompiled:cli.project.openfl.Compiled;

    public function new(cwd:String)
    {
        this.assets = new Assets(cwd);
        this.fileCreator = new FileCreator();
        this.hxmlCompiled = new cli.project.hxml.Compiled();
        this.openflCompiled = new cli.project.openfl.Compiled();
    }

    public function getAsset(assets:String, ?data:Dynamic):String
    {
        return this.assets.get(assets, data);
    }

    public function fillTemplate(templateContent:String, ?data:Dynamic):String
    {
        return this.assets.fill(templateContent, data);
    }

    public function createDir(path:String):Void
    {
        this.fileCreator.createDir(path);
    }

    public function putContent(path:String, content:String):Void
    {
        this.fileCreator.put(path, content);
    }

    public function getContent(path:String):String
    {
        return sys.io.File.getContent(path);
    }

    public function getFiles(path:String, matcher:String, ?files:Array<String>):Array<String>
    {
        files = files == null ? [] : files;

        for (entry in sys.FileSystem.readDirectory(path)) {
            entry = path + '/' + entry;
            if (sys.FileSystem.isDirectory(entry)) {
                this.getFiles(entry, matcher, files);
            } else if (new EReg(matcher, '').match(entry)){
                files.push(entry);
            }
        }

        return files;
    }

    public function ask(question:String, def:String = ''):String
    {
        Sys.print(question+' ');
        var value = StringTools.trim(Sys.stdin().readLine());
        return value == '' ? def : value;
    }

    public function askBool(question:String, def:String = ''):Bool
    {
        var answer:String = this.ask(question, def);
        return answer == 'yes' || answer == 'Yes' || answer == 'YES' || answer == 'Y' || answer == 'y';
    }

    public function askArray(question:String, def:String = ''):Array<String>
    {
        var answers:Array<String> = this.ask(question, def).split(',');
        var cleared:Array<String> = [];
        for (answer in answers) {
            answer = StringTools.trim(answer);
            if (answer != '') {
                cleared.push(answer);
            }
        }
        return cleared;
    }

    public function askNonEmpty(question:String):String
    {
        var value = this.ask(question);
        if (value == '') {
            Sys.println('Value cannot be empty');
            value = this.askNonEmpty(question);
        }

        return value;
    }

    public function getCompiledPath(format:String, exportPath:String, platform:String):String
    {
        if (format == 'openfl') {
            return this.openflCompiled.generatePath(platform, exportPath);
        }

        return this.hxmlCompiled.generatePath(platform, exportPath);
    }
}
