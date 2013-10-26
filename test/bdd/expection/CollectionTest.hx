package bdd.expection;

class CollectionTest extends TestCase
{
    private var target:Collection;
    private var notTarget:Collection;

    override public function setup():Void
    {
        super.setup();

        this.target = new Collection(this.reporter);
        this.notTarget = new Collection(this.reporter, true);
    }

    public function testEmpty_Success_WhenTheValueIsEmpty():Void
    {
        this.target.empty([]);
        this.reporterCalledWithSuccess();
    }

    public function testNotEmpty_Success_WhenTheValueIsNotEmpty():Void
    {
        this.notTarget.empty([['alma', 'korte'], [1, 2]]);
        this.reporterCalledWithSuccess();
    }

    public function testEmpty_Failure_WhenTheValueIsNotEmpty():Void
    {
        this.target.empty([1,2,3]);
        this.reporterCalledWithFailure('Expected not be empty got 3');
    }

    public function testNotEmpty_Failure_WhenTheValueIsEmpty():Void
    {
        this.notTarget.empty([]);
        this.reporterCalledWithFailure('Not expected to be empty');
    }

    public function testLength_Success_WhenTheLengthIsEqual():Void
    {
        this.target.length(2, [0,1]);
        this.reporterCalledWithSuccess();
    }

    public function testNotLength_Success_WhenTheLengthIsNotEqual():Void
    {
        var obj:Dynamic = {};
        var length = function():Int { return 1; };
        obj.length = length;

        this.notTarget.length(3, obj);
        this.reporterCalledWithSuccess();
    }

    public function testLength_Failure_WhenTheLengthIsNotEqual():Void
    {
        this.target.length(1, [1,2,3]);
        this.reporterCalledWithFailure('Expected length 1 not match with 3');
    }

    public function testNotLength_Failure_WhenTheLengthIsEqual():Void
    {
        this.notTarget.length(0, []);
        this.reporterCalledWithFailure('Not expected the length to be the same: 0');
    }

    public function testLength_Failure_WhenTheObjectDoesNotHaveLength():Void
    {
        this.target.length(1, {});
        #if js
        this.reporterCalledWithFailure('Object does not has length: {\n\n}');
        #elseif cpp
        this.reporterCalledWithFailure('Object does not has length: {  }');
        #else
        this.reporterCalledWithFailure('Object does not has length: {}');
        #end
    }

    public function testFirst_Success_WhenTheValueIsEqual():Void
    {
        this.target.first('foo', new IteratorClass());
        this.reporterCalledWithSuccess();
    }

    public function testNotFirst_Success_WhenTheValueIsNotEqual():Void
    {
        this.notTarget.first(3, []);
        this.reporterCalledWithSuccess();
    }

    public function testFirst_Failure_WhenTheValueIsNotEqual():Void
    {
        this.target.first(2, [1,2,3]);
        this.reporterCalledWithFailure('Expected first 2 element not match with 1');
    }

    public function testNotFirst_Failure_WhenTheValueIsEqual():Void
    {
        this.notTarget.first('bar', new Iterable());
        this.reporterCalledWithFailure('Not expected the first element to be the same: bar');
    }

    public function testFirst_Failure_WhenTheValueIsNotItarable():Void
    {
        this.target.first('a', 'alma');
        this.reporterCalledWithFailure('Object is not iterable: alma');
    }

    public function testLast_Success_WhenTheValueIsLast():Void
    {
        this.target.last('bar', new IteratorClass());
        this.reporterCalledWithSuccess();
    }

    public function testNotLast_Success_WhenTheValueIsNotLast():Void
    {
        this.notTarget.last(3, []);
        this.reporterCalledWithSuccess();
    }

    public function testLast_Failure_WhenTheValueIsNotLast():Void
    {
        this.target.last(1, [1,2,3]);
        this.reporterCalledWithFailure('Expected last 1 element not match with 3');
    }

    public function testNotLast_Failure_WhenTheValueIsLast():Void
    {
        this.notTarget.last('foo', new Iterable());
        this.reporterCalledWithFailure('Not expected the last element to be the same: foo');
    }

    public function testLast_Failure_WhenTheValueIsNotItarable():Void
    {
        this.target.last('a', 'alma');
        this.reporterCalledWithFailure('Object is not iterable: alma');
    }

    public function testContains_Success_WhenTheValueIsIn():Void
    {
        this.target.contains('bar', new IteratorClass());
        this.reporterCalledWithSuccess();
    }

    public function testNotContains_Success_WhenTheValueIsNotIn():Void
    {
        this.notTarget.contains(3, []);
        this.reporterCalledWithSuccess();
    }

    public function testContains_Failure_WhenTheValueIsNotIn():Void
    {
        this.target.contains(5, [1,2,3]);
        this.reporterCalledWithFailure('Expected contains 5 element in [1,2,3]');
    }

    public function testNotContains_Failure_WhenTheValueIsIn():Void
    {
        this.notTarget.contains('foo', new Iterable());
        #if js
        this.reporterCalledWithFailure('Not expected to contains the foo in {\n\tprops : [bar,foo], \n\tcursor : 2\n}');
        #elseif (flash9 || flash)
        this.reporterCalledWithFailure('Not expected to contains the foo in [object Iterable]');
        #elseif cpp
        this.reporterCalledWithFailure('Not expected to contains the foo in Iterable');
        #else
        this.reporterCalledWithFailure('Not expected to contains the foo in { props => [bar,foo], cursor => 2 }');
        #end
    }

    public function testContains_Failure_WhenTheValueIsNotItarable():Void
    {
        this.target.contains('a', 'alma');
        this.reporterCalledWithFailure('Object is not iterable: alma');
    }
}

class IteratorClass
{
    public var props:Array<String>;

    public function new(){
        this.props = ["foo", "bar"];
    }

    public function iterator ()
    {
        return this.props.iterator();
    }
}

class Iterable
{
    public var props:Array<Dynamic>;
    public var cursor:Int;

    public function new(){
        this.props = ["bar", "foo"];
        this.cursor = 0;
    }

    public function hasNext():Bool {
        return this.cursor < this.props.length;
    }

    public function next():String
    {
        return this.props[this.cursor++];
    }
}
