package cli.tools;

class Tools
{
    private var fileCreator:FileCreator;
    private var asker:Asker;

    public function new()
    {
    }

    public function putContent(path:String, content:String):Void
    {
        if (this.fileCreator == null) {
            this.fileCreator = new FileCreator();
        }

        this.fileCreator.put(path, content);
    }

    public function ask(question:String):String
    {
        return this.getAsker().ask(question);
    }

    private function getAsker():Asker
    {
        if (this.asker == null) {
            this.asker = new Asker();
        }

        return this.asker;
    }

    public function askBool(question:String):Bool
    {
        return this.getAsker().askBool(question);
    }

    public function askArray(question:String):Array<String>
    {
        return this.getAsker().askArray(question);
    }
}
