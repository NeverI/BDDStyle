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
            command: 'haxe bdd.hxml neko',
            stdout:false,
            stderr:false,
            exitCode: 1,
            callback: function(err, stdout, stderr)
            {
                if (stderr != 'Error: Class name must start with uppercase character\n') {
                    grunt.fail.warn(stderr);
                }
            }
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
