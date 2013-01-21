require 'erb'
require 'tempfile'
require 'yaml'
require 'net/http'
require 'uri'
require 'xmlsimple'
require 'pp'

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
		puts print @latitude, "\t", @longitude

		weather_uri = URI.parse(WEATHER_URL.result(binding).lstrip)
		weather_info = XmlSimple.xml_in(Net::HTTP.get(weather_uri), {'ForceArray' => false, 'KeyAttr' => ['type']})
		day_of_week = weather_info["data"]["time-layout"][0]["start-valid-time"].map{|s| Date::DAYNAMES[Date.strptime(s, "%Y-%m-%d").wday]}
		icons = weather_info["data"]["parameters"]["conditions-icon"]["icon-link"].map{|elem| URI.parse(elem).path.split('/')[-1][/[a-zA-Z_]*/]}
		highs = weather_info["data"]["parameters"]["temperature"]["maximum"]["value"]
		lows = weather_info["data"]["parameters"]["temperature"]["minimum"]["value"]
		pp day_of_week.zip(icons,highs, lows)

	end
end # class
