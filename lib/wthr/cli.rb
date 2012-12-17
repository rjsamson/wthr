require 'yaml'
require 'thor'
require 'rainbow'
require 'rb_wunderground'

module Wthr
  class CLI < Thor

    CONFIG_FILE = File.join(ENV['HOME'], '.wthr-key')
    CACHE_FILE  = File.join(ENV['HOME'], '.wthr')

    # if File.exists? CONFIG_FILE
    #   config_options = YAML.load_file(CONFIG_FILE)
    #   options.merge!(config_options)
    # else
    #   File.open(CONFIG_FILE, 'w') { |file| YAML::dump(options, file) }
    # end

    desc "key [KEY]", "set your Weather Underground developer key"
    def key(k)
      File.open(CONFIG_FILE, 'w') { |file| YAML::dump({:key => k}, file) }
      puts "Developer key set to #{k} in #{CONFIG_FILE}"
    end

    desc "forecast [LOCATION]", "fetch and print the current forecast for the location provided for the number of days provided. Defaults to 3 days for location determined by IP."
    def forecast(location='autoip')
      days_txt = []
      load_data(location)
      days = @forecast_and_conditions.forecast.txt_forecast.forecastday
      days.each_with_index { |d, i| days_txt << d if i%2 == 0 }
      days_data = @forecast_and_conditions.forecast.simpleforecast.forecastday

      puts format_forecast(days_txt, days_data)
    end

    desc "conditions [LOCATION]", "fetch and print the current conditions for [LOCATION]"
    def conditions(location='autoip')
      load_data(location)
      current_conditions = @forecast_and_conditions.current_observation
      puts format_current_conditions(current_conditions)
    end

    private
    def load_data(location)
      unless @forecast_and_conditions
        @dev_key ||= YAML.load_file(CONFIG_FILE)[:key]
        w = RbWunderground::Base.new(@dev_key)
        @forecast_and_conditions = w.forecast10day_and_conditions(location)
      end

      @location = location_for(@forecast_and_conditions.current_observation)
    end

    def format_current_conditions(conditions)
      cond = "Current conditions for #{@location}\n"
      cond << "#{conditions.weather} and #{conditions.temperature_string.foreground(:blue)}"
    end

    def format_forecast(days_txt, data)
      f = "Forecast for #{@location}\n"
      days_txt.each_with_index do |day, i|
        f << "#{day.title.underline} (High: #{high_temp(data[i])}, Low: #{low_temp(data[i])})\n"
        f << day.fcttext << "\n"
      end
      f
    end

    def location_for(conditions)
      loc = ""
      country = conditions.display_location.country
      loc << "#{conditions.display_location.city}, "
      loc << (country == "US" ? conditions.display_location.state : country)
      loc.foreground(:green)
    end

    def high_temp(day)
      "#{day.high.fahrenheit}F".foreground(:red)
    end

    def low_temp(day)
      "#{day.low.fahrenheit}F".foreground(:blue)
    end

  end
end