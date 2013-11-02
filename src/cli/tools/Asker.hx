package cli.tools;

class Asker
{
    public function new()
    {
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
