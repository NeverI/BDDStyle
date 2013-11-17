package cli.helper;

class Process
{
    public function new()
    {
    }

    public function runWithDefault(runnable:String):Int
    {
        if (Sys.systemName() == 'Linux') {
            return Sys.command('xdg-open', [runnable]);

        } else if (Sys.systemName() == 'Mac') {
            return Sys.command('open', [runnable]);

        } else if (Sys.systemName() == 'Windows') {
            return Sys.command('start', [runnable]);
        }

        return 1;
    }

    public function run(command:String, ?arguments:Array<String>):Int
    {
        return Sys.command(command, arguments != null ? arguments : []);
    }
}
