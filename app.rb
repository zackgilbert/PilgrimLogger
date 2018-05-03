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
    params['event']['raw_data'] = JSON.parse(params['event']['raw_data'])
    params['event']['raw_data']['json'] = JSON.parse(params['event']['raw_data']['json'])

    @event = Event.new(params['event'])

    if @event.save
      redirect to('/')
    else
      "Sorry there was an error!"
    end
  end

  post "/webhook" do
    params['json'] = JSON.parse(params['json'])
    @event = Event.new(raw_data: params)

    if @event.save
      redirect to('/')
    else
      "Sorry there was an error!"
    end
  end

  delete '/events/:id' do
    if @event = Event.delete(params[:id])
      redirect to('/')
    else
      "Sorry there was an error!"
    end
  end

end
