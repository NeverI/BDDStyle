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
        describe('constructor', function(){
            it('should throw when requested platform is empty', function(){
                should.throws(function(){
                    new OpenFLProject(this.parser, []);
                });
            });
        });

        describe('#getPlatforms():Array<Platform>', function(){
            it('should return only the requested platform', function(){
                parsed();

                this.target = new OpenFLProject(this.parser, ['flash', 'linux']);
                this.target.parse('xml');

                verifyPlatforms(['flash', 'linux']);
            });
        });
    }

    private function parsed():Void
    {
        when(this.parser.parse('xml')).thenReturn({
                main:'',
                name: '',
                sources:[],
                runnable:'',
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
