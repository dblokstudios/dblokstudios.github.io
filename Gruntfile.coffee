module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    globalConfig:
      root: ''
      tmp: '_dev-files/_tmp'
      css:
        sass: '_dev-files/_sass'
        css: '_dev-files/_css'
        tmp: '_dev-files/_tmp/css'
        build: 'assets/css'
      img:  'assets/img'
      js:
        coffee: '_dev-files/_coffee'
        js: '_dev-files/_js'
        tmp: '_dev-files/_tmp/js'
        build: 'assets/js'
      icons:
        dev: '_dev-files/_icons/_svg'
        tmp: '_dev-files/_tmp/svg'
        build: 'assets/icons'
      fonts:
        build: 'assets/fonts'

      layout:
        dev: '_dev-files/_layouts'
        tmp: '_dev-files/_tmp/layouts'
        build: '_layouts'

    sass:
      build:
        expand: true
        cwd:  '<%= globalConfig.css.sass %>'
        src:  '**/*.scss'
        dest: '<%= globalConfig.css.tmp %>'
        ext:  '.css'

    autoprefixer:
      options:
        browsers: ['last 2 version', 'ie 10', '> 1%']
      build:
        expand: true
        cwd:  '<%= globalConfig.css.tmp %>'
        src:  '**/*.css'
        dest: '<%= globalConfig.css.tmp %>'

    copy:
      css_tmp:
        cwd: '<%= globalConfig.css.css %>'
        src: '**/*.css'
        dest: '<%= globalConfig.css.tmp %>'
        expand: true
      css:
        cwd: '<%= globalConfig.css.tmp %>'
        src: '**/*.css'
        dest: '<%= globalConfig.css.build %>'
        expand: true
      js_tmp:
        cwd: '<%= globalConfig.js.js %>'
        src: '**/*.js'
        dest: '<%= globalConfig.js.tmp %>'
        expand: true
      js:
        cwd: '<%= globalConfig.js.tmp %>'
        src: '**/*.js'
        dest: '<%= globalConfig.js.build %>'
        expand: true
      layout_tmp:
        cwd: '<%= globalConfig.layout.dev %>'
        src: '**/*.html'
        dest: '<%= globalConfig.layout.tmp %>'
        expand: true
      layout:
        cwd: '<%= globalConfig.layout.tmp %>'
        src: '**/*.html'
        dest: '<%= globalConfig.layout.build %>'
        expand: true

    clean:
      temp: '<%= globalConfig.tmp %>'
      css: '<%= globalConfig.css.build %>'
      js: '<%= globalConfig.js.build %>'
      font: '<%= globalConfig.fonts.build %>'


    cssmin:
      build:
        expand: true
        cwd: '<%= globalConfig.css.tmp %>'
        src: '**/*.css'
        dest: '<%= globalConfig.css.tmp %>'
        ext: '.min.css'

        options:
          report: 'gzip'

    coffee:
      build:
        expand: true
        cwd: '<%= globalConfig.js.coffee %>'
        src: '**/*.coffee'
        dest: '<%= globalConfig.js.tmp %>'
        ext: '.js'

    uglify:
      build:
        expand: true
        cwd: '<%= globalConfig.js.tmp %>'
        src: '**/*.js'
        dest: '<%= globalConfig.js.tmp %>'
        ext: '.min.js'


    processhtml:
      deploy:
        expand: true
        cwd: '<%= globalConfig.layout.dev %>'
        src: '**/*.html'
        dest: '<%= globalConfig.layout.build %>'

    watch:
      sass:
        files: '<%= globalConfig.css.sass %>/**/*.scss'
        tasks: ['css']
      css:
        files: '<%= globalConfig.css.css %>/**/*.css'
        tasks: ['css']
      coffee:
        files: '<%= globalConfig.js.coffee %>/**/*.coffee'
        tasks: ['js']
      js:
        files: '<%= globalConfig.js.js %>/**/*.js'
        tasks: ['js']
      layout:
        files: '<%= globalConfig.layout.dev %>/**/*.html'
        tasks: ['layout']

    svgmin:
      build:
        expand: true
        cwd: '<%= globalConfig.icons.dev %>'
        src: ['**/*.svg']
        dest: '<%= globalConfig.icons.tmp %>'
        ext: '.svg'

    webfont:
      icons:
        src: '<%= globalConfig.icons.tmp %>/**/*.svg'
        dest: '<%= globalConfig.fonts.build %>'
        options:
          stylesheet: 'scss'
          font: 'icons'
          relativeFontPath: '/assets/fonts'
          syntax: 'bem'
          templateOptions:
            baseClass: 'icon'
            classPrefix: 'icon--'







  # !Load Tasks
  require("load-grunt-tasks") grunt

  grunt.registerTask 'css', [
    'sass'
    'copy:css_tmp'
    'autoprefixer'
    'copy:css'
  ]

  grunt.registerTask 'css-deploy', [
    'clean:css'
    'sass'
    'copy:css_tmp'
    'autoprefixer'
    'cssmin'
    'copy:css'
  ]

  grunt.registerTask 'js', [
    'coffee'
    'copy:js_tmp'
    'copy:js'
  ]

  grunt.registerTask 'js-deploy', [
    'clean:js'
    'coffee'
    'copy:js_tmp'
    'uglify'
    'copy:js'
  ]

  grunt.registerTask 'icons', [
    'svgmin'
    'webfont'
  ]

  grunt.registerTask 'icons-deploy', [
    'clean:font'
    'svgmin'
    'webfont'
  ]

  grunt.registerTask 'layout', [
    'copy:layout_tmp'
    'copy:layout'
  ]

  grunt.registerTask 'layout-deploy', [
    'processhtml:deploy'
    'copy:layout'
  ]


  grunt.registerTask 'default', [
    'icons'

    'css'

    'js'

    'layout'

    'watch'
  ]



  grunt.registerTask 'deploy', [
    'clean:temp'

    'icons-deploy'

    'css-deploy'

    'js-deploy'

    'layout-deploy'

    'clean:temp'
  ]

