require 'erb'

class KindleWeather
	# Constants
	WEATHER_PANEL_SMALL = ERB.new File.new("#{ROOT}/templates/kindle-weather-small.erb").read

end # class
