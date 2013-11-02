package cli.project;

import mockatoo.Mockatoo.*;

class OpenFLProjectTest extends bdd.ExampleGroup
{
    private var target:cli.project.OpenFLProject;
    private var parser:cli.helper.OpenFLParser;

    override public function beforeEach():Void
    {
        this.parser = mock(cli.helper.OpenFLParser);
    }

    public function example():Void
    {
        describe('#getPlatforms():Array<Platform>', function(){
            extendBeforeEach(function(){
                when(this.parser.parse('xml')).thenReturn({
                    main:'',
                    name: '',
                    sources:[],
                    runnable:'',
                });
            });

            it('should tranlate the haxe (cpp, neko, swf, js) platforms to openfl targets', function(){
                this.target = new OpenFLProject(this.parser, ['cpp', 'neko', 'swf', 'js']);
                this.target.parse('xml');

                var system:String = Sys.systemName().toLowerCase();
                verifyPlatforms([system, system + ' -neko', 'flash', 'html5']);
            });

            it('should set the default platform to neko if the requested platform is empty', function(){
                this.target = new OpenFLProject(this.parser, []);
                this.target.parse('xml');

                verifyPlatforms([Sys.systemName().toLowerCase() + ' -neko']);
            });

            it('should return only the requested platform', function(){
                this.target = new OpenFLProject(this.parser, ['flash', 'linux']);
                this.target.parse('xml');

                verifyPlatforms(['flash', 'linux']);
            });
        });
    }

    private function verifyPlatforms(expected:Array<String>):Void
    {
        var index = 0;
        for (platform in this.target.getPlatforms()) {
            should.be.equal(expected[index], platform.name);
            index++;
        }
    }
}
