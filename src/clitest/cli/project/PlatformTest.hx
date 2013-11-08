package cli.project;

class PlatformTest extends bdd.ExampleGroup
{
    private var target:cli.project.Platform;

    public function example():Void
    {
        describe('main, mainHx, name and compiledPath', function(){
            it('should have getters', function(){
                this.target = new cli.project.Platform({main:'cli.TestMain', name:'swf', sourcePathes:[], compiledPath:'flash.swf'});

                should.be.equal('swf', this.target.name);
                should.be.equal('cli.TestMain', this.target.main);
                should.be.equal('flash.swf', this.target.compiledPath);
                should.be.equal('cli/TestMain.hx', this.target.mainHx);
            });
        });

        describe('getTestPath():String', function(){
            it('should throw an exception if TestMain is not found', function(){
                setupPlatform(['src']);

                should.throws(function(){ target.getTestPath(); }, 'TestMain not found');
            });

            it('should return that path where the TestMain class live', function(){
                setupPlatform(['src', 'src/clitest']);

                should.be.equal('src/clitest', target.getTestPath());
            });
        });

        describe('getSourcePath():String', function(){
            it('should throw an expection if there are no sourcePathes', function(){
                setupPlatform([]);

                should.throws(function(){ target.getTestPath(); }, 'The source pathes are missing');
            });

            it('should return that path where Main class live', function(){
                setupPlatform(['src/clitest', 'src']);

                should.be.equal('src', target.getSourcePath());
            });

            it('should return that path where no TestMain when Main not found', function(){
                setupPlatform(['src/clitest', 'bdd']);

                should.be.equal('bdd', target.getSourcePath());
            });

            it('should return the first path when only the TestMain source present', function(){
                setupPlatform(['src/clitest']);

                should.be.equal('src/clitest', target.getSourcePath());
            });
        });
    }

    private function setupPlatform(sourcePathes:Array<String>):Void
    {
        this.target = new cli.project.Platform({main:'TestMain', name:'swf', sourcePathes:sourcePathes, compiledPath:'flash.swf'});
    }
}
