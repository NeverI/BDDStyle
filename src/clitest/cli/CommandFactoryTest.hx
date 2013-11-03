package cli;

import cli.CommandFactory;
import cli.helper.Args;

class CommandFactoryTest extends bdd.ExampleGroup
{
    private var target:CommandFactory;

    override function beforeEach():Void
    {
        this.target = new CommandFactory();
    }

    public function example():Void
    {
        describe('#create(argList:Array<String>):Command', function(){
            it('should create Help command if command is empty', function(){
                var command = this.target.create([]);
                should.be.an.instanceOf(cli.command.Help, command);
            });

            it('should create Help command if command class with name does not exists', function(){
                var command = this.target.create(['foo']);
                should.be.an.instanceOf(cli.command.Help, command);
            });

            it('should create command with the given name', function(){
                var command = this.target.create(['create']);
                should.be.an.instanceOf(cli.command.Create, command);
            });
        });
    }
}
