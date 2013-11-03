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

        when(this.platform.main).thenReturn('TestMain');
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

            it('should search for *Test.hx when -g argument is not present', function(){
                this.target.run();

                verify(this.tools.getFiles('src/clitest', '.+Test.hx$', null), atLeastOnce);
                should.success();
            });

            it('should search for argument value plus Test.hx', function(){
                when(this.args.has('g')).thenReturn(true);
                when(this.args.get('g')).thenReturn('(Foo|bar/Bar)');
                when(this.tools.getFiles('src/clitest', '(Foo|bar/Bar)Test.hx$', null)).thenReturn([]);

                this.target.run();

                verify(this.tools.getFiles('src/clitest', '(Foo|bar/Bar)Test.hx$', null), atLeastOnce);
                should.success();
            });

            it('should convert the current TestMain to template', function() {
                this.target.run();

                verify(this.tools.fillTemplate(this.getTemplatedTestMain(), anyObject), atLeastOnce);
                should.success();
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

            it('should run with all requested platform', function(){
                this.target.run();

                verify(this.project.run(this.platform), 2);
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
        '\t\tvar reporterFactory:bdd.reporter.helper.Factory = new bdd.reporter.helper.Factory();\n'+
        '\t\treporterFactory.create(bdd.reporter.Descriptive);\n'+
        '\n' +
        '\t\tvar runner = new bdd.Runner();\n'+
        '\t\t//runner.add(cli.helper.ArgsTest);\n'+
        '\t\trunner.add(cli.helper.HxmlParserTest);\n'+
        '\t\t//runner.add(cli.helper.OpenFLParserTest);\n'+
        '\n' +
        '\t\trunner.add(cli.project.PlatformTest);\n'+
        '\t\t//runner.add(cli.project.HxmlProjectTest);\n'+
        '\n' +
        '\t\trunner.run();\n'+
        '\t}\n'+
        '}';
    }

    private function getTemplatedTestMain():String
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
        '\t\tvar reporterFactory:bdd.reporter.helper.Factory = new bdd.reporter.helper.Factory();\n'+
        '\t\treporterFactory.create(bdd.reporter.Descriptive);\n'+
        '\n' +
        '\t\tvar runner = new bdd.Runner();\n'+
        '\t\trunner.add(%fullClassName%);\n'+
        '\n' +
        '\t\trunner.run();\n'+
        '\t}\n'+
        '}';
    }
}
