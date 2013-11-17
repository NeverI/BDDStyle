package cli.helper;

class Process
{
    public function new()
    {
    }

    public function runWithDefault(runnable:String):Int
    {
        if (Sys.systemName() == 'Linux') {
            return this.run('xdg-open', [runnable]);

        } else if (Sys.systemName() == 'Mac') {
            return this.run('open', [runnable]);

        } else if (Sys.systemName() == 'Windows') {
            return Sys.command('start', [runnable]);
        }

        return 1;
    }

    public function run(command:String, ?arguments:Array<String>):Int
    {
        var process = new sys.io.Process(command, arguments != null ? arguments : []);

        var output = process.stderr.readAll();
        if (output.length != 0) {
            throw output;
        }

        Sys.print(process.stdout.readAll());

        return process.exitCode();
    }
}
