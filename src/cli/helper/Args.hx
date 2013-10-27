package cli.helper;

import haxe.ds.StringMap;

class Args
{
    private var _command:String;
    private var _params:StringMap<String>;

    public function new(args:Array<String>)
    {
        this._command = this.getCommand(args);
        this._params = this.getParams(args);
    }

    private function getCommand(args:Array<String>):String
    {
        if (args.length == 0 || this.isKey(args[0])) {
            return '';
        }

        return args[0];
    }

    private function isKey(param:String):Bool
    {
        return param.charAt(0) == '-';
    }

    private function getParams(args:Array<String>):StringMap<String>
    {
        var map:StringMap<String> = new StringMap<String>();

        if (this.command == '') {
            return map;
        }

        var i:Int = 1;
        var value:String = '';
        while( i < args.length) {
            if (this.isKey(args[i])) {
                if (i+1 == args.length) {
                    value = '';
                } else {
                    value = args[i+1];
                }
                map.set(args[i].substring(1), value);
                i += 2;
            } else {
                map.set(args[i], args[i]);
                i++;
            }
        }

        return map;
    }

    public var command(get, null):String;
    public function get_command():String
    {
        return this._command;
    }

    public function has(param:String):Bool
    {
        return this._params.exists(param);
    }

    public function get(param:String):String
    {
        return this._params.exists(param) ? this._params.get(param) : '';
    }
}