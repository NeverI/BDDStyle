package cli.project.hxml;

import mockatoo.Mockatoo.*;
import cli.project.hxml.Project;

class ProjectTest extends bdd.ExampleGroup
{
    private var process:cli.helper.Process;
    private var target:cli.project.hxml.Project;
    private var parser:cli.project.hxml.Parser;
    private var compiled:cli.project.hxml.Compiled;

    override public function beforeEach():Void
    {
        this.process = mock(cli.helper.Process);
        this.parser = mock(cli.project.hxml.Parser);
        this.compiled = mock(cli.project.hxml.Compiled);
    }

    public function example():Void
    {
        describe('#getPlatforms():Array<Platform>', function(){
            it('should return all platform when the requested platform is empty', function(){
                parsed(['swf', 'cpp']);

                this.target = new Project(this.parser, this.compiled, this.process, []);
                this.target.parse('hxml');

                verifyPlatforms(['swf', 'cpp']);
            });

            it('should return only the requested platform', function(){
                parsed(['swf', 'cpp']);

                this.target = new Project(this.parser, this.compiled, this.process, ['swf']);
                this.target.parse('hxml');

                verifyPlatforms(['swf']);
            });
        });
    }

    private function parsed(platforms:Array<String>):Void
    {
        var blocks:Array<Block> = [];
        for (p in platforms) {
            blocks.push(this.createBlock(p));
        }

        when(this.parser.parse('hxml')).thenReturn(blocks);
    }

    private function createBlock(name:String):Block
    {
        return {
            parameters: [],
            platform: new cli.project.Platform({
                main:'',
                name: name,
                sourcePathes:[],
                compiledPath:'',
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
