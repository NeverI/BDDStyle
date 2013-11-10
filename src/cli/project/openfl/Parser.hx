package cli.project.openfl;

import cli.project.Platform;

class Parser
{
    private var platformData:PlatformData;

    public function new()
    {
        this.platformData = {
            main: '',
            name: '',
            sourcePathes: [],
            compiledPath: ''
        }
    }

    public function parse(xmlString:String):PlatformData
    {
        var xml:Xml = Xml.parse(xmlString);

        for (element in xml.firstElement().elements()) {
            this.process(element);
        }

        this.validatePlatformData();

        return this.platformData;
    }

    private function process(node:Xml):Void
    {
        switch (node.nodeName) {
            case 'app':
                this.platformData.main = node.get('main');
                this.platformData.compiledPath = node.get('path')+'/%platform%/'+node.get('file');
            case 'classpath':
                this.platformData.sourcePathes.push(node.get('name'));
        }
    }

    private function validatePlatformData():Void
    {
        if (this.platformData.sourcePathes.length == 0) {
            throw 'Not found any classpath';
        }
    }
}
