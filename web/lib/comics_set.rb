# comics_set.rb
# A library for manipulating the data driving the Comics Today web app.
require 'json'
require 'date'

class ComicsSet
  attr_accessor :config

  def initialize(path)
    @config = read(path)
  end

  def read(path)
    return nil unless File.exists?(path)
    @config = JSON.load(File.read(path))
  end


  # Fetch the config for a specific comic by slug.
  def select_slug(slug)
    subset = @config['comics'].select {|c| c['slug'] == slug}

    return subset
  end

  # Fetch the config for comics posting on the given day of the week
  def select_wday(day = nil)
    day = Date.today.wday if day.nil?

    wday_symbol = if day.kind_of?(Integer)
      wday_symbol = case day
        when 0
          'Su'
        when 1
          'M'
        when 2
          'T'
        when 3
          'W'
        when 4
          'R'
        when 5
          'F'
        when 6
          'Sa'
        end
    else
      day
    end

    @config['comics'].select {|c| c['update_schedule'].include?(wday_symbol)}
  end
end

