package cli.helper;

import haxe.ds.StringMap;

class Args
{
    private var _cwd:String;
    private var _command:String;
    private var _params:StringMap<String>;

    private var _args:Array<String>;

    public function new(args:Array<String>)
    {
        this._args = args;
        this._cwd = this.getCwd();
        this._command = this.getCommand();
        this._params = this.getParams();
    }

    private function getCwd():String
    {
        if (this._args.length == 0 || !sys.FileSystem.exists(this._args[0])) {
            return Sys.getCwd();
        }

        return this._args.shift();
    }

    private function getCommand():String
    {
        if (this._args.length == 0 || this.isKey(0)) {
            return '';
        }

        return this._args.shift();
    }

    private function isKey(index:Int):Bool
    {
        return this._args[index].charAt(0) == '-';
    }

    private function getParams():StringMap<String>
    {
        var map:StringMap<String> = new StringMap<String>();

        if (this.command == '') {
            return map;
        }

        var i:Int = 0;
        var value:String = '';
        while( i < this._args.length) {
            if (this.isKey(i)) {
                if (i+1 == this._args.length) {
                    value = '';
                } else {
                    value = this._args[i+1];
                }
                map.set(this._args[i].substring(1), value);
                i += 2;
            } else {
                map.set(this._args[i], this._args[i]);
                i++;
            }
        }

        return map;
    }

    public var cwd(get, null):String;
    public function get_cwd():String
    {
        return this._cwd;
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
