package cli.tools;

class AssetsTest extends bdd.ExampleGroup
{
    private var target:cli.tools.Assets;

    override public function beforeEach():Void
    {
        this.target = new cli.tools.Assets('assets');
    }

    public function example():Void
    {
        describe('#fill(content:String, ?data:Dynamic):String', function(){
            it('should return the same content when data is null', function(){
                should.be.equal('foo %bar%', this.target.fill('foo %bar%'));
            });

            it('should replace the %words% with their value', function(){
                should.be.equal('foo foo', this.target.fill('foo %bar%', {bar: 'foo'}));
            });

            it('should replace multiple key across multiple line', function(){
                should.be.equal('foo foo\nfoo\nbar foo', this.target.fill('foo %bar%\nfoo\n%foo% %bar%', {bar: 'foo', foo: 'bar'}));
            });

            it('should create multiple line when the value is array', function(){
                should.be.equal('\tbar bar\n\tbar foo bar', this.target.fill('\tbar %foo%', {foo: ['bar', 'foo bar']}));
            });
        });
    }
}
