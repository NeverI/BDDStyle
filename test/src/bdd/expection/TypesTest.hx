package src.bdd.expection;

import bdd.expection.Types;

class TypesTest extends TestCase
{
    private var target:Types;

    override public function setup():Void
    {
        super.setup();

        this.target = new Types();
        this.target.setReporter(this.reporter);
    }

    public function testInstanceOf_Success_WhenTheValueIsInstance():Void
    {
        this.target.instanceOf(Types, new Types());
        this.reporterCalledWithSuccess();
    }

    public function testNotInstanceOf_Success_WhenTheValueIsNotInstance():Void
    {
        this.target.setIsNegated(true);
        this.target.instanceOf(String, -10);
        this.reporterCalledWithSuccess();
    }

    public function testInstanceOf_Failure_WhenTheValueIsNotInstance():Void
    {
        this.target.instanceOf(Int, []);
        this.reporterCalledWithFailure('Expected Int does not instance of Array');
    }

    public function testNotInstanceOf_Failure_WhenTheValueIsInstance():Void
    {
        this.target.setIsNegated(true);
        this.target.instanceOf(TypesTest, this);
        this.reporterCalledWithFailure('Not expected to be an instance of src.bdd.expection.TypesTest');
    }

    public function testString_Success_WhenTheValueIsString():Void
    {
        this.target.string('alma');
        this.reporterCalledWithSuccess();
    }

    public function testNotString_Success_WhenTheValueIsNotString():Void
    {
        this.target.setIsNegated(true);
        this.target.string(-10);
        this.reporterCalledWithSuccess();
    }

    public function testString_Failure_WhenTheValueIsNotString():Void
    {
        this.target.string([]);
        this.reporterCalledWithFailure('Expected to be string got: Array');
    }

    public function testNotString_Failure_WhenTheValueIsString():Void
    {
        this.target.setIsNegated(true);
        this.target.string('alma');
        this.reporterCalledWithFailure('Not expected to be string');
    }

    public function testBool_Success_WhenTheValueIsBool():Void
    {
        this.target.bool(false);
        this.reporterCalledWithSuccess();
    }

    public function testNotBool_Success_WhenTheValueIsNotBool():Void
    {
        this.target.setIsNegated(true);
        this.target.bool(-10);
        this.reporterCalledWithSuccess();
    }

    public function testBool_Failure_WhenTheValueIsNotBool():Void
    {
        this.target.bool('alma');
        this.reporterCalledWithFailure('Expected to be bool got: String');
    }

    public function testNotBool_Failure_WhenTheValueIsBool():Void
    {
        this.target.setIsNegated(true);
        this.target.bool(true);
        this.reporterCalledWithFailure('Not expected to be bool');
    }

    public function testNumber_Success_WhenTheValueNumber():Void
    {
        this.target.number(1.5);
        this.reporterCalledWithSuccess();
    }

    public function testNotNumber_Success_WhenTheValueIsNotNumber():Void
    {
        this.target.setIsNegated(true);
        this.target.number('alma');
        this.reporterCalledWithSuccess();
    }

    public function testNumber_Failure_WhenTheValueIsNotNumber():Void
    {
        this.target.number('alma');
        this.reporterCalledWithFailure('Expected to be number got: String');
    }

    public function testNotNumber_Failure_WhenTheValueIsNumber():Void
    {
        this.target.setIsNegated(true);
        this.target.number(1);
        this.reporterCalledWithFailure('Not expected to be number');
    }

    public function testObject_Success_WhenTheValueIsObject():Void
    {
        this.target.object(this);
        this.reporterCalledWithSuccess();
    }

    public function testNotObject_Success_WhenTheValueIsNotObject():Void
    {
        this.target.setIsNegated(true);
        this.target.object(null);
        this.reporterCalledWithSuccess();
    }

    public function testObject_Failure_WhenTheValueIsNotObject():Void
    {
        this.target.object(1);
        this.reporterCalledWithFailure('Expected to be object');
    }

    public function testNotObject_Failure_WhenTheValueIsObject():Void
    {
        this.target.setIsNegated(true);
        this.target.object({});
        this.reporterCalledWithFailure('Not expected to be object');
    }

    public function testFunction_Success_WhenTheValueIsFunction():Void
    {
        this.target.Function(this.assertTrue);
        this.reporterCalledWithSuccess();
    }

    public function testNotFunction_Success_WhenTheValueIsNotFunction():Void
    {
        this.target.setIsNegated(true);
        this.target.Function(this);
        this.reporterCalledWithSuccess();
    }

    public function testFunction_Failure_WhenTheValueIsNotFunction():Void
    {
        this.target.Function('alma');
        this.reporterCalledWithFailure('Expected to be function got: String');
    }

    public function testNotFunction_Failure_WhenTheValueIsFunction():Void
    {
        this.target.setIsNegated(true);
        this.target.Function(Math.abs);
        this.reporterCalledWithFailure('Not expected to be function');
    }

    public function testEnum_Success_WhenTheValueIsEnum():Void
    {
        this.target.Enum(Foo.Bar('alma'));
        this.reporterCalledWithSuccess();
    }

    public function testNotEnum_Success_WhenTheValueIsNotEnum():Void
    {
        this.target.setIsNegated(true);
        this.target.Enum('alma');
        this.reporterCalledWithSuccess();
    }

    public function testEnum_Failure_WhenTheValueIsNotEnum():Void
    {
        this.target.Enum('alma');
        this.reporterCalledWithFailure('Expected to be enum got: String');
    }

    public function testNotEnum_Failure_WhenTheValueIsEnum():Void
    {
        this.target.setIsNegated(true);
        this.target.Enum(Foo.Bar('alma'));
        this.reporterCalledWithFailure('Not expected to be enum');
    }
}

enum Foo {
    Bar(msg : String);
}
