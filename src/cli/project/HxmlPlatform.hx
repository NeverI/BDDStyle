package cli.project;

class HxmlPlatform extends Platform
{
    private var hxml:String;
    private var valueGetter:EReg;

    public function new()
    {
        super();

        this.valueGetter = ~/-\w+\s(.+)/;
    }

    public function parse(hxml:String):Void
    {
        this.hxml = hxml;

        var lines:Array<String> = hxml.split('\n');
        for (line in lines) {
            if (line.length == 0 || line.charAt(0) == '#') {
                continue;
            }
            this.processLine(line);
        }
    }

    private function processLine(line:String):Void
    {
        if (line.indexOf('-main') == 0) {
            this.main = this.getValueFromString(line);
        } else if (line.indexOf('-cp') == 0) {
            this.sources.push(this.getValueFromString(line));
        }
    }

    private function getValueFromString(line:String):String
    {
        return this.valueGetter.match(line) ? this.valueGetter.matched(1) : '';
    }

}