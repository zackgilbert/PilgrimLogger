require "sinatra"
require "sinatra/activerecord"
require './config/environments'
require './models/event'
require 'dotenv/load'

class App < Sinatra::Base
  set :method_override, true

  @auth = nil

  def authorized?
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials.last == ENV["PILGRIM_SECRET"]
  end

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Oops... we need your pilgrim secret\n"])
    end
  end

  get "/" do
    protected! if ENV["PILGRIM_SECRET"].present?

    @can_manage = request.query_string.include?('admin')

    @events = Event.order('id DESC')

    erb :index
  end

  post "/" do
    params['json'] = JSON.parse(params['json'])
    @event = Event.new(raw_data: params)

    # if user has set to only accept their webhooks, ignore everything else
    @should_ignore = ENV['PILGRIM_SECRET'].present? && ( params['secret'] != ENV['PILGRIM_SECRET'] )

    if @should_ignore
      puts "Ignored because payload secret #{params['secret']} didn't match #{ENV['PILGRIM_SECRET']}"
    elsif @event.save
      redirect to('/')
    else
      "Sorry there was an error: #{@event.inspect}"
    end
  end

  post "/save" do
    params['json'] = JSON.parse(params['json'])
    @event = Event.new(raw_data: params, raw_headers: headers)

    # if user has set to only accept their webhooks, ignore everything else
    @should_ignore = ENV['PILGRIM_SECRET'].present? && ( params['secret'] != ENV['PILGRIM_SECRET'] )

    if @should_ignore
      puts "Ignored because payload secret #{params['secret']} didn't match #{ENV['PILGRIM_SECRET']}"
    elsif @event.save
      redirect to('/')
    else
      "Sorry there was an error: #{@event.inspect}"
    end
  end

  post "/manual" do
    params['event']['raw_data'] = JSON.parse(params['event']['raw_data'])
    params['event']['raw_data']['json'] = JSON.parse(params['event']['raw_data']['json']) if params['event']['raw_data']['json'].present?

    @event = Event.new(params['event'])

    if @event.save
      redirect to('/')
    else
      "Sorry there was an error!"
    end
  end

  delete '/events/:id' do
    if params[:id] == 'all'
      @events = Event.all
      @events.each {|e| e.destroy! }

      redirect to('/?admin')
    elsif @event = Event.delete(params[:id])
      redirect to('/?admin')
    else
      "Sorry there was an error!"
    end
  end

end
