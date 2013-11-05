package ;

class ExampleTest extends bdd.ExampleGroup
{
    private var array:Array<String>;

    override public function beforeEach():Void
    {
        this.array = ['foo'];
    }

    public function example():Void
    {
        extendBeforeEach(function(){
            this.array.push('bar');
        });

        it('should contains bar', function(){
            should.contains('bar', this.array());
        });

        describe('this.array', function(){
            extendBeforeEach(function(){
                this.array.pop();
            });

            it('should not contains bar', function(){
                should.not.contains('bar', this.array);
            });
        });

        extendAfterEach(function(){
            this.array = null;
        });
    }

    public function example_async():Void
    {
        describe('an example for async', function(){
            it('really shoud', function(){
                var asyncTimeout = 1500;
                var callbackWillBeCalled = 500;

                var thatWillBeTrue:Bool = false;
                var asyncFunc = createAsyncBlock(function(?data){ should.be.True(thatWillBeTrue); }, asyncTimeout);

                bdd.munit.Timer.delay( asyncFunc, callbackWillBeCalled);

                thatWillBeTrue = true;
            });
        });
    }
}
