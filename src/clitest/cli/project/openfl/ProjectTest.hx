package cli.project.openfl;

import mockatoo.Mockatoo.*;

class ProjectTest extends bdd.ExampleGroup
{
    private var target:cli.project.openfl.Project;
    private var parser:cli.project.openfl.Parser;

    override public function beforeEach():Void
    {
        this.parser = mock(cli.project.openfl.Parser);
    }

    public function example():Void
    {
        describe('#getPlatforms():Array<Platform>', function(){
            extendBeforeEach(function(){
                when(this.parser.parse('xml')).thenReturn({
                    main:'',
                    name: '',
                    sourcePathes:[],
                    compiledPath:'',
                });
            });

            it('should tranlate the haxe (cpp, neko, swf, js) platforms to openfl targets', function(){
                this.target = new Project(this.parser, ['cpp', 'neko', 'swf', 'js']);
                this.target.parse('xml');

                var system:String = Sys.systemName().toLowerCase();
                verifyPlatforms([system, system + ' -neko', 'flash', 'html5']);
            });

            it('should set the default platform to neko if the requested platform is empty', function(){
                this.target = new Project(this.parser, []);
                this.target.parse('xml');

                verifyPlatforms([Sys.systemName().toLowerCase() + ' -neko']);
            });

            it('should return only the requested platform', function(){
                this.target = new Project(this.parser, ['flash', 'linux']);
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
