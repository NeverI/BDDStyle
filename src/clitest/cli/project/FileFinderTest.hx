package cli.project;

import cli.helper.Args;

import mockatoo.Mockatoo.*;

class FileFinderTest extends bdd.ExampleGroup
{
    private var target:cli.project.FileFinder;
    private var args:Args;

    override public function beforeEach():Void
    {
        this.args = mock(Args);
        this.target = new cli.project.FileFinder(this.args);

        when(this.args.cwd).thenReturn('.');
    }

    public function example():Void
    {
        describe('#get():String', function(){
            describe('explicit project file handling with -f argument', function(){
                describe('should throw when', function(){
                    it('not exists', function(){
                        setupFArgument('foo');

                        should.throws(function(){ this.target.get(); }, 'Invalid project file: foo is not exists');
                    });

                    it('not a valid project file', function(){
                        setupFArgument('README.md');

                        should.throws(function(){ this.target.get(); }, 'Invalid project file: README.md is not a hxml or an openfl xml file');
                    });
                });

                it('should return the argument value', function(){
                    setupFArgument('test.hxml');

                    should.be.equal('test.hxml', this.target.get());
                });
            });

            describe('implicit project filehandling (search in the cwd)', function(){
                it('should return the test.hxml or test.xml', function(){
                    should.be.equal('./test.hxml', this.target.get());
                });
            });

            it('should throw if not found any project file');
        });
    }

    private function setupFArgument(path:String):Void
    {
        when(this.args.get('f')).thenReturn(path);
        when(this.args.has('f')).thenReturn(true);
    }
}
