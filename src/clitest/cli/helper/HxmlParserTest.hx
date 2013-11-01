package cli.helper;

class HxmlParserTest extends bdd.ExampleGroup
{
    private var target:cli.helper.HxmlParser;
    private var result:Array<cli.project.HxmlProject.HxmlBlock>;

    override public function beforeEach():Void
    {
        this.target = new cli.helper.HxmlParser();
    }

    public function example():Void
    {
        describe('#parse(data:String):Array<HxmlBlock>', function(){
            describe('with incorrect data', function(){
                it('should throw when main not found', function(){
                    should.throws(function(){ parse('-cp src\n-js build/clitest/javascript.js'); }, 'Main entry not found');
                });

                it('should throw when not found any source path', function(){
                    should.throws(function(){ parse('-main TestMain\n-js build/clitest/javascript.js'); }, 'Not found any source path');
                });

                it('should throw when name not found', function(){
                    should.throws(function(){ parse('-main TestMain\n-cp src'); }, 'Unknow platform in the hxml');
                });
            });

            describe('with correct data', function(){
                describe('platform independent data', function(){
                    extendBeforeEach(function(){
                        parse('\n## Javascript\n-main TestMain\n-lib mockatoo\n-cp src\n-cp src/clitest\n-js build/clitest/javascript.js\n');
                    });

                    it('should create one HxmlBlock', function(){
                        should.have.length(1, this.result);
                    });

                    it('should create a Platform with proper main', function(){
                        should.be.equal('TestMain', this.result[0].platform.main);
                    });

                    it('should create a Platform with proper test and source path', function(){
                        should.be.equal('src/clitest', this.result[0].platform.getTestPath());
                        should.be.equal('src', this.result[0].platform.getSourcePath());
                    });
                });

                describe('platform depend data', function(){
                    it('should set name and runnable with neko', function(){
                        parse('-main TestMain\n-cp src\n-neko build/neko.n\n');

                        should.be.equal('neko', this.result[0].platform.name);
                        should.be.equal('build/neko.n', this.result[0].platform.runnable);
                    });

                    it('should set name and runnable with swf', function(){
                        parse('-main TestMain\n-cp src\n-swf build/flash.swf\n');

                        should.be.equal('swf', this.result[0].platform.name);
                        should.be.equal('build/flash.swf', this.result[0].platform.runnable);
                    });

                    it('should set name and runnable with javascript', function(){
                        parse('-main TestMain\n-cp src\n-js build/index.js\n');

                        should.be.equal('js', this.result[0].platform.name);
                        should.be.equal('build/index.js', this.result[0].platform.runnable);
                    });

                    it('should set name and runnable with php', function(){
                        parse('-main TestMain\n-cp src\n-php build/php\n');

                        should.be.equal('php', this.result[0].platform.name);
                        should.be.equal('build/php/index.php', this.result[0].platform.runnable);
                    });

                    it('should set name and runnable with cpp', function(){
                        parse('-main TestMain\n-cp src\n-cpp build/cpp\n');

                        should.be.equal('cpp', this.result[0].platform.name);
                        should.be.equal('build/cpp/TestMain', this.result[0].platform.runnable);
                    });

                    xit('should set name and runnable with java', function(){
                        parse('-main TestMain\n-cp src\n-java build/java\n');

                        should.be.equal('java', this.result[0].platform.name);
                        should.be.equal('build/java/TestMain', this.result[0].platform.runnable);
                    });

                    xit('should set name and runnable with cs', function(){
                        parse('-main TestMain\n-cp src\n-cs build/cs\n');

                        should.be.equal('cs', this.result[0].platform.name);
                        should.be.equal('build/cs/TestMain', this.result[0].platform.runnable);
                    });
                });

                it('should create multiple HxmlBlock if hxml has --next', function(){
                    parse('\n-main First\n-cp src\n-js javascript.js\n--next\n-main Second\n-cp src\n-js javascript.js\n');

                    should.have.length(2, this.result);
                    should.be.equal('First', this.result[0].platform.main);
                    should.be.equal('Second', this.result[1].platform.main);
                });
            });
        });
    }

    private function parse(hxml:String):Void
    {
        this.result = this.target.parse(hxml);
    }
}
