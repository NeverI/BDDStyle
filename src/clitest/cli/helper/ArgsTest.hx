package cli.helper;

import bdd.ExampleGroup;
import cli.helper.Args;

class ArgsTest extends bdd.ExampleGroup
{
    private var target:cli.helper.Args;

    public function example():Void
    {
        describe('.command:String', function(){
            it('should return empty string when argument is an empty array', function(){
                this.target = new cli.helper.Args([]);
                should.be.equal('', this.target.command);
            });

            it('should return empty string when argument list first element started with - ', function(){
                this.target = new cli.helper.Args(['-p']);
                should.be.equal('', this.target.command);
            });

            it('should return the first element when it is not started with -', function(){
                this.target = new cli.helper.Args(['foo']);
                should.be.equal('foo', this.target.command);
            });
        });

        describe('#has(name:String):Bool', function(){
            it('should return false when argument is not present', function(){
                this.target = new cli.helper.Args([]);
                should.be.False(target.has('foo'));
            });

            it('should return false when command is not present', function(){
                this.target = new cli.helper.Args(['-p']);
                should.be.False(target.has('p'));
            });

            it('should return true when command and arugment are present', function(){
                this.target = new cli.helper.Args(['foo', 'bar', '-p']);
                should.be.True(target.has('bar'));
                should.be.True(target.has('p'));
            });
        });

        describe('#get(name:String):String', function(){
            it('should return empty string when argument is not present', function(){
                this.target = new cli.helper.Args([]);
                should.be.empty(this.target.get('foo'));
            });

            it('should return empty string when command is not present', function(){
                this.target = new cli.helper.Args(['-p']);
                should.be.empty(this.target.get('p'));
            });

            it('should return the value when command and arugment are present', function(){
                this.target = new cli.helper.Args(['foo', 'bar', '-p', 'alma']);
                should.be.equal('bar', target.get('bar'));
                should.be.equal('alma',target.get('p'));
            });

            it('should return empty string when command and arugment are present, but not has value', function(){
                this.target = new cli.helper.Args(['foo', 'bar', '-p']);
                should.be.empty(target.get('p'));
            });
        });
    }
}