package numberguesser;

class RandomNumberGeneratorTest extends bdd.ExampleGroup
{
    private var target:RandomNumberGenerator;

    override public function beforeEach():Void
    {
        this.target = new RandomNumberGenerator();
    }

    public function example():Void
    {
        for (i in 0...5) {
            it('should generate a random number int between min and max: #' + i, function(){
                var number:Int = this.target.generate(i-1, i+1);
                should.be.whitin(i-2, i, i+1);
            });
        }
    }
}
