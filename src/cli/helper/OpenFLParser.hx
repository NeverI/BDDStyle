package cli.helper;

import cli.project.Platform;

class OpenFLParser
{
    private var platformData:PlatformData;

    public function new()
    {
        this.platformData = {
            main: '',
            name: '',
            sources: [],
            runnable: ''
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
                this.platformData.runnable = node.get('path')+'/%platform%/'+node.get('file')+'%ext%';
            case 'classpath':
                this.platformData.sources.push(node.get('name'));
        }
    }

    private function validatePlatformData():Void
    {
        if (this.platformData.sources.length == 0) {
            throw 'Not found any classpath';
        }
    }
}
