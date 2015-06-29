require 'erb'
require 'tempfile'
require 'yaml'
require 'net/http'
require 'uri'
require 'xmlsimple'

class KindleWeather
	# Constants
	ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")) # Get the root directory
	CONFIG_FILE = "#{ENV['CONFIG_ROOT'] || "#{ROOT}/config"}/Weather.conf"

	WEATHER_PANEL_SMALL = ERB.new File.new("#{ROOT}/templates/kindle-weather-small.erb").read
	WEATHER_PANEL_BANNER = ERB.new File.new("#{ROOT}/templates/kindle-weather-banner.erb").read
	WEATHER_URL = ERB.new <<-EOU
		http://graphical.weather.gov/xml/SOAP_server/ndfdSOAPclientByDay.php?whichClient=NDFDgenByDay&lat=<%= @latitude %>&lon=<%= @longitude %>&format=24+hourly&numDays=5&Unit=e
	EOU

	attr_accessor :latitude, :longitude

	def initialize
		settings = YAML::load_file(CONFIG_FILE)
		@latitude = settings["latitude"]
		@longitude = settings["longitude"]
	end

	def fetch_and_parse_5day
		weather_uri = URI.parse(WEATHER_URL.result(binding).lstrip)
		weather_info = XmlSimple.xml_in(Net::HTTP.get(weather_uri), {'ForceArray' => false, 'KeyAttr' => ['type']})
		day_of_week = weather_info["data"]["time-layout"][0]["start-valid-time"].map{|s| Date::DAYNAMES[Date.strptime(s, "%Y-%m-%d").wday]}
		icons = weather_info["data"]["parameters"]["conditions-icon"]["icon-link"].map{|elem| URI.parse(elem).path.split('/')[-1][/[a-zA-Z_]*/]}
		highs = weather_info["data"]["parameters"]["temperature"]["maximum"]["value"]
		lows = weather_info["data"]["parameters"]["temperature"]["minimum"]["value"]
		day_of_week.zip(icons,highs,lows)
	end

	def process
		weather_5day = fetch_and_parse_5day()
		{
			:today => {
				:icon => weather_5day[0][1], :high => weather_5day[0][2], :low => weather_5day[0][3]
			},
			:next_three_days => [
				{ :offset => "40",  :day => "Tomorrow",         :icon => weather_5day[0][1], :high => weather_5day[0][2], :low => weather_5day[0][3] },
				{ :offset => "240", :day => weather_5day[1][0], :icon => weather_5day[1][1], :high => weather_5day[1][2], :low => weather_5day[1][3] },
				{ :offset => "440", :day => weather_5day[2][0], :icon => weather_5day[2][1], :high => weather_5day[2][2], :low => weather_5day[2][3] }
			]
		}
	end
end # class
