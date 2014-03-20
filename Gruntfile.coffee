module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    env:
      test:
        src: 'test/e2e/.env'

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
          module: 'gi.security'
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
          out: 'bin/gi-security.js'
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

    express:
      test:
        options:
          hostname: '*'
          server: 'example/server/app.coffee'

    mochaTest:
      unit:
        src: ['test/unit/server/mocha/testSpec.coffee']
        options:
          timeout: 3000
          ignoreLeaks: false
          reporter: 'spec'
          ui: 'bdd'

    karma:
      unit:
        configFile: 'test/unit/client/karma.conf.coffee'
        singleRun: true
        browsers: [ 'PhantomJS' ]

    cucumberjs:
      unit:
        src: 'test/unit/server/cucumber'
        options:
          format: "pretty"
      integration:
        src: 'test/integration/server'
        options:
          format: "pretty"
      e2e:
        src: 'test/e2e'
        options:
          format: "pretty"
    
  grunt.loadNpmTasks 'grunt-gint'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-cucumber'
  grunt.loadNpmTasks 'grunt-express'
  grunt.loadNpmTasks 'grunt-env'

  grunt.registerTask 'build', [
    'clean'
    'coffeeLint'
    'coffee'
    'ngTemplateCache'
    'copy:libs'
    'requirejs'
    'copy:dev'
    'clean:temp'
  ]

  grunt.registerTask 'unit', [
    'build'
    'mochaTest:unit'
    'cucumberjs:unit'
    'karma:unit'
  ]

  grunt.registerTask 'integration', [
    'build'
    'cucumberjs:integration'
  ]

  grunt.registerTask 'e2e', [
    'build'
    'express:test'
    'env:test'
    'cucumberjs:e2e'
  ]

  grunt.registerTask 'test', [
    'build'
    'mochaTest:unit'
    'cucumberjs:unit'
    'karma:unit'
    'cucumberjs:integration'
    'express:test'
    'env:test'
    'cucumberjs:e2e'
  ]

  grunt.registerTask 'default', [
    'build'
  ]

  grunt.registerTask 'ci', [
    'build'
    'mochaTest:unit'
    'cucumberjs:unit'
    'karma:unit'
    'cucumberjs:integration'
  ]

  grunt.registerTask 'server', [
    'build'
    'express'
    'express-keepalive'
  ]