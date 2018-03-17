# Grunt Configuration
# http://gruntjs.com/getting-started#an-example-gruntfile

module.exports = (grunt) ->

	# Initiate the Grunt configuration.
	grunt.initConfig

		# Allow use of the package.json data.
		pkg: grunt.file.readJSON('package.json')

		# docpad variables
		docpad:
			files: [ './src/**/*.*' ]
			out: ['out']

		# optimize images if possible
		imagemin:
			src:
				options:
					optimizationLevel: 3,
				files: [
					expand: true,
					cwd: 'src/files/img/',
					src: ['**/*.{png,jpg,jpeg,gif}'],
					dest: 'src/files/img/'
				]

		# clean out dir
		clean:
			options:
				force: true
			out: ['<%= docpad.out %>']

		# compile less
		less:
			development:
				options:
					strictMath: true
					sourceMap: true
				files: [
					"out/space.css": "space.less"
				]
			production:
				files: [
					"space.css": "space.less"
				]
		cssmin:
			options:
				sourceMap: true
			target:
				files: [
					"space.min.css": "space.css"
				]

		# track changes
		watch:
			out:
				files: ['<%= docpad.out %>/**/*']
				options:
					livereload: true
			less:
				files: [
					'space.less'
					'src/files/css/*.less'
				]
				tasks: [
					'less',
					'cssmin'
				]

		# start server
		connect:
			server:
				options:
					port: 9778
					hostname: '*'
					base: '<%= docpad.out %>'
					livereload: true
					# open: true

		# generate development
		shell:
			deploy:
				options:
					stdout: true
				command: 'docpad deploy-ghpages --env static'
			docpadrun:
				options:
					stdout: true
					async: true
				command: 'docpad run'

	# measures the time each task takes
	require('time-grunt')(grunt);

	# Build the available Grunt tasks.
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-imagemin'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-less'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-connect'
	grunt.loadNpmTasks 'grunt-contrib-compress'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'
	grunt.loadNpmTasks 'grunt-shell-spawn'
	grunt.loadNpmTasks 'grunt-newer'

	# Register our Grunt tasks.
	grunt.registerTask 'deploy',			 ['clean', 'less', 'cssmin', 'shell:deploy' ]
	grunt.registerTask 'run',				 ['less', 'cssmin', 'shell:docpadrun', 'watch:less']
	grunt.registerTask 'default',			 ['run']
