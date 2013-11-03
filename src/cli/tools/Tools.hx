package cli.tools;

class Tools
{
    private var assets:Assets;
    private var fileCreator:FileCreator;

    public function new(cwd:String)
    {
        this.assets = new Assets(cwd);
        this.fileCreator = new FileCreator();
    }

    public function getAsset(assets:String, ?data:Dynamic):String
    {
        return this.assets.get(assets, data);
    }

    public function fillTemplate(templateContent:String, ?data:Dynamic):String
    {
        return this.assets.fill(templateContent, data);
    }

    public function putContent(path:String, content:String):Void
    {
        this.fileCreator.put(path, content);
    }

    public function getContent(path:String):String
    {
        return sys.io.File.getContent(path);
    }

    public function getFiles(path:String, matcher:String):Array<String>
    {
        var files:Array<String> = [];

        for (entry in sys.FileSystem.readDirectory(path)) {
            entry = path + '/' + entry;
            if (sys.FileSystem.isDirectory(entry)) {
                files.concat(this.getFiles(entry, matcher));
            } else if (new EReg(matcher, '').match(entry)){
                files.push(entry);
            }
        }

        return files;
    }

    public function ask(question:String):String
    {
        Sys.print(question);
        return Sys.stdin().readLine();
    }

    public function askBool(question:String):Bool
    {
        var answer:String = this.ask(question);
        return answer == 'yes' || answer == 'Yes' || answer == 'YES' || answer == 'Y' || answer == 'y';
    }

    public function askArray(question:String):Array<String>
    {
        return this.ask(question).split(',');
    }
}
