package bdd.reporter.helper;

class Printer
{
    #if flash9
        private var textfield: flash.text.TextField;
    #elseif flash
        private var textfield: flash.TextField;
    #elseif js
        private var textfield: js.html.Element;
    #end

    public function new()
    {
        #if (flash9 || mobile)
            textfield = new flash.text.TextField();
            textfield.width = flash.Lib.current.stage.stageWidth;
            textfield.height = flash.Lib.current.stage.stageHeight;
            textfield.wordWrap = true;
            textfield.multiline = true;
            textfield.mouseWheelEnabled = true;
            flash.Lib.current.addChild(textfield);
        #elseif flash
            var root = flash.Lib.current;
            root.createTextField("__tf",1048500,0,0,flash.Stage.width,flash.Stage.height);
            textfield = root.__tf;
            textfield.wordWrap = true;
            textfield.multiline = true;
            textfield.mouseWheelEnabled = true;
        #elseif nodejs
        #elseif js
            if (js.Browser.document == null) {
                return;
            }

            textfield = js.Browser.document.getElementById("haxe:trace");
            if( textfield == null ) {
                textfield = js.Browser.document.createElement('div');
                js.Browser.document.body.appendChild(textfield);
            }
        #end
    }

    public dynamic function print( v : Dynamic ) untyped {
        #if (flash9 || mobile)
            textfield.scrollV += getLineNumber(v);
            textfield.appendText(v);
        #elseif flash
            var s = flash.Boot.__string_rec(v,"");
            textfield.scrollV += getLineNumber(v);
            textfield.text += s;
            while( textfield.textHeight > flash.Stage.height ) {
                var lines = textfield.text.split("\r");
                lines.shift();
                textfield.text = lines.join("\n");
            }
        #elseif js
            this.consoleLog(v);

            if (textfield == null) {
                return;
            }

            var msg = StringTools.htmlEscape(js.Boot.__string_rec(v,"")).split("\n").join("<br/>");
            textfield.innerHTML += msg;
        #else
            Sys.print(v);
        #end
    }

    public function customTrace( v, ?p : haxe.PosInfos ) {
        print(p.fileName+":"+p.lineNumber+": "+Std.string(v)+"\n");
    }

    private function getLineNumber(v:Dynamic):Int
    {
        return Std.string(v).split('\n').length + 1;
    }

    #if js
    private function consoleLog(v:Dynamic):Void
    {
        if (!Std.is(v, String)) {
            untyped console.log(v);
            return;
        }

        var text:String = cast v;

        if (text.lastIndexOf('\n') == text.length - 1) {
            text = text.substring(0, text.length - 1);
        }

        for (line in text.split("\n")) {
            untyped console.log(line);
        }
    }
    #end
}
