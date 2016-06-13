require 'sinatra/base'
require 'time'
require 'date'
require 'json'
require 'logger'
require 'erb'
require_relative '../lib/comics_set.rb'

class ComicsTodayApp < Sinatra::Base

  configure do
    set :logging, true
    set :logging_level, Logger::DEBUG
    set :comics_config_path, File.join(__dir__, '..', 'config', 'comics.json')
    set :comics_set, ComicsSet.new(settings.comics_config_path)
    set :log, Logger.new(File.join(__dir__, '..', 'shared', 'log', 'web.log'), 'daily')
    settings.log.sev_threshold = Logger::DEBUG
  end

  get '/GetServiceStatus' do
    status 200
    # TODO: check latency to the auth and mongo servers
    response = {
      'logging' => settings.logging,
      'logging_level' => settings.logging_level,
      'comics_config_path' => settings.comics_config_path,
    }
    body response.to_s
  end

  get '/ComicConfig' do
    s = settings.comics_set.config
    if s.nil? || s['comics'].length == 0
      status 404
      body "{\"error_message\":\"No comics found in database\"}"
    else
      status 200
      body s.to_s
    end
  end

  get '/ComicConfig/:slug' do
    s = settings.comics_set.select_slug(params[:slug])
    if s.nil?
      status 404
      body "{\"error_message\":\"Invalid slug '#{params[:slug]}'\"}"
    else
      status 200
      body s.to_s
    end
  end

  get '/ComicList' do
    comics = settings.comics_set.select_wday(Date.today.wday)

    if comics.nil? || comics.length == 0
      status 404
      body "{\"error_message\":\"No comics for today!\"}"
    else
      template = File.read(File.join(__dir__, '..', 'views', 'comics_today.erb'))
      status 200
      body ERB.new(template).result(binding)
    end
  end


  
end
