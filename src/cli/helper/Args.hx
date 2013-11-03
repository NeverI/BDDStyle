package cli.helper;

import haxe.ds.StringMap;

class Args
{
    private var params:StringMap<String>;
    private var args:Array<String>;

    public var cwd(default, null):String;
    public var command(default, null):String;
    public var first(default, null):String;
    public var second(default, null):String;
    public var third(default, null):String;

    public function new(args:Array<String>)
    {
        this.args = args;
        this.first = '';
        this.second = '';
        this.third = '';

        this.command = this.getCommand();
        this.cwd = this.getCwd();
        this.params = this.getParams();
    }

    private function getCommand():String
    {
        if (this.args.length == 0 || this.isKey(0)) {
            return '';
        }

        return this.args.shift();
    }

    private function isKey(index:Int):Bool
    {
        return this.args[index].charAt(0) == '-';
    }

    private function getCwd():String
    {
        var last:String = this.args[this.args.length - 1];
        var beforeLast:String = this.args[this.args.length - 2];

        if (last != null && (beforeLast == null || !this.isKey(this.args.length - 2)) && sys.FileSystem.exists(last)) {
            return this.args.pop();
        }

        return Sys.getCwd();
    }

    private function getParams():StringMap<String>
    {
        var map:StringMap<String> = new StringMap<String>();

        if (this.command == '') {
            return map;
        }

        var i:Int = 0;
        while( i < this.args.length) {
            if (this.isKey(i)) {
                this.storeKeyValuePair(map, i);
                i += 2;
            } else {
                this.storeSimpleValue(map, i);
                i++;
            }
        }

        return map;
    }

    private function storeKeyValuePair(map:StringMap<String>,index:Int):Void
    {
        var value:String = '';

        if (!this.nextIsLast(index)) {
            value = this.args[ index + 1];
        }

        var key:String = this.args[index].substring(1);
        map.set(key, value);
    }

    private function nextIsLast(index:Int):Bool
    {
        return index + 1 == this.args.length;
    }

    public function storeSimpleValue(map:StringMap<String>, index:Int):Void
    {
        var value:String = this.args[index];

        if (index == 0) {
            this.first = value;
        } else if (index == 1) {
            this.second = value;
        } else if (index == 2) {
            this.third = value;
        }

        map.set(value, value);
    }

    public function has(param:String):Bool
    {
        return this.params.exists(param);
    }

    public function get(param:String):String
    {
        return this.params.exists(param) ? this.params.get(param) : '';
    }
}
