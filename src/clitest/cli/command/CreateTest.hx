package cli.command;

import mockatoo.Mockatoo.*;
import mockatoo.Mockatoo.Matcher;
import mockatoo.Mockatoo.VerificationMode;

class CreateTest extends bdd.ExampleGroup
{
    private var target:cli.command.Create;

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

        this.target = new cli.command.Create(this.args, this.project, this.tools);
    }

    public function example():Void
    {
        describe('#run():Void', function(){
            it('should throw when the first argument after the command is not a valid argument', function(){
                when(this.args.first).thenReturn('');

                should.throws(function(){ this.target.run(); }, 'Invalid class name');
            });

            describe('file creation', function(){
                extendBeforeEach(function(){
                    when(this.platform.getSourcePath()).thenReturn('src');
                    when(this.platform.getTestPath()).thenReturn('src/clitest');
                    when(this.project.getPlatforms()).thenReturn([ this.platform, this.platform ]);
                });

                describe('when the file is not exists', function(){
                    extendBeforeEach(function(){
                        when(this.args.first).thenReturn('foo.bar.Class');
                    });

                    it('should only create once if multiple target has the same source or test path', function(){
                        this.target.run();

                        verify(this.tools.putContent(anyString, anyString), 2);
                        should.success();
                    });

                    it('should create the file and its test file in the proper path', function(){
                        this.target.run();

                        verify(this.tools.putContent('src/foo/bar/Class.hx', anyString), 1);
                        verify(this.tools.putContent('src/clitest/foo/bar/ClassTest.hx', anyString), 1);
                        should.success();
                    });

                    it('should create the file and its test file in the proper path', function(){
                        this.target.run();

                        verify(this.tools.putContent(anyString, 'package foo.bar;\n\nclass Class\n{\n\tpublic function new()\n\t{\n\t}\n}'), 1);
                        verify(this.tools.putContent(anyString, 'package foo.bar;\n\nclass ClassTest extends bdd.ExampleGroup\n{\n\tprivate var target:foo.bar.Class;\n\n\tpublic function example():Void\n\t{\n\t}\n}'), 1);
                        should.success();
                    });
                });

                describe('when the file is exists should ask', function(){
                    extendBeforeEach(function(){
                        when(this.args.first).thenReturn('cli.command.Create');
                    });

                    it('answer is no does not save the file', function(){
                        when(this.tools.askBool(anyString)).thenReturn(false);

                        this.target.run();

                        verify(this.tools.putContent(anyString, anyString), 0);
                        should.success();
                    });

                    it('answer is yes save the file', function(){
                        when(this.tools.askBool(anyString)).thenReturn(true);

                        this.target.run();

                        verify(this.tools.putContent(anyString, anyString), 2);
                        should.success();
                    });
                });
            });
        });
    }
}
