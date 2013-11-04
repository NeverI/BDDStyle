package cli.command;

import mockatoo.Mockatoo.*;
import mockatoo.Mockatoo.Matcher;
import mockatoo.Mockatoo.VerificationMode;

class TestTest extends bdd.ExampleGroup
{
    private var target:cli.command.Test;

    private var args:cli.helper.Args;
    private var tools:cli.tools.Tools;
    private var platform:cli.project.Platform;
    private var project:cli.project.HxmlProject;

    override public function beforeEach():Void
    {
        this.args = mock(cli.helper.Args);
        this.tools = mock(cli.tools.Tools);
        this.platform = mock(cli.project.Platform);
        this.project = mock(cli.project.HxmlProject);

        when(this.args.cwd).thenReturn('.');
        this.target = new cli.command.Test(this.args, this.project, this.tools);

        when(this.platform.mainHx).thenReturn('TestMain.hx');
        when(this.platform.getTestPath()).thenReturn('src/clitest');
        when(this.project.getPlatforms()).thenReturn([ this.platform, this.platform ]);
        when(this.tools.getContent('src/clitest/TestMain.hx')).thenReturn('');
        when(this.tools.getFiles('src/clitest', '.+Test.hx$', null)).thenReturn([]);
    }

    public function example():Void
    {
        describe('#run():Void', function(){
            it('should build & run all requested platform', function(){
                this.target.run();

                verify(this.project.run(this.platform, null), 2);
                verify(this.project.build(this.platform), 2);
                should.success();
            });
        });
    }
}
