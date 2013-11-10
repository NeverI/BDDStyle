package cli.project.openfl;

import mockatoo.Mockatoo.*;

class CompiledTest extends bdd.ExampleGroup
{
    private var target:cli.project.openfl.Compiled;
    private var platform:cli.project.Platform;
    private var args:cli.helper.Args;

    override public function beforeEach():Void
    {
        this.target = new cli.project.openfl.Compiled();
    }
}
