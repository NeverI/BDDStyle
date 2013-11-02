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
        while( i < this._args.length) {
            if (this.isKey(i)) {
                this.storeKeyValuePair(map, i);
                i += 2;
            } else {
                map.set(this._args[i], this._args[i]);
                i++;
            }
        }

        return map;
    }

    private function storeKeyValuePair(map:StringMap<String>,index:Int):Void
    {
        var value:String = '';

        if (!this.nexIsLast(index)) {
            value = this._args[ index + 1];
        }

        var key:String = this._args[index].substring(1);
        map.set(key, value);
    }

    private function nexIsLast(index:Int):Bool
    {
        return index + 1 == this._args.length;
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
