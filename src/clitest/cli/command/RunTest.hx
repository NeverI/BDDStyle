package cli.command;

import mockatoo.Mockatoo.*;
import mockatoo.Mockatoo.Matcher;
import mockatoo.Mockatoo.VerificationMode;

class RunTest extends bdd.ExampleGroup
{
    private var target:cli.command.Run;

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
        this.target = new cli.command.Run(this.args, this.project, this.tools);

        when(this.project.getPlatforms()).thenReturn([ this.platform, this.platform ]);
    }

    public function example():Void
    {
        describe('#run():Void', function(){
            it('should call the project\'s run method with all requested platform', function(){
                this.target.run();

                verify(this.project.run(this.platform), 2);
                verify(this.project.build(this.platform), never);

                should.success();
            });
        });
    }
}
