package cli.helper;

import bdd.ExampleGroup;
import cli.helper.Args;

class ArgsTest extends bdd.ExampleGroup
{
    private var target:cli.helper.Args;

    public function example():Void
    {
        describe('when there are no arguments', function(){
            extendBeforeEach(function(){
                this.target = new cli.helper.Args([]);
            });

            this.cwdShouldBeTheCurrentCwd();

            this.commandShouldBeEmptyString();

            this.argumentHasShouldReturnFalse('foo');

            this.argumentGetShouldReturnEmptyString('foo');
        });

        describe('when the first argument is a valid path', function(){
           extendBeforeEach(function(){
                this.target = new cli.helper.Args(['src']);
            });

            this.cwdShouldBeTheGivenCwd('src');

            this.commandShouldBeEmptyString();

            this.argumentHasShouldReturnFalse('foo');

            this.argumentGetShouldReturnEmptyString('foo');
        });

        describe('when the first argument is not a valid path', function(){
            extendBeforeEach(function(){
                this.target = new cli.helper.Args(['foo', 'bar']);
            });

            this.cwdShouldBeTheCurrentCwd();

            this.commandShouldBeTheGivenString('foo');

            this.argumentHasShouldReturnFalse('foo');

            this.argumentGetShouldReturnString('bar', 'bar');
        });

        describe('when the first argument is a valid path second argument is not a valid command name', function(){
            extendBeforeEach(function(){
                this.target = new cli.helper.Args(['src', '-foo']);
            });

            this.cwdShouldBeTheGivenCwd('src');

            this.commandShouldBeEmptyString();

            this.argumentHasShouldReturnFalse('foo');

            this.argumentGetShouldReturnEmptyString('foo');
        });

        describe('when the first argument is a valid path second argument is a valid command name', function(){
            extendBeforeEach(function(){
                this.target = new cli.helper.Args(['src', 'foo', '-p', 'bar', 'bar', '-a']);
            });

            this.cwdShouldBeTheGivenCwd('src');

            this.commandShouldBeTheGivenString('foo');

            this.argumentHasShouldReturnTrue('p');

            this.argumentGetShouldReturnString('p', 'bar');

            it('#get(name:String):String should return the same value when argument is not started with -', function(){
                should.be.equal('bar', this.target.get('bar'));
            });

            it('#has(name:String):String should return true when argument has not value', function(){
                should.be.True(this.target.has('a'));
            });

            it('#get(name:String):String should return the empty string when argument has not value', function(){
                should.be.empty(this.target.get('a'));
            });
        });
    }

    private function cwdShouldBeTheCurrentCwd():Void
    {
        it('should .cwd be the current cwd', function(){
            should.be.equal(Sys.getCwd(), this.target.cwd);
        });
    }

    private function cwdShouldBeTheGivenCwd(cwd:String):Void
    {
        it('should .cwd be the given path', function(){
            should.be.equal(cwd, this.target.cwd);
        });
    }

    private function commandShouldBeEmptyString():Void
    {
        it('should .command be an empty string', function(){
            should.be.equal('', this.target.command);
        });
    }

    private function commandShouldBeTheGivenString(command:String):Void
    {
        it('should .command be the given argument', function(){
            should.be.equal(command, this.target.command);
        });
    }

    private function argumentHasShouldReturnFalse(arg:String):Void
    {
        it('#has(name:String):Bool should return false', function(){
            should.be.False(target.has(arg));
        });
    }

    private function argumentGetShouldReturnEmptyString(arg:String):Void
    {
        it('#get(name:String):String should return empty string', function(){
            should.be.empty(this.target.get(arg));
        });
    }

    private function argumentHasShouldReturnTrue(arg:String):Void
    {
        it('#has(name:String):Bool should return true', function(){
            should.be.True(target.has(arg));
        });
    }

    private function argumentGetShouldReturnString(arg:String, value:String):Void
    {
        it('#get(name:String):String should return the value', function(){
            should.be.equal(value, this.target.get(arg));
        });
    }
}
