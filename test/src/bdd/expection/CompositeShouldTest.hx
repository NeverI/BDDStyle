package src.bdd.expection;

using mockatoo.Mockatoo;

import bdd.expection.Result;
import bdd.expection.CompositeShould;

class CompositeShouldTest extends TestCase
{
    private var should:CompositeShould;

    override public function setup():Void
    {
        super.setup();

        this.should = new CompositeShould(this.reporter);
    }

    public function testShouldBe()
    {
        this.should.success();

        this.should.be.True(true);
        this.should.be.False(false);
        this.should.be.equal('foo', 'foo');

        this.should.be.empty([]);
        this.should.be.length(2, ['foo', 'bar']);
        this.should.be.first('foo', ['foo', 'bar']);
        this.should.be.last('bar', ['foo', 'bar']);
        this.should.be.nth(1, 'foobar', ['foo', 'foobar', 'bar']);

        this.should.be.above(15, 10);
        this.should.be.below(0.9, 1.5);
        this.should.be.whitin(0.9, 1, 1.5);
        this.should.be.floatEqual(1.5, 1.49, 0.015);
        this.should.be.NaN('foo');
        this.should.be.finite(12);

        this.should.be.match('fo\\w', 'foo');
        this.should.be.startWith('f', 'foo');
        this.should.be.endWith('o', 'foo');

        this.reporter.report(Result.Success(null)).verify(18);
        this.assertTrue(true);
    }

    public function testShouldNotBe()
    {
        this.should.not.fail();

        this.should.not.be.True(false);
        this.should.not.be.False(true);
        this.should.not.be.equal('bar', 'foo');

        this.should.not.be.empty([1]);
        this.should.not.be.length(1, ['foo', 'bar']);
        this.should.not.be.first('fo', ['foo', 'bar']);
        this.should.not.be.last('ba', ['foo', 'bar']);
        this.should.not.be.nth(2, 'foobar', ['foo', 'foobar', 'bar']);

        this.should.not.be.above(5, 10);
        this.should.not.be.below(1.9, 1.5);
        this.should.not.be.whitin(1.9, 1, 1.5);
        this.should.not.be.floatEqual(1.5, 1.4, 0.05);
        this.should.not.be.NaN('0');
        this.should.not.be.finite(Math.POSITIVE_INFINITY);

        this.should.not.be.match('fo2', 'foo');
        this.should.not.be.startWith('o', 'foo');
        this.should.not.be.endWith('f', 'foo');

        this.reporter.report(Result.Success(null)).verify(18);
        this.assertTrue(true);
    }

    public function testShouldBeAAndAnd()
    {
        this.should.be.a.number(1);
        this.should.be.a.bool(true);
        this.should.be.a.Null(null);
        this.should.be.a.string('foo');
        this.should.be.a.Function(function(){});

        this.should.be.an.object({});
        this.should.be.an.Enum(Result.Success(null));
        this.should.be.an.instanceOf(TestCase, new TestCase());

        this.reporter.report(Result.Success(null)).verify(8);
        this.assertTrue(true);
    }

    public function testShouldBeNotAAndNotAnd()
    {
        this.should.not.be.a.number('foo');
        this.should.not.be.a.bool('foo');
        this.should.not.be.a.Null('foo');
        this.should.not.be.a.string(1);
        this.should.not.be.a.Function({});

        this.should.not.be.an.object(1);
        this.should.not.be.an.Enum('foo');
        this.should.not.be.an.instanceOf(TestCase, {});

        this.reporter.report(Result.Success(null)).verify(8);
        this.assertTrue(true);
    }

    public function testShouldHaveAndContains()
    {
        this.should.have.property('foo', {'foo': true});
        this.should.have.properties(['foo', 'bar'], {'foo': true, 'bar':true});

        this.should.contains('foo', ['foo', 'bar']);

        this.reporter.report(Result.Success(null)).verify(4);
        this.assertTrue(true);
    }

    public function testShouldNotHaveAndNotContains()
    {
        this.should.not.have.property('bar', {'foo': true});
        this.should.not.have.properties(['foo2', 'bar'], {'foo': true, 'bar':true});

        this.should.not.contains('fo', ['foo', 'bar']);

        this.reporter.report(Result.Success(null)).verify(3);
        this.assertTrue(true);
    }

    public function testShouldThrows()
    {
        this.should.throws(function(){ throw 'alma'; });

        this.reporter.report(Result.Success(null)).verify(1);
        this.assertTrue(true);
    }

    public function testShouldNotThrows()
    {
        this.should.not.throws(function(){ });

        this.reporter.report(Result.Success(null)).verify(1);
        this.assertTrue(true);
    }
}
