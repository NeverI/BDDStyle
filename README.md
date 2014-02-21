#BDDStyle (like RSpec or Jasmine)
##### because old school unit tests are boring :)

The main purpose for this framework is the continuous testing as small effort as can be.

I think writing tests before the actual code is written is a good think, but I'm lazy as hell and if its require some effort... then it has a high chance I will don't do it :)

##Features
#####Command Line Tool

    - project initializer
    - class creator
    - [Gruntjs](http://gruntjs.com) integration
    - seamless OpenFL support
    - test runner with grep and reporter setter
    - headless javascript testing with phantomjs or nodejs

#####Gruntjs

    - automatic setup with project initializer
    - terminal output colorization
    - watch/exec tasks realtime created so can be change anytime
    - grep and reporter option passtrough
    - grep value can be setted based on the changed file so
      anytime a class or its test is edited only these tests will be run
    - livereload for js and swf watch tasks

#####Framework

       - nested 'describe' and 'before/afterEach' sections
       - async blocks inside 'it'-s
       - modular reporting system
       - available platforms: all
           - except php:
               - builtin Sys.print generate wrong code...
               - cannot identify iterable objects like other platforms
           - C# / java: I don't know how to compile so not tested

#####Available shoulds:
```
should.success();
should.fail();

should.be.True(true);
should.be.False(false);
should.be.equal('foo', 'foo');

should.be.empty([]);
should.be.first('foo', ['foo', 'bar']);
should.be.last('bar', ['foo', 'bar']);
should.be.nth(1, 'foobar', ['foo', 'foobar', 'bar']);

should.be.above(15, 10);
should.be.below(0.9, 1.5);
should.be.whitin(0.9, 1, 1.5);
should.be.floatEqual(1.5, 1.49, 0.015);
should.be.NaN('foo');

should.be.a.number(1);
should.be.a.bool(true);
should.be.a.Null(null);
should.be.a.string('foo');
should.be.a.Function(function(){});

should.be.an.object({});
should.be.an.Enum(Result.Success(null));
should.be.an.instanceOf(TestCase, new TestCase());

should.have.length(2, ['foo', 'bar']);
should.have.property('foo', {'foo': true});
should.have.properties(['foo', 'bar'], {'foo': true, 'bar':true});

should.match('fo\\w', 'foo');
should.startWith('f', 'foo');
should.endWith('o', 'foo');

should.contains('foo', ['foo', 'bar']);

should.throws(function(){ throw 'foo'; });

//and of course everything can be negated.
should.not.fail();
should.not.not.not.not.not.fail(); :D

//checkout the tests for more detailed possibilities
```

##Usage

#####Install
```
$> haxelib install bdd
```

#####Command line:
```
$> haxelib run bdd init # it will ask some questions
Woud you like to use gruntjs as automatic/colorizer runner?
test path (default test):
source path (default src):
export path (default build):
haxelibs (other then bdd (commasep list)):
# if you enter openfl then the project file will be an openfl xml
# instead of hxml, and does not ask for the platforms
Which platforms would you like to use (default neko)?

$> haxelib run bdd test # compile and run all the platforms
                        # or neko with openfl
$> haxelib run bdd test -p cpp # only cpp target (both openfl/hxml)
$> haxelib run bdd create org.example.Whatever # create a class and
                                               # its test file
$> haxelib run bdd help # for more info :)
```

#####Gruntjs:
```
$> grunt watch:neko # run all the test files on file change with neko
$> grunt watch:phantomjs --grep=Example # only Example with phantom js
$> grunt watch:neko --reporter=dot --changed # only the changed file
                                             # with dot reporter
$> grunt watch:js # this will only build the js file and trigger for livereload
$> grunt help # for more info
```


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/NeverI/bddstyle/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

