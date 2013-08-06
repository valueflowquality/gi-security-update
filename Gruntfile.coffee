module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    clean:
      reset:
        src: ['bin']
      temp:
        src: ['temp']
      bin:
        src: ['bin/client']

    coffeeLint: 
      scripts:
        files: [
          {
            expand: true
            src: ['client/**/*.coffee', '!client/js/components/**']
          }
          {
            expand: true
            src: ['server/**/*.coffee']
          }
        ]
        options:
          indentation:
            value: 2
            level: 'error'
          no_plusplus: 
            level: 'error'
      tests:
        files: [
          {
            expand: true
            src: ['test/**/*.coffee']
          }
        ]
        options:
          indentation:
            value: 2
            level: 'error'
          no_plusplus: 
            level: 'error'
    coffee:
      scripts:
        expand: true
        cwd: 'client'
        src: ['**/*.coffee']
        dest: 'temp/client/js/'
        ext: '.js'
        options:
          bare: true

    ngTemplateCache:
      views:
        files:
          './temp/client/js/views.js': './client/views/*.html'
        options:
          trim: './client'
    copy:
      dev:
        expand: true
        cwd: 'temp/'
        src: ['**']
        dest: 'bin'
      libs:
        cwd: 'client'
        expand: true
        src: 'libs/*'
        dest: 'temp/client/js'

    requirejs:
      scripts:
        options:
          baseUrl: 'temp/client/js/'
          findNestedDependencies: true
          logLevel: 0
          mainConfigFile: 'temp/client/js/main.js'
          name: 'main'
          onBuildWrite: (moduleName, path, contents) ->
            modulesToExclude = ['main']
            shouldExcludeModule = modulesToExclude.indexOf(moduleName) >= 0

            if (shouldExcludeModule)
              return ''

            return contents
          optimize: 'none'
          out: 'bin/gint-security.js'
          preserveLicenseComments: false
          skipModuleInsertion: true
          uglify:
            no_mangle: false
    watch:
      dev:
        files: ['client/**', 'server/**']
        tasks: ['default']
      mochaTests:
        files: ['test/server/**/*.coffee']
        tasks: ['coffeeLint:tests', 'mocha:unit']
      unitTests:
        files: ['test/client/**/*.coffee']
        tasks: ['coffeeLint:tests', 'karma:singleUnit']

    mochaTest:
      travis:
        src: ['test/server/**/*Spec.coffee']
        options:
          timeout: 3000
          ignoreLeaks: false
          reporter: 'dot'

    karma:
      singleUnit:
        configFile: 'test/karma.conf.js'
        reporters: ['dots', 'growl']
        singleRun: true        
      unit:
        configFile: 'test/karma.conf.js'
        reporters: ['dots', 'growl']
      travis:
        configFile: 'test/karma.conf.js'
        singleRun: true
        browsers: [ 'PhantomJS' ]
      coverage:
        configFile: 'test/karmaCoverage.conf.js'
        singleRun: true
        browsers: [ 'Chrome' ]
        reporters: ['dots', 'coverage']

  grunt.loadNpmTasks 'grunt-gint'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-gint'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.registerTask 'build'
  , ['clean', 'coffeeLint', 'coffee', 'ngTemplateCache','copy:libs'
  , 'requirejs', 'copy:dev', 'clean:temp']

  grunt.registerTask 'default'
  , ['build', 'mochaTest:unit', 'clean:bin']

  grunt.registerTask 'travis'
  , ['build', 'mochaTest:travis', 'karma:travis' ]

  grunt.registerTask 'coverage'
  , ['build', 'karma:coverage', 'clean:bin']

  grunt.registerTask 'ciserver'
  , ['build', 'karma:unit']

  grunt.registerTask 'run'
  , [ 'build', 'watch']