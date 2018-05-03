require "sinatra"
require 'sinatra/activerecord'
require './config/environments'
require './models/event'

class App < Sinatra::Base
  set :method_override, true

  get "/" do
    @can_manage = request.query_string.include?('admin')

    @events = Event.all

    erb :index
  end

  post "/" do
    @event = Event.new(params)

    if @event.save
      redirect to('/')
    else
      "Sorry there was an error!"
    end
  end

  post "/webhook" do
    @event = Event.new(rawdata: params)

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
