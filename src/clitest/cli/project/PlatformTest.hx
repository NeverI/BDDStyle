package cli.project;

class PlatformTest extends bdd.ExampleGroup
{
    private var target:cli.project.Platform;

    override public function beforeEach():Void
    {
        this.target = new cli.project.Platform();
        this.target.main = 'TestMain';
    }

    public function example():Void
    {
        describe('getTestPath():String', function(){
            it('should throw an exception if TestMain is not found', function(){
                target.setSources(['src']);

                should.throws(function(){ target.getTestPath(); }, 'TestMain not found');
            });

            it('should return that path where the TestMain class live', function(){
                target.setSources(['src', 'src/clitest']);

                should.be.equal('src/clitest', target.getTestPath());
            });
        });

        describe('getSourcePath():String', function(){
            it('should throw an expection if there are no sources', function(){
                should.throws(function(){ target.getTestPath(); }, 'The source pathes are missing');
            });

            it('should return that path where Main class live', function(){
                target.setSources(['src/clitest', 'src']);

                should.be.equal('src', target.getSourcePath());
            });

            it('should return that path where no TestMain when Main not found', function(){
                target.setSources(['src/clitest', 'bdd']);

                should.be.equal('bdd', target.getSourcePath());
            });

            it('should return the first path when only the TestMain source present', function(){
                target.setSources(['src/clitest']);

                should.be.equal('src/clitest', target.getSourcePath());
            });
        });
    }
}