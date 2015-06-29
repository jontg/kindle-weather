require 'erb'
require 'ostruct'
require 'tempfile'
require 'ActiveBrew'
require 'KindleTwitter'
require 'KindleWeather'

require 'pp'

class Renderer
	# Constants
	ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")) # Get the root directory
	OUTPUT_DIR = File.join(ROOT, "output") # Get the root directory
	PRIMARY_TEMPLATE = ERB.new File.new("#{ROOT}/templates/weather-script-image-template.erb").read
	ACTIVE_BREW = ActiveBrew.new
	KINDLE_WEATHER = KindleWeather.new
	TWITTER = KindleTwitter.new

	def process
		parameters = KINDLE_WEATHER.process.merge(TWITTER.process)
		pp parameters
		File.write("#{OUTPUT_DIR}/weather-script-output.svg", PRIMARY_TEMPLATE.result(OpenStruct.new(parameters).instance_eval { binding }))
	end
end # class
