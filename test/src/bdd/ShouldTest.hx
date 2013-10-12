package src.bdd;

import haxe.unit.TestCase;
import bdd.Should;

class ShouldTest extends TestCase
{
    private var should:Should;

    override public function setup():Void
    {
        this.should = new Should();
    }

    public function testBeTrue():Void
    {
    }
}
