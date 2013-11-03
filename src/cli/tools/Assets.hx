package cli.tools;

class Assets
{
    private var path:String;
    private var regexp:Map<String, EReg>;

    public function new(path:String)
    {
        this.path = path;
        this.regexp = new Map<String, EReg>();
    }

    public function fill(content:String, ?data:Dynamic):String
    {
        if (data == null ) {
            return content;
        }

        for (fieldName in Reflect.fields(data)) {
            var value:Dynamic = Reflect.field(data, fieldName);

            if (Std.is(value, String)) {
                content = this.replaceString(content, fieldName, value);
            } else if (Std.is(value, Array)) {
                content = this.replaceArray(content, fieldName, value);
            }

        }

        return content;
    }

    private function replaceString(content:String, key:String, value:String):String
    {
        return this.getRegexp(key).replace(content, value);
    }

    private function getRegexp(key:String):EReg
    {
        if (!this.regexp.exists(key)) {
            this.regexp.set(key, new EReg('%'+key+'%', 'g'));
        }

        return this.regexp.get(key);
    }

    private function replaceArray(content:String, key:String, values:Array<String>):String
    {
        var regexp:EReg = this.getRegexp(key);
        var sourceLines:Array<String> = content.split('\n');
        var lines:Array<String> = [];

        for (line in sourceLines) {
            if (!regexp.match(line)) {
                lines.push(line);
                continue;
            }

            for (value in values) {
                lines.push(this.replaceString(line, key, value));
            }
        }

        return lines.join('\n');
    }

    public function get(asset:String, ?data:Dynamic):String
    {
        return this.fill(sys.io.File.getContent(this.path+'/'+asset), data);
    }
}
