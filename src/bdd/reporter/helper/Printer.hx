package bdd.reporter.helper;

class Printer
{
    #if flash9
        private var textfield: flash.text.TextField = null;
    #elseif flash
        private var textfield: flash.TextField = null;
    #end

    public function new()
    {
    }

    public dynamic function print( v : Dynamic ) untyped {
        #if flash9
            if( textfield == null ) {
                textfield = new flash.text.TextField();
                textfield.selectable = false;
                textfield.width = flash.Lib.current.stage.stageWidth;
                textfield.autoSize = flash.text.TextFieldAutoSize.LEFT;
                flash.Lib.current.addChild(textfield);
            }
            textfield.appendText(v);
        #elseif flash
            var root = flash.Lib.current;
            if( textfield == null ) {
                root.createTextField("__tf",1048500,0,0,flash.Stage.width,flash.Stage.height+30);
                textfield = root.__tf;
                textfield.selectable = false;
                textfield.wordWrap = true;
            }
            var s = flash.Boot.__string_rec(v,"");
            textfield.text += s;
            while( textfield.textHeight > flash.Stage.height ) {
                var lines = textfield.text.split("\r");
                lines.shift();
                textfield.text = lines.join("\n");
            }
        #elseif neko
            __dollar__print(v);
        #elseif php
            php.Lib.print(v);
        #elseif cpp
            cpp.Lib.print(v);
        #elseif js
            var msg = StringTools.htmlEscape(js.Boot.__string_rec(v,"")).split("\n").join("<br/>");
            var d = document.getElementById("haxe:trace");
            if( d == null )
                alert("haxe:trace element not found")
            else
                d.innerHTML += msg;
        #elseif cs
            var str:String = v;
            untyped __cs__("System.Console.Write(str)");
        #elseif java
            var str:String = v;
            untyped __java__("java.lang.System.out.print(str)");
        #end
    }

    public function customTrace( v, ?p : haxe.PosInfos ) {
        print(p.fileName+":"+p.lineNumber+": "+Std.string(v)+"\n");
    }
}
