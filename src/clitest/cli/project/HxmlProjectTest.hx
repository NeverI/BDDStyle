package cli.project;

import mockatoo.Mockatoo.*;
import cli.project.HxmlProject.HxmlBlock;

class HxmlProjectTest extends bdd.ExampleGroup
{
    private var target:cli.project.HxmlProject;
    private var parser:cli.helper.HxmlParser;

    override public function beforeEach():Void
    {
        this.parser = mock(cli.helper.HxmlParser);
    }

    public function example():Void
    {
        describe('#getPlatforms():Array<Platform>', function(){
            it('should return all platform when the requested platform is empty', function(){
                parsed(['swf', 'cpp']);

                this.target = new HxmlProject(this.parser, []);
                this.target.parse('hxml');

                verifyPlatforms(['swf', 'cpp']);
            });

            it('should return only the requested platform', function(){
                parsed(['swf', 'cpp']);

                this.target = new HxmlProject(this.parser, ['swf']);
                this.target.parse('hxml');

                verifyPlatforms(['swf']);
            });
        });
    }

    private function parsed(platforms:Array<String>):Void
    {
        var blocks:Array<HxmlBlock> = [];
        for (p in platforms) {
            blocks.push(this.createHxmlBlock(p));
        }

        when(this.parser.parse('hxml')).thenReturn(blocks);
    }

    private function createHxmlBlock(name:String):HxmlBlock
    {
        return {
            parameters: [],
            platform: new cli.project.Platform({
                main:'',
                name: name,
                sources:[],
                runnable:'',
                })
        }
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
