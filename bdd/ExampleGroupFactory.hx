package bdd;

import bdd.expection.CompositeShould;

class ExampleGroupFactory
{
    private var should:CompositeShould;

    public function new()
    {
        this.should = new CompositeShould(new bdd.expection.ItReporter());
    }

    public function create(cls:Class<Dynamic>):ExampleGroup
    {
        try {
            return Type.createInstance(cls, [ this.should ]);
        } catch(e:Dynamic) {
            throw Type.getClassName(cls)+' is not an ExampleGroup';
        }
    }
}
