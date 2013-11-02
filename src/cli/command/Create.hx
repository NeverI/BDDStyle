package cli.command;

import cli.project.Platform;

class Create extends Command
{
    private var created:Map<String, Bool>;
    private var packageName:String;
    private var className:String;
    private var pathPrefix:String;

    override public function printHelp():Void
    {
        trace('');
        trace('create <className> create an empty class file with its own test class');
        trace('                   Source path is one of the pathes which is contains a Main.hx or which is not contains the TestMain.hx or the same as the test path');
        trace('                   Test path is where the the TestMain.hx is exists');
    }

    override public function run():Void
    {
        this.created = new Map<String, Bool>();

        if (this.args.first == '') {
            throw 'Invalid class name';
        }

        this.setPathPrefixAndPackageAndClassName();

        for (platform in this.project.getPlatforms()) {
            this.createClass(platform);
            this.createTestClass(platform);
        }
    }

    private function setPathPrefixAndPackageAndClassName():Void
    {
        var splitted:Array<String> = this.args.first.split('.');

        this.pathPrefix = splitted.join('/');

        this.className = splitted.pop();
        this.packageName = splitted.join('.');
    }

    private function createClass(platform:Platform):Void
    {
        this.createHxFile(platform.getSourcePath() + '/' + this.pathPrefix, this.getClassContent());
    }

    private function createHxFile(path:String, content:String):Void
    {
        path = path+'.hx';

        if (this.created.exists(path)) {
            return;
        }

        if (!sys.FileSystem.exists(path) || this.tools.askBool('File ' + path+' is exists. Do you want overwrite?')) {
            this.tools.putContent(path, content);
        }

        this.created.set(path, true);
    }

    private function getClassContent():String
    {
        return 'package '+this.packageName+';\n\nclass '+this.className+'\n{\n\tpublic function new()\n\t{\n\t}\n}';
    }

    private function createTestClass(platform:Platform):Void
    {
        this.createHxFile(platform.getTestPath() + '/' + this.pathPrefix+'Test', this.getTestClassContent());
    }

    private function getTestClassContent():String
    {
        return 'package '+this.packageName+';\n\nclass '+this.className+'Test extends bdd.ExampleGroup\n{\n\tprivate var target:'+this.getFullClassName()+';\n\n\tpublic function example():Void\n\t{\n\t}\n}';
    }

    private function getFullClassName():String
    {
        return (this.packageName == '' ? '' : this.packageName + '.') + this.className;
    }
}
