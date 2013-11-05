package bdd;

import bdd.expection.CompositeShould;

class ExampleGroupFactory
{
    private var should:CompositeShould;

    public function new()
    {
        this.should = new CompositeShould(new bdd.expection.ItReporter());
    }

    public function create(cls:Class<ExampleGroup>):ExampleGroup
    {
        return Type.createInstance(cls, [ this.should ]);
    }
}
