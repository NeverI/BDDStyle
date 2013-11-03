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

        describe('when the first argument is a valid command', function(){
            extendBeforeEach(function(){
                this.target = new cli.helper.Args(['foo', 'bar']);
            });

            this.cwdShouldBeTheCurrentCwd();

            this.commandShouldBeTheGivenString('foo');

            this.argumentHasShouldReturnFalse('foo');

            this.argumentGetShouldReturnString('bar', 'bar');
        });

        describe('when the last argument is a valid path', function(){
            extendBeforeEach(function(){
                this.target = new cli.helper.Args(['create', 'src']);
            });

            this.cwdShouldBeTheGivenCwd('src');

            this.commandShouldBeTheGivenString('create');

            this.argumentHasShouldReturnFalse('src');
        });

        describe('when the last argument is a valid path but also a key value pair', function(){
            extendBeforeEach(function(){
                this.target = new cli.helper.Args(['create', '-p', 'src']);
            });

            this.cwdShouldBeTheCurrentCwd();
        });

        describe('ordered params', function(){
            it('should set the first three argument after the command if they are not a key value pair', function(){
                this.target = new cli.helper.Args(['foo', 'bar', 'alma', 'korte']);

                should.be.equal('bar', this.target.first);
                should.be.equal('alma', this.target.second);
                should.be.equal('korte', this.target.third);
            });

            it('should only set while arugment is not a key value pair', function(){
                this.target = new cli.helper.Args(['foo', 'bar', '-p', 'alma']);

                should.be.equal('bar', this.target.first);
                should.be.empty(this.target.second);
                should.be.empty(this.target.third);

                this.target = new cli.helper.Args(['foo', 'bar', 'src']);

                should.be.equal('bar', this.target.first);
                should.be.empty(this.target.second);
                should.be.empty(this.target.third);

                this.cwdShouldBeTheGivenCwd('src');
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
