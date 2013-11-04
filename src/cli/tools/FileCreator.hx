package cli.tools;

class FileCreator
{
    public function new()
    {
    }

    public function put(path:String, content:String):Void
    {
        var folder:String = haxe.io.Path.directory(path);
        if (!this.folderExists(folder)) {
            this.createDir(folder);
        }

        sys.io.File.saveContent(path, content);
    }

    private function folderExists(path:String):Bool
    {
        return sys.FileSystem.exists(path);
    }

    public function createDir(path:String):Void
    {
        var folders:Array<String> = path.split('/');
        var current:String = '';

        for (folder in folders) {
            current += folder+'/';
            if (!this.folderExists(current)) {
                sys.FileSystem.createDirectory(current);
            }
        }
    }
}
