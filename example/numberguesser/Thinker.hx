package numberguesser;

class Thinker
{
    private var number:Int;
    private var numberGenerator:RandomNumberGenerator;

    public function new(generator:RandomNumberGenerator)
    {
        this.numberGenerator = generator;
    }

    public function think(min:Int, max:Int):Void
    {
        this.number = this.numberGenerator.generate(min, max);
    }

    public function guess(value:Int):Int
    {
        return value < this.number ? -1 : 1;
    }

    public function ask(value:Int):Bool
    {
        return value == this.number;
    }
}
