package cli.command;

import mockatoo.Mockatoo.*;
import mockatoo.Mockatoo.Matcher;
import mockatoo.Mockatoo.VerificationMode;

class BuildTest extends bdd.ExampleGroup
{
    private var target:cli.command.Build;

    private var args:cli.helper.Args;
    private var tools:cli.tools.Tools;
    private var platform:cli.project.Platform;
    private var project:cli.project.hxml.Project;

    override public function beforeEach():Void
    {
        this.args = mock(cli.helper.Args);
        this.tools = mock(cli.tools.Tools);
        this.platform = mock(cli.project.Platform);
        this.project = mock(cli.project.hxml.Project);

        when(this.args.cwd).thenReturn('.');
        this.target = new cli.command.Build(this.args, this.project, this.tools);

        when(this.platform.mainHx).thenReturn('TestMain.hx');
        when(this.platform.getTestPath()).thenReturn('src/clitest');
        when(this.project.getPlatforms()).thenReturn([ this.platform, this.platform ]);
    }

    public function example():Void
    {
        describe('#run():Void', function(){
            extendBeforeEach(function(){
                when(this.tools.getContent('src/clitest/TestMain.hx')).thenReturn(this.getSourceTestMain());
                when(this.tools.getFiles('src/clitest', '.+Test.hx$', null)).thenReturn(['src/clitest/cli/command/TestTest.hx', 'src/clitest/cli/helper/ArgsTest.hx', 'src/clitest/cli/CommandFactoryTest.hx']);
            });

            describe('-g argument as test file search regexp', function(){
                it('should search for .+Test.hx$ when is not present', function(){
                    this.target.run();

                    verify(this.tools.getFiles('src/clitest', '.+Test.hx$', null), atLeastOnce);
                    should.success();
                });

                it('should search for valueTest.hx$', function(){
                    when(this.args.has('g')).thenReturn(true);
                    when(this.args.get('g')).thenReturn('(Foo|bar/Bar)');
                    when(this.tools.getFiles('src/clitest', '(Foo|bar/Bar)Test.hx$', null)).thenReturn([]);

                    this.target.run();

                    verify(this.tools.getFiles('src/clitest', '(Foo|bar/Bar)Test.hx$', null), atLeastOnce);
                    should.success();
                });
            });

            it('should convert the current TestMain to template', function() {
                this.target.run();

                verify(this.tools.fillTemplate(this.getTemplatedTestMain(), anyObject), atLeastOnce);
                should.success();
            });

            describe('-r argument set the used reporter', function(){
                it('should use "default" when is not present', function() {
                    this.target.run();

                    verify(this.tools.fillTemplate(this.getTemplatedTestMain(), anyObject), atLeastOnce);
                    should.success();
                });

                it('should use the value', function() {
                    when(this.args.has('r')).thenReturn(true);
                    when(this.args.get('r')).thenReturn('dot');

                    this.target.run();

                    verify(this.tools.fillTemplate(this.getTemplatedTestMain('dot'), anyObject), atLeastOnce);
                    should.success();
                });
            });

            it('should fill the template with the correct class data', function() {
                var objectMatcher = function(data:Dynamic):Bool {
                    var classNames:Array<String> = Reflect.field(data, 'fullClassName');
                    should.contains('cli.command.TestTest', classNames);
                    should.contains('cli.helper.ArgsTest', classNames);
                    should.contains('cli.CommandFactoryTest', classNames);
                    return true;
                }
                this.target.run();

                verify(this.tools.fillTemplate(anyString, customMatcher(objectMatcher)), atLeastOnce);
            });

            it('should override the old TestMain with the new one', function(){
                when(this.tools.fillTemplate(anyString, anyObject)).thenReturn('new content');

                this.target.run();

                verify(this.tools.putContent('src/clitest/TestMain.hx', 'new content'), atLeastOnce);
                should.success();
            });

            it('should build all requested platform', function(){
                this.target.run();

                verify(this.project.build(this.platform), 2);
                verify(this.project.run(this.platform), never);
                should.success();
            });
        });
    }

    private function getSourceTestMain():String
    {
        return '' +
        'package ;\n' +
        '\n' +
        'class TestMain\n' +
        '{\n'+
        '\tstatic function main(){ new TestMain(); }\n'+
        '\n' +
        '\tpublic function new()\n'+
        '\t{\n'+
        '\t\tnew bdd.reporter.helper.Factory().createFromList(reporters.get("default"));\n'+
        '\n' +
        '\t\tvar runner = new bdd.Runner();\n'+
        '\t\t//runner.add(cli.helper.ArgsTest);\n'+
        '\t\trunner.add(cli.helper.HxmlParserTest);\n'+
        '\t\t//runner.add(cli.helper.OpenFLParserTest);\n'+
        '\n' +
        '\t\trunner.add(cli.project.PlatformTest);\n'+
        '\t\t//runner.add(cli.project.hxml.ProjectTest);\n'+
        '\n' +
        '\t\trunner.run();\n'+
        '\t}\n'+
        '}';
    }

    private function getTemplatedTestMain(reporterName:String = 'default'):String
    {
        return '' +
        'package ;\n' +
        '\n' +
        'class TestMain\n' +
        '{\n'+
        '\tstatic function main(){ new TestMain(); }\n'+
        '\n' +
        '\tpublic function new()\n'+
        '\t{\n'+
        "\t\tnew bdd.reporter.helper.Factory().createFromList(reporters.get('"+reporterName+"'));\n"+
        '\n' +
        '\t\tvar runner = new bdd.Runner();\n'+
        '        runner.add(%fullClassName%);\n'+
        '\n' +
        '\t\trunner.run();\n'+
        '\t}\n'+
        '}';
    }
}
