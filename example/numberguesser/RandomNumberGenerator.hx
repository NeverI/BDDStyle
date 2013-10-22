package numberguesser;

class RandomNumberGenerator
{
    public function new()
    {
    }

    public function generate(min:Int, max:Int):Int
    {
        return Math.floor(min + (Math.random() * (max - min)));
    }
}
