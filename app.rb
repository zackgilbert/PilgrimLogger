require "sinatra"
require 'sinatra/activerecord'
require './config/environments'
require './models/event'

class App < Sinatra::Base
  set :method_override, true

  get "/" do
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
    if @event = Event.delete(params[:id])
      redirect to('/?admin')
    else
      "Sorry there was an error!"
    end
  end

end
