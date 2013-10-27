package cli.project;

class HxmlPlatformTest extends bdd.ExampleGroup
{
    private var target:cli.project.HxmlPlatform;

    override public function beforeEach():Void
    {
        this.target = new cli.project.HxmlPlatform();
    }

    public function example():Void
    {
        describe('#parse(data:String):Void', function(){
            extendBeforeEach(function(){
                this.target.parse('\n## Neko\n-main TestMain\n-lib mockatoo\n-cp src\n-cp src/clitest\n-js build/clitest/neko.n\n');
            });

            it('should set the main', function(){
                should.be.equal('TestMain', this.target.main);
            });

            it('should set the proper test and source path', function(){
                should.be.equal('src/clitest', this.target.getTestPath());
                should.be.equal('src', this.target.getSourcePath());
            });

            it('should set the name and runnable based on the platform');
        });
    }
}