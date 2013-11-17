package cli.tools;

class FileCreatorTest extends bdd.ExampleGroup
{
    private var target:cli.tools.FileCreator;
    private var path:String;

    override public function beforeEach():Void
    {
        this.path = 'src/clitest/cli/tools/filecreator/';

        this.target = new cli.tools.FileCreator();

        sys.FileSystem.createDirectory(this.path);
    }

    public function example():Void
    {
        describe('#put(path:String, content:String):Void', function(){
            it('should put the content to a file when target folder is exists', function(){
                shouldCreate('simple');
            });

            it('should create the folders if they not exist', function(){
                shouldCreate('bar/dir/simple');
            });
        });
    }

    private function shouldCreate(path:String):Void
    {
        path = this.path + path;
        this.target.put(path, 'foo');

        should.be.True(sys.FileSystem.exists(path));
        should.be.equal('foo', sys.io.File.getContent(path));
    }

    override public function afterEach():Void
    {
        this.removeDir(this.path);
    }

    private function removeDir(path:String):Void
    {
        for (asset in sys.FileSystem.readDirectory(path)) {
            asset = path+'/'+asset;

            if (sys.FileSystem.isDirectory(asset)) {
                this.removeDir(asset);
            } else {
                sys.FileSystem.deleteFile(asset);
            }
        }

        sys.FileSystem.deleteDirectory(path);
    }
}
