package cli.helper;

import cli.project.HxmlProject.HxmlBlock;
import cli.project.Platform;

class HxmlParser
{
    private var valueGetter:EReg;
    private var keyGetter:EReg;

    private var hxmlBlocks:Array<HxmlBlock>;
    private var hxml:String;
    private var platformData:PlatformData;

    public function new()
    {
        this.valueGetter = ~/-\w+\s(.+)/;
        this.keyGetter = ~/-(\w+)\s.+/;
    }

    public function parse(hxml:String):Array<HxmlBlock>
    {
        this.hxmlBlocks = [];

        this.setupNewPlatformData();

        var lines:Array<String> = hxml.split('\n');
        for (line in lines) {
            if (line.length == 0 || line.charAt(0) == '#') {
                continue;
            }
            if (line.indexOf('--next') == 0) {
                this.createHxmlBlock();
                continue;
            }

            this.process(line);
        }

        this.createHxmlBlock();

        return this.hxmlBlocks;
    }

    private function setupNewPlatformData():Void
    {
        this.platformData = {
            name: '',
            main: '',
            sources: [],
            runnable: ''
        };
    }

    private function createHxmlBlock():Void
    {
        this.validatePlatformData();

        this.hxmlBlocks.push({
            hxml: this.hxml,
            platform: new Platform(this.platformData)
        });

        this.hxml = '';
        this.setupNewPlatformData();
    }

    private function validatePlatformData():Void
    {
        if (this.platformData.main == '') {
            throw 'Main entry not found';
        }

        if (this.platformData.sources.length == 0) {
            throw 'Not found any source path';
        }

        if (this.platformData.name == '') {
            throw 'Unknow platform in the hxml';
        }
    }

    private function process(line:String):Void
    {
        this.hxml += line+' ';

        if (line.indexOf('-main ') == 0) {
            this.platformData.main = this.getValueFromString(line);
        } else if (line.indexOf('-cp ') == 0) {
            this.platformData.sources.push(this.getValueFromString(line));
        } else if (this.isPlatform(line)) {
            this.platformData.name = this.getKeyFromString(line);
            this.platformData.runnable = this.getRunnable(line);
        }
    }

    private function getValueFromString(line:String):String
    {
        return this.valueGetter.match(line) ? this.valueGetter.matched(1) : '';
    }

    private function isPlatform(line:String):Bool
    {
        return
                line.indexOf('-js ') == 0 ||
                line.indexOf('-php ') == 0 ||
                line.indexOf('-swf ') == 0 ||
                line.indexOf('-cpp ') == 0 ||
                line.indexOf('-neko ') == 0;
    }

    private function getKeyFromString(line:String):String
    {
        return this.keyGetter.match(line) ? this.keyGetter.matched(1) : '';
    }

    private function getRunnable(line:String):String
    {
        var value = this.getValueFromString(line);

        if (this.platformData.name == 'php') {
            value += '/index.php';
        } else if (this.platformData.name == 'cpp') {
            value += '/'+this.platformData.main;
        }

        return value;
    }
}
