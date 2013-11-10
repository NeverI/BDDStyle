package cli.project.hxml;

import mockatoo.Mockatoo.*;

class CompiledTest extends bdd.ExampleGroup
{
    private var target:cli.project.hxml.Compiled;
    private var platform:cli.project.Platform;
    private var args:cli.helper.Args;

    override public function beforeEach():Void
    {
        this.target = new cli.project.hxml.Compiled();
    }

    public function example():Void
    {
        describe('#generatePath(platform:String, exportFolder:String):String', function(){
            describe('explicit compiled file path', function(){
                it('should be exportFolder + test.js', function(){
                    should.be.equal('src/test.js', this.target.generatePath('js', 'src'));
                });

                it('should be exportFolder + test.swf', function(){
                    should.be.equal('src/test.swf', this.target.generatePath('swf', 'src'));
                });

                it('should be exportFolder + test.n', function(){
                    should.be.equal('src/test.n', this.target.generatePath('neko', 'src'));
                });
            });

            describe('implicit compiled path', function(){
                it('should be exportFolder + php', function(){
                    should.be.equal('src/php', this.target.generatePath('php', 'src'));
                });

                it('should be exportFolder + cpp', function(){
                    should.be.equal('src/cpp', this.target.generatePath('cpp', 'src'));
                });

                it('should be exportFolder + java', function(){
                    should.be.equal('src/java', this.target.generatePath('java', 'src'));
                });

                it('should be exportFolder + cs', function(){
                    should.be.equal('src/cs', this.target.generatePath('cs', 'src'));
                });
            });
        });

        describe('#getRunnable(platform:cli.project.Platform):cli.project.Runnable', function(){
            extendBeforeEach(function(){
                this.platform = mock(cli.project.Platform);
            });

            it('should return {command:neko, args: [compiledPath]} when platform is neko', function(){
                setupPlatform('neko', 'build/test.n');
                verifyRunnable('neko', ['build/test.n']);
            });

            it('should return {command:php, args: [compiledPath + index.php]} when platform is php', function(){
                setupPlatform('php', 'build/php');
                verifyRunnable('php', ['build/php/index.php']);
            });

            it('should return {command:platformMain, args: []} when platform is cpp', function(){
                setupPlatform('cpp', 'build/cpp', 'TestMain');
                verifyRunnable('build/cpp/TestMain', []);
            });

            describe('javascript platform', function(){
                extendBeforeEach(function(){
                    this.args = mock(cli.helper.Args);
                    setupPlatform('js', 'build/test.js');
                });

                it('should return {command:%DEFAULT%, args: [compiledPath changed to js.html ]}', function(){
                    verifyRunnable('%DEFAULT%', ['build/js.html']);
                });

                it('should return {command:phantomjs, args: [compiledPath changed to js.html ]} when phantomjs argument is present', function(){
                    when(this.args.has('phantomjs')).thenReturn(true);

                    verifyRunnable('phantomjs', ['build/js.html']);
                });

                it('should return {command:nodejs, args: [compiledPath]} when nodejs argument is present', function(){
                    when(this.args.has('nodejs')).thenReturn(true);

                    verifyRunnable('nodejs', ['build/test.js']);
                });
            });

            describe('flash platform', function(){
                extendBeforeEach(function(){
                    this.args = mock(cli.helper.Args);
                    setupPlatform('swf', 'build/test.swf');
                });

                it('should return {command:%DEFAULT%, args: [compiledPath changed to swf.html ]}', function(){
                    verifyRunnable('%DEFAULT%', ['build/swf.html']);
                });

                it('should return {command:%DEFAULT%, args: [compiledPath]} when native argument is present', function(){
                    verifyRunnable('%DEFAULT%', ['build/swf.html']);
                });
            });

            xit('should works with cs');
            xit('should works with java');
        });
    }

    override public function afterEach():Void
    {
        this.args = null;
    }

    private function setupPlatform(name:String, compiledPath:String, main:String = 'TestMain'):Void
    {
        when(this.platform.name).thenReturn(name);
        when(this.platform.compiledPath).thenReturn(compiledPath);
        when(this.platform.main).thenReturn(main);
    }

    private function verifyRunnable(command:String, args:Array<String>):Void
    {
        var runnable:Runnable = this.target.getRunnable(this.platform, this.args);

        should.be.equal(command, runnable.command);
        should.have.length(args.length, runnable.args);

        for (i in 0...args.length) {
            should.be.equal(args[i], runnable.args[i]);
        }
    }
}
