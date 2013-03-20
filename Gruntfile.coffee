module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    clean:
      reset:
        src: ['bin']
      temp:
        src: ['temp']

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
      tests:
        expand: true
        cwd: 'test'
        src: ['**/*.coffee']
        dest: 'temp/test/'
        ext: '.js'
        options:
          bare: true

    copy:
      server:
        expand: true
        cwd: 'server'
        src: '**'
        dest: 'temp/server/'
      conf:
        src: ['.npmignore', 'component.json', 'package.json', 'README.md']
        dest: 'temp/'
      temp:
        expand: true
        cwd: 'temp/'
        src: ['**', '!*.coffee']
        dest: 'bin'      
      test:
        expand: true
        cwd: 'test'
        src: ['*', 'libs/*']
        dest: 'bin/test'     

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
          out: './client/gint-security.js'
          preserveLicenseComments: false
          skipModuleInsertion: true
          uglify:
            no_mangle: false
    watch:
      dev:
        files: ['client/**', 'server/**', ]
        tasks: ['default']
      mochaTests:
        files: ['test/server/**/*.coffee']
        tasks: ['coffeeLint:tests', 'coffee:tests', 'copy:test', 'mocha']
      unitTests:
        files: ['test/client/**/*.coffee']
        tasks: ['coffeeLint:tests', 'coffee:tests', 'copy:temp', 'clean:temp', 'copy:test', 'karma:unit:run']

    mocha:
      all:
        expand: true
        src: ['bin/test/server/**/*_test.js']
        options:
          globals: ['should']
          timeout: 3000
          ignoreLeaks: false
          ui: 'bdd'
          reporter: 'spec'
          growl: true

    karma:
      unit:
        configFile: 'bin/test/karma.conf.js'
        reporters: ['growl']
      travis:
        configFile: 'bin/test/karma.conf.js'
        singleRun: true
        browsers: [ 'PhantomJS' ]

  grunt.loadNpmTasks 'grunt-gint'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-gint'
  grunt.loadNpmTasks 'grunt-karma'

  grunt.registerTask 'build'
  , ['clean', 'coffeeLint', 'coffee', 'requirejs', 'copy', 'clean:temp']

  grunt.registerTask 'default'
  , ['build', 'mocha', 'karma:unit:run']

  grunt.registerTask 'travis'
  , ['build', 'mocha', 'karma:travis' ]

  grunt.registerTask 'run'
  , [ 'default', 'watch']