module.exports = function(grunt) {


  grunt.initConfig({
    watch: {
      all: {
        files: ['src/**/*.hx', 'test/src/**/*.hx'],
        tasks: ['exec:compileNeko', 'exec:runNeko']
      },
    },

    exec: {
        compileNeko: {
            command: 'haxe -main TestMain -lib mockatoo -cp src -cp test -neko build/neko_test.n'
        },
        runNeko: {
            command: 'neko build/neko_test.n',
            callback: function(err, stdout, stderr)
            {
                if (err || stderr) {
                    grunt.log.fail(err || stderr);
                    return;
                }

                stdout = stdout.split('\n');
                var lastLine = stdout[stdout.length - 2];
                if (lastLine && lastLine.indexOf('FAILED') === 0) {
                    grunt.log.fail('Some test failed');
                }
            }
        }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-exec');

};
