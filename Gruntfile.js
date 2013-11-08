module.exports = function(grunt) {

  var
    okColor = 'green',
    wrongColor = 'red',
    pendingColor = 'cyan',
    defaultColor = 'grey',

    DotColorizer = {
        line: '',

        is: function(line)
        {
            this.line = line;
            return this.isValidChar(0) && this.isValidChar(1) && this.isValidChar(2);
        },

        isValidChar: function(index)
        {
            return this.line.charAt(index) == '.' || this.line.charAt(index) == 'X' || this.line.charAt(index) == 'P' || this.line.charAt(index) == '';
        },

        colorize: function()
        {
            var line = '';
            for (var i=0,len=this.line.length; i < len; i++) {
                var ch = this.line[i];
                line += ch[this.getColor(ch)];
            }

            return line;
        },

        getColor: function(ch)
        {
            if (ch == '.') {
                return okColor;
            } else if (ch == 'X') {
                return wrongColor;
            } else if (ch == 'P') {
                return pendingColor;
            }

            return defaultColor;
        }
    },
    SummaryColorizer = {
        line: '',
        pattern: /(\d+ spec), (\d+ success), (\d+ pending), (\d+ failed), (\d+ expects)/,

        is: function(line)
        {
            this.line = line;
            return line.match(this.pattern);
        },

        colorize: function()
        {
            var parts = this.line.split(',');

            for (var i in parts) {
                var part = parts[i];
                parts[i] = part[this.getColor(part)];
            }

            return parts.join(','.grey);
        },

        getColor: function(part)
        {
            if (part.indexOf('success') != -1) {
                return okColor;
            } else if (part.indexOf('failed') != -1) {
                return wrongColor;
            } else if (part.indexOf('pending') != -1) {
                return pendingColor;
            }

            return defaultColor;
        }
    },
    DescriptiveColorizer = {
        line: '',
        matches: [],
        searchPattern: /(\s+)([X|P]: )/,
        replacePattern: /([X|P]: )/,

        is: function(line)
        {
            this.line = line;
            this.matches = this.line.match(this.searchPattern);
            return this.matches;
        },

        colorize: function()
        {
            this.line = this.line.replace(this.replacePattern, '');
            if (this.matches[2].indexOf('X') != -1) {
                return this.line[wrongColor];
            }

            return this.line[pendingColor];
        },
    },
    Highlighter = {
        line: '',
        lineIndex: 0,
        dotted: Object.create(DotColorizer),
        summary: Object.create(SummaryColorizer),
        descriptive: Object.create(DescriptiveColorizer),

        colorize: function()
        {
            return function(err, stdout, stderr) {
                stdout = stdout.split('\n');
                this.lineIndex = 1;
                for (var i in stdout) {
                    this.line = stdout[i];
                    this.process();
                    this.lineIndex++;
                }
            }.bind(this);
        },

        process: function()
        {
            if (this.lineIndex == 1 && this.dotted.is(this.line)) {
                this.line = this.dotted.colorize()+'\n';

            } else if (this.summary.is(this.line)) {
                this.line = this.summary.colorize();

            } else if (this.descriptive.is(this.line)) {
                this.line = this.descriptive.colorize();

            } else if (this.line.match(/\d+\)/)) {
                this.line = this.line[wrongColor];

            } else if (this.line == 'OK') {
                this.line = this.line[okColor];

            } else if (this.line == 'FAILED') {
                this.line = this.line[wrongColor];

            } else {
                this.line = this.line[defaultColor];
            }

            grunt.log.writeln(this.line);
        },
    },
    highlight = Highlighter.colorize(),
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
                callback: highlight
            },
        },
        cpp: {
            compile: '-cpp build/%project%/cpp',
            run: {
                command: 'build/%project%/cpp/%main%',
                callback: highlight
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
                        callback: platform.run.callback,
                        stdout: false,
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
