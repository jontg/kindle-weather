require 'erb'
require 'tempfile'
require 'yaml'

class KindleWeather
	# Constants
	ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")) # Get the root directory	
	CONFIG_FILE = "#{ROOT}/config/KindleWeather.conf"
	WEATHER_PANEL_SMALL = ERB.new File.new("#{ROOT}/templates/kindle-weather-small.erb").read
	WEATHER_URL = ERB.new <<-EOU
		http://graphical.weather.gov/xml/SOAP_server/ndfdSOAPclientByDay.php?whichClient=NDFDgenByDay&lat=<%= @latitude %>&lon=<%= @longitude %>&format=24+hourly&numDays=4&Unit=e
	EOU

	attr_accessor :latitude, :longitude

	def initialize
		settings = YAML::load_file(CONFIG_FILE)
		@latitude = settings["latitude"]
		@longitude = settings["longitude"]
	end

	def process
		print @latitude, "\t", @longitude
		print WEATHER_URL.result(binding)
	end
end # class
