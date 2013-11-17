module.exports = function(grunt) {

    var
    platforms = %platforms%,

    testPath = '%test%',
    sourcePath = '%source%',

    customWatchTasks = {},
    customExecTasks = {},

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
                stdout = this.clearFirstAndLastEmptyLine(stdout.split('\n'));
                this.lineIndex = 1;
                for (var i in stdout) {
                    this.line = stdout[i];
                    this.process();
                    this.lineIndex++;
                }
            }.bind(this);
        },

        clearFirstAndLastEmptyLine: function(lines)
        {
            if (lines[0] == '') {
                lines.unshift();
            }

            if (lines[lines.length] == '') {
                lines.pop();
            }

            return lines;
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
    TasksCreator = {
        platforms: [],
        colorizer: undefined,

        init: function(platforms, colorizer)
        {
            this.colorizer = colorizer;
            this.platforms = this.prepairPlatforms(platforms);
        },

        prepairPlatforms: function(platforms)
        {
            var fixedPlatforms = [];
            for (var platform in platforms) {
                platform = platforms[platform];
                switch(platform) {
                    case 'phantomjs':
                        fixedPlatforms.push('js');
                        fixedPlatforms.push(platform);
                        break;
                    default:
                        fixedPlatforms.push(platform);
                }
            }

            return fixedPlatforms;
        },

        create: function(type, userTasks)
        {
            var tasks = {};
            for (var platform in this.platforms) {
                platform = this.platforms[platform];
                tasks[platform] = this[type](platform);
            }

            return grunt.util._.extend(this[type+'Extend'](tasks), userTasks);
        },

        watch: function(platform)
        {
            var task = {
                files: ['<%= testPath %>/**/*.hx', '<%= sourcePath %>/**/*.hx'],
                tasks: 'exec:' + platform
            };

            switch(platform) {
                case 'all':
                    if (this.platforms.indexOf('js') == -1 || this.platforms.indexOf('swf')) {
                        break;
                    }
                case 'js':
                case 'swf':
                    task.tasks = [task.tasks, 'push_to_livereload'];
                    break;
            }

            return task;
        },

        watchExtend: function(tasks)
        {
            this.appendAllWatch(tasks);

            tasks['options'] = {
                spawn: false
            }

            return tasks;
        },

        appendAllWatch: function(tasks)
        {
            var
                all = this.watch('all'),
                allHasLiveReload = all.tasks[1] == 'push_to_livereload';

            all.tasks = [];
            for (var platform in this.platforms) {
                all.tasks.push('exec:'+this.platforms[platform]);
            }

            if (allHasLiveReload) {
                all.tasks.push('push_to_livereload');
            }

            tasks['all'] = all;
        },

        exec: function(platform)
        {
            var
                commandPrefix = 'haxelib run bdd';
                commandSuffix = platform + ' <%= grep %> <%= reporter %> <%= projectFile %>';
            switch(platform) {
                case 'js':
                case 'swf':
                    return {
                        command: commandPrefix + ' build -p ' + commandSuffix,
                        stdout: false
                    }
                    break;

                case 'nodejs':
                case 'phantomjs':
                    return {
                        command: commandPrefix + ' test -p js ' + commandSuffix,
                        stdout: false,
                        callback: this.colorizer
                    }
                    break;

                default:
                    return {
                        command: commandPrefix + ' test -p ' + commandSuffix,
                        stdout: false,
                        callback: this.colorizer
                    }
            }
        },

        execExtend: function(tasks)
        {
            return tasks;
        },
    },
    LiveReloadServer = {
        server: undefined,

        init: function(task) {
            task = task.split(':');
            if (task[0] != 'watch' ||
                !Array.isArray(grunt.config.get('watch.'+task[1]+'.tasks')) ||
                grunt.config.get('watch.'+task[1]+'.tasks').indexOf('push_to_livereload') == -1
            ) {
                return;
            }

            this.start();
        },

        start: function()
        {
            this.server = require('tiny-lr')();
            this.server.listen(35729, function(err) { if (err) console.log(err); });
        },

        push: function()
        {
            this.server.changed({body:{files: ['TestMain.js', 'TestMain.swf'] }});
        }
    },
    GrepValueChanger = {
        init: function(task)
        {
            if (!grunt.option('changed') || task.indexOf('watch:') == -1) {
                return;
            }

            this.registerToWatchTask(task.split(':')[1]);
        },

        registerToWatchTask: function(target)
        {
            var tester = Object.create(this);

            tester.target = target;
            grunt.event.on("watch", tester.listener.bind(tester));

            return tester;
        },

        listener: function(action, filepath, target)
        {
            if (!this.isListenedEvent(action, target)) {
                return;
            }
            grunt.log.writeln('');

            this.file = filepath;
            grunt.config.set('grep', '-g ' + this.grepValue());
        },

        isListenedEvent: function(action, target)
        {
            return action == 'changed' && target == this.target;
        },

        grepValue: function()
        {
            var
                prefix = '',
                suffix = '';

            if (this.file.match('Test.hx$')) {
                prefix = grunt.config.get('testPath');
                suffix = 'Test';
            } else {
                prefix = grunt.config.get('sourcePath');
            }

            suffix += '.hx';

            return this.file.substr(prefix.length + 1).replace(suffix, '').split('/').join('\\.');
        }
    },
    grep = grunt.option('grep') ? '-g '+grunt.option('grep') : '',
    reporter = grunt.option('reporter') ? '-r '+grunt.option('reporter') : '',
    project = grunt.option('project') ? '-f '+grunt.option('project') : ''
    ;

    grunt.registerTask('help', 'Brief description for available options and watch/exec tasks', function(){
        var tasks;

        grunt.log.writeln('Available options:');
        grunt.log.writeln('    --grep     alias for bdd -g');
        grunt.log.writeln('    --reporter alias for bdd -r');
        grunt.log.writeln('    --project  alias for bdd -f');
        grunt.log.writeln('    --changed  change the grep value to the changed file or its test file');

        grunt.log.writeln('');
        grunt.log.writeln('example:');
        grunt.log.writeln('    grunt watch:neko --reporter=dot --changed');

        grunt.log.writeln('');
        grunt.log.writeln('Available watch tasks:');
        tasks = grunt.config.get('watch');
        for (var taskName in tasks) {
            if (taskName == 'options') {
                continue;
            }
            grunt.log.writeln('    watch:'+taskName);
        }

        grunt.log.writeln('');
        grunt.log.writeln('Available exec tasks:');
        tasks = grunt.config.get('exec');
        for (var taskName in tasks) {
            if (taskName == 'options') {
                continue;
            }
            grunt.log.writeln('    exec:'+taskName);
        }

    });

    TasksCreator.init(platforms, Highlighter.colorize());

    grunt.initConfig({
        testPath: testPath,
        sourcePath: sourcePath,
        grep: grep,
        reporter: reporter,
        project: project,

        watch: TasksCreator.create('watch', customWatchTasks),

        exec: TasksCreator.create('exec', customExecTasks),
    });

    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-exec');

    var requestedTask = process.argv[2];

    GrepValueChanger.init(requestedTask);
    LiveReloadServer.init(requestedTask);

    grunt.registerTask('push_to_livereload', 'for internal usage', function(){
        LiveReloadServer.push();
    });
};
