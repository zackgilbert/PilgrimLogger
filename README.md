# PilgrimLogger

Note: It is still experimental and being developed. Use at own risk, but please feel free to fork and provide updates.


This is a tool that will help provide visibility into Foursquare's Pilgrim activity.

Built using: Ruby 2.3.3, Sinatra, Postgresql, Bootstrap 4, jQuery.

Note: If a ENV['PILGRIM_SECRET'] is set, basic http auth will ask for that to view the index. We use dotenv locally to store any env variables in a .env file.


To start the server (in dev): `bundle exec rackup -p 3000`

### To run the irb console:

For local dev environment, in terminal: `irb`
For heroku prod environment, in terminal: `heroku run console`

Then to load necessary files, paste into prompt:
```
require "sinatra"
require 'sinatra/activerecord'
require './config/environments'
require './models/event'
```


Accepting only from your account
================================

You can add some extra security by setting the `PILGRIM_SECRET` environment variable. If this environment variable is set, any payloads who's secret doesn't match will be ignored. You can find your account's Pilgrim Secret from your Pilgrim Configuration console:

![Screenshot of Webhook configuration](https://dha4w82d62smt.cloudfront.net/items/3V430v1c1r0m2G0M2N3N/Screen%20Shot%202018-06-29%20at%2011.10.54%20AM.png)


Accessing locally through ngrok
===============================

When you’re using this application in your local development environment, your app is only reachable by other programs on the same computer, so Pilgrim won’t be able to talk to it.

Ngrok is our favorite tool for solving this problem. Once started, it provides a unique URL on the ngrok.io domain which will forward incoming requests to your local development environment.

To start, go to ngrok.com and create a free ngrok account:
1. Download ngrok.
1. Unzip the install (for Mac OSX, I put my ngrok in my user directory)
1. Connect your account: `~/ngrok authtoken *api_key*` (note, this might be slightly different for you, depending on where you installed ngrok to.)

Next, make sure your server is running locally:
1. From terminal, cd to the project's root sinatra directory.
1. Type: `bundle exec rackup`
1. Confirm the app is running locally by going to `http://localhost:9292/` in your web browser.

Start ngrok'ing!
1. From terminal: `~/ngrok http 9292`
1. You can now visit `http://localhost:4040` in your browser to see live requests coming through your ngrok tunnel.
1. You will be given a `https://*.ngrok.io` forwarding web address that you can use to access your local server.

![Screenshot of ngrok running from terminal](https://dha4w82d62smt.cloudfront.net/items/461E0K3P0E2S1j2Q3i2r/Screen%20Shot%202018-06-29%20at%2011.28.29%20AM.png)

You are now ready to accept Pilgrim webhook payloads! Just add the https version of your ngrok.io url to your Pilgrim Configuration's Webhook URL.


Looking to self-host?
=====================

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Deploy your own instance using Heroku
Create a Heroku account if you haven't, then grab the source using git:

`$ git clone git://github.com/zackgilbert/pilgrimLogger.git`

From the project directory, create a Heroku application:

`$ heroku create`

Add Heroku's postgresql addon:

`$ heroku addons:add heroku-postgresql`

Set an environment variable to indicate production:

`$ heroku config:set REALM=prod`

Now just deploy via git:

`$ git push heroku master`

It will push to Heroku and give you a URL that your own private pilgrimLogger will be running.


Todos:
======

X Some type of basic authentication.
- Improve documents and reliability.
- Figure out best way to display fields/data (human friendly date fields, display fields in tables, raw data in modal).
- Improve search. Be able to search for multiple data using and (&&), or (||) and "quoted" modifiers.
- Ability to handle multi user/app data.
- Provide basic visualizations/statistics/graphs to easily show occurance of events.
- Load lat/lng locations on a map.

