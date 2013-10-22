module.exports = function(grunt) {

  var
    project = 'haxe -main TestMain -lib mockatoo -cp src -cp test ',
    example = 'haxe -main TestMain -lib mockatoo -cp example -cp src ',
    littleColoring = function(err, stdout, stderr)
    {
        if (err || stderr) {
            grunt.log.fail(err || stderr);
            return;
        }

        stdout = stdout.split('\n');
        var lastLine = stdout[stdout.length - 2] ? stdout[stdout.length - 2] : stdout[stdout.length - 1];
        if (lastLine && lastLine.indexOf('OK') !== 0) {
            grunt.log.fail('\nSome test failed');
        }
    };

  grunt.initConfig({
    watch: {
      source: {
        files: ['src/**/*.hx', 'test/src/**/*.hx'],
        tasks: ['exec:compileNeko', 'exec:runNeko']
      },
      example: {
        files: ['example/**/*.hx', 'src/**/*.hx'],
        tasks: ['exec:compileExampleNeko', 'exec:runExampleNeko']
      }
    },

    exec: {
        compileExampleNeko: {
            command: example+'-neko build/example_test.n'
        },
        compileExampleJS: {
            command: example+'-js build/js_example.js'
        },
        compileExampleFlash: {
            command: example+'-swf build/flash_example.swf -swf-header 1000:1000:30'
        },
        compileExampleCPP: {
            command: example+'-cpp build/example'
        },
        runExampleNeko: {
            command: 'neko build/example_test.n',
            callback: littleColoring
        },
        compileNeko: {
            command: project+'-neko build/neko_test.n'
        },
        compileJS: {
            command: project+'-js build/js_test.js'
        },
        compileFlash: {
            command: project+'-swf build/flash_test.swf -swf-header 1000:1000:30'
        },
        compileCPP: {
            command: project+'-cpp build/cpp'
        },
        runNeko: {
            command: 'neko build/neko_test.n',
            callback: littleColoring
        }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-exec');

  grunt.registerTask('compile', ['exec:compileJS', 'exec:compileFlash', 'exec:compileNeko']);
  grunt.registerTask('compileExample', ['exec:compileExampleJS', 'exec:compileExampleFlash', 'exec:compileExampleNeko']);
};
