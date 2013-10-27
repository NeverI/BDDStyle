#BDDStyle (like RSpec or Jasmine)
##### because old school unit tests are boring :)

It is a working in progress project so it is need lot of and intensive real testing. (It sucks if test failed because of the test framework :D)

I would appreciate any contribution.
(for example how the heck can I embed that regexp.dso to cpp target?)

Feature list (neko, flash, js):

       - nested 'describe' and 'before/afterEach'
       - async blocks inside 'it'-s
       - should.be.eql(this, this)
       - extendable and modular reporting system

Some code more then any other word (especially my english)
TestMain.hx
```haxe
package ;

import numberguesser.*;

class TestMain
{
    static function main(){ new TestMain(); }

    public function new()
    {
        var reporterFactory:bdd.reporter.helper.Factory = new bdd.reporter.helper.Factory();
        // the Dot and Descriptive reporters are interfere with each others
        //reporterFactory.create(bdd.reporter.Dot);
        reporterFactory.create(bdd.reporter.Descriptive);
        reporterFactory.create(bdd.reporter.Error);
        reporterFactory.create(bdd.reporter.Summary);

        var runner = new bdd.Runner();

        runner.add(numberguesser.ThinkerTest);

        runner.run();
    }
}
```

TestClass
```haxe
package numberguesser;

import mockatoo.Mockatoo.*;

class ThinkerTest extends bdd.ExampleGroup
{
    private var target:Thinker;
    private var generator:RandomNumberGenerator;

    override public function beforeEach():Void
    {
        this.generator = mock(RandomNumberGenerator);
        this.target = new Thinker(this.generator);
    }

    public function example_1_Think():Void
    {
        this.describe('#think(min:Int, max:Int):Void', function(){
            this.it('should call the random generator with given values', function(){
                this.target.think(1, 100);

                verify(this.generator.generate(1, 100));

                this.should.success();
            });
        });
    }

    public function example_3_guessAnsAsk():Void
    {
        extendBeforeEach(function(){
            when(generator.generate(0, 20)).thenReturn(10);
            when(generator.generate(0, 10)).thenReturn(5);
        });

        describe('gueesing and asking', function(){
            describe('#guess(value:Int):Int', function(){
                extendBeforeEach(function(){
                    target.think(0, 20);
                });

                it('should return -1 if the value is smaller then own number', function(){
                    should.be.equal(-1, target.guess(5));
                });

                it('should return 1 if the value is bigger then own number', function(){
                    should.be.equal(1, target.guess(20));
                });

                it('should return 1 if the value is equal with own number', function(){
                   should.be.equal(1, target.guess(10));
                });
            });

            // can be disable any desribe or it
            xdescribe('#ask(value:Int):Bool', function(){
                extendBeforeEach(function(){
                    target.think(0, 10);
                });

                it('should return false if the value is not equal with own number', function(){
                    should.be.False(target.ask(10));
                });

                xit('should return true if the value is equal with own number', function(){
                    should.be.True(target.ask(5));
                });
            });
        });
    }

    public function example_2_async():Void
    {
        describe('working with async', function(){
            it('really shoud', function(){
                var asyncTimeout = 1500;
                var callbackWillBeCalled = 500;

                var thatWasFalse:Bool = false;
                var asyncFunc = this.createAsyncBlock(function(?data){ this.should.be.True(thatWasFalse); }, asyncTimeout);

                bdd.munit.Timer.delay( asyncFunc, callbackWillBeCalled);

                thatWasFalse = true;
            });
        });
    }
}
```

output:
```
# Descriptive reporter
numberguesser.ThinkerTest
#think(min:Int, max:Int):Void
    should call the random generator with given values
working with async
    really shoud
gueesing and asking
    #guess(value:Int):Int
        should return -1 if the value is smaller then own number
        should return 1 if the value is bigger then own number
        should return 1 if the value is equal with own number
    #ask(value:Int):Bool
        P: should return false if the value is not equal with own number
        P: should return true if the value is equal with own number

# Summary reporter
7 spec, 5 success, 2 pending, 0 failed, 5 expects.
OK
```

shoulds:
```
should.success();
should.fail();

should.be.True(true);
should.be.False(false);
should.be.equal('foo', 'foo');

should.be.empty([]);
should.be.first('foo', ['foo', 'bar']);
should.be.last('bar', ['foo', 'bar']);
should.be.nth(1, 'foobar', ['foo', 'foobar', 'bar']);

should.be.above(15, 10);
should.be.below(0.9, 1.5);
should.be.whitin(0.9, 1, 1.5);
should.be.floatEqual(1.5, 1.49, 0.015);
should.be.NaN('foo');

should.be.a.number(1);
should.be.a.bool(true);
should.be.a.Null(null);
should.be.a.string('foo');
should.be.a.Function(function(){});

should.be.an.object({});
should.be.an.Enum(Result.Success(null));
should.be.an.instanceOf(TestCase, new TestCase());

should.have.length(2, ['foo', 'bar']);
should.have.property('foo', {'foo': true});
should.have.properties(['foo', 'bar'], {'foo': true, 'bar':true});

should.match('fo\\w', 'foo');
should.startWith('f', 'foo');
should.endWith('o', 'foo');

should.contains('foo', ['foo', 'bar']);

should.throws(function(){ throw 'foo'; });

//and of course everything can be negated.
should.not.fail();
should.not.not.not.not.not.fail(); :D

//checkout the tests for more detailed possibilities
```
