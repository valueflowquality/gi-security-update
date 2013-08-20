# Karma configuration


# base path, that will be used to resolve files and exclude
module.exports = (config) ->
  config.set
    basePath: '../../'
    frameworks: ['mocha']
    files :[
      'test/libs/mocha.conf.js'
      './node_modules/chai/chai.js'
      'test/libs/chai-should.js'
      'test/libs/chai-expect.js'
      'test/libs/sinon-1.6.0.js'
      'test/libs/jquery-1.8.3.js'
      'test/libs/angular.js'
      'test/libs/angular-resource.js'
      'test/libs/angular-mocks.js'
      'test/libs/app.js'
      'client/controllers/*.coffee'
      'client/directives/*.coffee'
      'client/services/*.coffee'
      'client/filters/*.coffee'
      'bin/client/js/views.js'
      'test/client/**/*.coffee'
    ]
    preprocessors:
      '**/*.coffee': 'coffee'
    reporters = 'dots'
    port: 8080
    colors: true
    logLevel: config.LOG_INFO
    autoWatch: false
    browsers: ['Chrome']
    singleRun: false
    plugins: [
      'karma-jasmine'
    ]