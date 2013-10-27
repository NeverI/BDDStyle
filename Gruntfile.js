module.exports = function(grunt) {

  var
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
    },
    projects = {
        test: {
            main: 'TestMain',
            cmd: 'haxe -main %main% -lib mockatoo -cp test'
        },
        example: {
            main: 'TestMain',
            cmd: 'haxe -main %main% -lib mockatoo -cp example',
        },
        clitest: {
            main: 'TestMain',
            cmd: 'haxe -main %main% -lib mockatoo -cp src -cp src/clitest',
        }
    },
    platforms = {
        js: {
            compile: '-js build/%project%/js.js'
        },
        flash: {
            compile: '-swf build/%project%/flash.swf -swf-header 800:800:24',
            run: {
                command: 'flashplayerdebugger build/%project%/flash.swf'
            }
        },
        neko: {
            compile: '-neko build/%project%/neko.n',
            run: {
                command: 'neko build/%project%/neko.n',
                callback: littleColoring
            },
        },
        cpp: {
            compile: '-cpp build/%project%/cpp',
            run: {
                command: 'build/%project%/cpp/%main%',
                callback: littleColoring
            },
        },
    },
    createExecCommands = function(projects, platforms)
    {
        var exec = {};

        for (projectName in projects) {
            var project = projects[projectName];
            project.cmd = project.cmd.replace('%main%', project.main);

            for (platformName in platforms) {
                var
                    platform = platforms[platformName],
                    commandNameSuffix = projectName+'_'+platformName;

                exec['compile_'+commandNameSuffix] = {
                    command: project.cmd + ' ' + platform.compile.replace('%project%', projectName)
                };

                if (platform.run) {
                    exec['run_'+commandNameSuffix] = {
                        callback: platform.callback,
                        command: platform.run.command.replace('%project%', projectName).replace('%main%', project.main)
                    };
                }
            }
        }

        return exec;
    };

    grunt.initConfig({
        watch: {
            test: {
                files: ['bdd/**/*.hx', 'test/bdd/**/*.hx'],
                tasks: 'test_neko'
            },
            example: {
                files: ['example/**/*.hx', 'bdd/**/*.hx'],
                tasks: 'example_neko'
            },
            clitest: {
                files: ['src/**/*.hx'],
                tasks: 'clitest_neko'
            }
        },

        exec: createExecCommands(projects, platforms)

    });

    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-exec');

    for (projectName in projects) {
        for (platformName in platforms) {
            if (platforms[platformName].run) {
                var taskName = projectName+'_'+platformName;
                grunt.registerTask(taskName, ['exec:compile_' + taskName, 'exec:run_' + taskName])
            }
        }
    }
};
