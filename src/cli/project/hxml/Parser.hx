package cli.project.hxml;

import cli.project.hxml.Project.Block;
import cli.project.Platform;

class Parser
{
    private var valueGetter:EReg;
    private var keyGetter:EReg;

    private var blocks:Array<Block>;
    private var parameters:Array<String>;
    private var platformData:PlatformData;

    public function new()
    {
        this.parameters = [];
        this.valueGetter = ~/-\w+\s(.+)/;
        this.keyGetter = ~/-(\w+)\s.+/;
    }

    public function parse(hxml:String):Array<Block>
    {
        this.blocks = [];

        this.setupNewPlatformData();

        var lines:Array<String> = hxml.split('\n');
        for (line in lines) {
            if (line.length == 0 || line.charAt(0) == '#') {
                continue;
            }
            if (line.indexOf('--next') == 0) {
                this.createBlock();
                continue;
            }

            this.process(line);
        }

        this.createBlock();

        return this.blocks;
    }

    private function setupNewPlatformData():Void
    {
        this.platformData = {
            name: '',
            main: '',
            sourcePathes: [],
            compiledPath: ''
        };
    }

    private function createBlock():Void
    {
        this.validatePlatformData();

        this.blocks.push({
            parameters: this.parameters,
            platform: new Platform(this.platformData)
        });

        this.parameters = [];
        this.setupNewPlatformData();
    }

    private function validatePlatformData():Void
    {
        if (this.platformData.main == '') {
            throw 'Main entry not found';
        }

        if (this.platformData.sourcePathes.length == 0) {
            throw 'Not found any source path';
        }

        if (this.platformData.name == '') {
            throw 'Unknow platform in the hxml';
        }
    }

    private function process(line:String):Void
    {
        this.parameters = this.parameters.concat(line.split(' '));

        if (line.indexOf('-main ') == 0) {
            this.platformData.main = this.getValueFromString(line);
        } else if (line.indexOf('-cp ') == 0) {
            this.platformData.sourcePathes.push(this.getValueFromString(line));
        } else if (this.isPlatform(line)) {
            this.platformData.name = this.getKeyFromString(line);
            this.platformData.compiledPath = this.getCompiledPath(line);
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

    private function getCompiledPath(line:String):String
    {
        var value = this.getValueFromString(line);

        if (this.platformData.name == 'php') {
            value += '/index.php';
        } else if (this.platformData.name == 'cpp') {
            value += '/'+this.platformData.main;

            if (Sys.systemName() == 'Windows') {
                value += '.exe';
            }
        }

        return value;
    }
}
