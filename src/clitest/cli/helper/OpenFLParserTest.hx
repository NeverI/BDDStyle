package cli.helper;

class OpenFLParserTest extends bdd.ExampleGroup
{
    private var target:OpenFLParser;
    private var platformData:cli.project.Platform.PlatformData;

    override public function beforeEach():Void
    {
        this.target = new OpenFLParser();
    }

    public function example():Void
    {
        describe('#parse(xml:String):PlatfromData', function(){
            describe('with in correct data', function(){
                it('should do nothing when not found main or file', function(){
                    this.platformData = this.target.parse('<?xml version="1.0" encoding="utf-8"?>'+
                        '<project><app path="test/build" /><classpath name="src" /></project>');

                    should.success();
                });

                it('should throw when not found any classpath', function(){
                    should.throws(function(){ this.target.parse('<project><app path="test/build" file="TestMainFile" main="TestMain" /></project>'); }, 'Not found any classpath');
                });
            });

            describe('with correct xml', function(){
                extendBeforeEach(function(){
                    this.platformData = this.target.parse('<?xml version="1.0" encoding="utf-8"?>'+
                        '<project><app path="test/build" file="TestMainFile" main="TestMain" />'+
                        '<classpath name="src" /><classpath name="src/clitest" /></project>');
                });

                it('should leave the name empty', function(){
                    should.be.empty(this.platformData.name);
                });

                it('should set the currect main', function(){
                    should.be.equal('TestMain', this.platformData.main);
                });

                it('should create compiledPath with placeholder for the platform', function(){
                    should.be.equal('test/build/%platform%/TestMainFile%ext%', this.platformData.compiledPath);
                });

                it('should add the source pathes to the sourcePathes', function(){
                    should.contains('src', this.platformData.sourcePathes);
                    should.contains('src/clitest', this.platformData.sourcePathes);
                });
            });
        });
    }
}
