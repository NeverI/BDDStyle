package cli.helper;

class Process
{
    public function new()
    {
    }

    public function runWithDefault(runnable:String):Void
    {
        if (Sys.systemName() == 'Linux') {
            this.run('xdg-open', [runnable]);

        } else if (Sys.systemName() == 'Mac') {
            this.run('open', [runnable]);

        } else if (Sys.systemName() == 'Windows') {
            this.run('start', [runnable]);
        }
    }

    public function run(command:String, ?arguments:Array<String>):Void
    {
        var process = new sys.io.Process(command, arguments != null ? arguments : []);

        var output = process.stderr.readAll();
        if (output.length != 0) {
            throw output;
        }

        Sys.print(process.stdout.readAll());
    }
}
