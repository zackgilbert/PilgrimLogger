require "sinatra"
require "sinatra/activerecord"
require './config/environments'
require './models/event'
require 'dotenv/load'

class App < Sinatra::Base
  set :method_override, true

  @auth = nil

  def authorized?
    puts "ENV: #{ENV["PILGRIM_SECRET"].inspect}"

    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials.last == ENV["PILGRIM_SECRET"]
  end

  def protected!
    unless settings.development? || authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Oops... we need your pilgrim secret\n"])
    end
  end

  def get_event
    payload = params
    my_headers = request.env.reject { |k,v|
      k.include?('rack.') ||
      k.include?('sinatra.') ||
      k.include?('SERVER_') ||
      k.include?("GATEWAY_INTERFACE") ||
      k.include?("PATH_INFO") ||
      k.include?("REMOTE_") ||
      k.include?("SCRIPT_NAME")
    }

    if params['secret'] # v1
      # fix json coming in as encoded
      payload['json'] = JSON.parse(payload['json'])
    else # v2
      payload = JSON.parse(request.body.read).symbolize_keys
    end
    puts my_headers.inspect
    puts payload.inspect

    Event.new(raw_data: payload, raw_headers: my_headers)
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
    @should_ignore = ENV['PILGRIM_SECRET'].present? && ( @event.secret != ENV['PILGRIM_SECRET'] )

    if @should_ignore
      puts "Ignored because payload secret #{params['secret']} didn't match #{ENV['PILGRIM_SECRET']}"
    elsif @event.save
      redirect to('/')
    else
      "Sorry there was an error: #{@event.inspect}"
    end
  end

  post "/save" do
    @event = get_event

    # if user has set to only accept their webhooks, ignore everything else
    @should_ignore = ENV['PILGRIM_SECRET'].present? && ( @event.secret != ENV['PILGRIM_SECRET'] )

    if @should_ignore
      puts "Ignored because payload secret #{params['secret']} didn't match #{ENV['PILGRIM_SECRET']}"
      status 200
      body ''
    elsif @event.save
      status 200
      body @event.to_json
    else
      status 500
      "Sorry there was an error: #{@event.inspect}"
    end
  end

  post "/manual" do
    params['event']['raw_data'] = JSON.parse(params['event']['raw_data'])
    params['event']['raw_data']['json'] = JSON.parse(params['event']['raw_data']['json']) if params['event']['raw_data']['json'].present?

    @event = Event.new(raw_data: params['event'])

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
