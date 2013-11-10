package cli.project.openfl;

import mockatoo.Mockatoo.*;

class ProjectTest extends bdd.ExampleGroup
{
    private var process:cli.helper.Process;
    private var target:cli.project.openfl.Project;
    private var parser:cli.project.openfl.Parser;
    private var compiled:cli.project.openfl.Compiled;

    override public function beforeEach():Void
    {
        this.process = mock(cli.helper.Process);
        this.parser = mock(cli.project.openfl.Parser);
        this.compiled = mock(cli.project.openfl.Compiled);
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
                this.target = new Project(this.parser, this.compiled, this.process, ['cpp', 'neko', 'swf', 'js']);
                this.target.parse('xml');

                var system:String = Sys.systemName().toLowerCase();
                verifyPlatforms([system, system + ' -neko', 'flash', 'html5']);
            });

            it('should set the default platform to neko if the requested platform is empty', function(){
                this.target = new Project(this.parser, this.compiled, this.process, []);
                this.target.parse('xml');

                verifyPlatforms([Sys.systemName().toLowerCase() + ' -neko']);
            });

            it('should return only the requested platform', function(){
                this.target = new Project(this.parser, this.compiled, this.process, ['flash', 'linux']);
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
