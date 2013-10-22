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

    public function example_2_guessAnsAsk():Void
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

            describe('#ask(value:Int):Bool', function(){
                extendBeforeEach(function(){
                    target.think(0, 10);
                });

                it('should return false if the value is not equal with own number', function(){
                    should.be.False(target.ask(10));
                });

                it('should return true if the value is equal with own number', function(){
                    should.be.True(target.ask(5));
                });
            });
        });
    }
}
