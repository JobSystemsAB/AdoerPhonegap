module.exports = (grunt) ->
	
	#
	# --- Project configuration.
	#
	
	grunt.initConfig(
		pkg: grunt.file.readJSON 'package.json'
		
		# -- WATCH
		
		watch:
			coffee:
				files: ['src/app/*.coffee', 'src/app/**/*.coffee'],
				tasks: ['coffee']
			jade:
				files: ['src/app/**/*.jade']
				tasks: ['jade']
			scripts:
				files: ['src/components/*.js']
				tasks: ['jshint']
			options: 
				spawn: false
				event: ['all']
				livereload: true
		
		# -- HTML
		
		jade:
			compile:
				options:
                    client: false
                    pretty: true
				files: [ {
					src: "src/app/**/*.jade"
					ext: ".html"
					expand: true
                } ]
		htmlmin:
			dist:
				options: 
					removeComments: true
					collapseWhitespace: true
					removeOptionalTags: true
					removeRedundantAttributes: true
					collapseBooleanAttributes: true
				files: [ {
					src: "src/app/**/*.html"
					ext: ".min.html"
					expand: true
                } ]
		
		# -- CSS
		
		stylus:
			compile:
				options:
					paths: ['path/to/import', 'another/to/import']
					urlfunc: 'embedurl'
					use: [ require('fluidity') ]
				files:
					'src/components/<%= pkg.name %>.css': ['src/stylus/*.styl', 'src/app/**/*.styl']
					
		csslint:
			strict:
				options:
					import: 2
				src: ['src/components/<%= pkg.name %>.css']
				
		cssmin:
			combine:
				files:
					'src/components/<%= pkg.name %>.min.css': ['src/components/<%= pkg.name %>.css']
		
		# -- JAVASCRIPT
				
		coffee:
			compile:
				files:
					'src/components/<%= pkg.name %>.js': ['src/app/*.coffee', 'src/app/**/*.coffee']
		jshint:
			all:
				src: ['src/components/*.js']
		uglify:
			my_target:
				files:
					'src/components/<%= pkg.name %>.min.js': ['src/components/<%= pkg.name %>.js']
		build: 
			src: 'src/components/<%= pkg.name %>.js',
			dest: 'src/components/<%= pkg.name %>.min.js'
			
		# -- IMAGES
		
		imagemin:
			png:
				options:
					optimizationLevel: 7
				files: [{
					expand: true
					cwd: 'src/assets/img/original/'
					src: ['*.png']
					dest: 'src/assets/img/min/'
					ext: '.min.png'
				}]
			jpg:
				options:
					progressive: true
				files: [{
					expand: true
					cwd: 'src/assets/img/original/'
					src: ['*.jpg']
					dest: 'src/assets/img/min/'
					ext: '.min.jpg'
				}]
	)
	
	# Load the plugin that provides the extra tasks.
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-stylus'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-jade'
	grunt.loadNpmTasks 'grunt-contrib-htmlmin'
	grunt.loadNpmTasks 'grunt-contrib-csslint'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'
	grunt.loadNpmTasks 'grunt-contrib-imagemin'
	
	# Default task(s).
	grunt.registerTask 'default', ['uglify']

	# on watch events configure jshint:all to only run on changed file
	grunt.event.on 'watch', (action, filepath) ->
		grunt.config 'jshint.all.src', filepath