package cli.project;

class FactoryTest extends bdd.ExampleGroup
{
    private var target:cli.project.Factory;

    override public function beforeEach():Void
    {
        this.target = new cli.project.Factory();
    }

    public function example():Void
    {
        describe('#create(filePath:String):IProject', function(){
            it('should return HxmlProject when file is .hxml', function(){
                var project = this.target.create('test.hxml', []);

                should.be.an.instanceOf(cli.project.hxml.Project, project);
            });

            it('should return OpenFLProject when file is .xml', function(){
                var project = this.target.create('test.xml', ['flash']);

                should.be.an.instanceOf(cli.project.openfl.Project, project);
            });

            it('should throw when the file is none of these', function(){
                should.throws(function(){ this.target.create('foo', []); });
            });
        });
    }
}
