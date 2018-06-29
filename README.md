# PilgrimLogger

Note: It is still experimental and being developed. Use at own risk, but please feel free to fork and provide updates.


This is a tool that will help provide visibility into Foursquare's Pilgrim activity.

Built using: Ruby 2.3.3, Sinatra, Postgresql, Bootstrap 4, jQuery.


Accepting only from your account
================================

You can add some extra security by setting the `PILGRIM_SECRET` environment variable. If this environment variable is set, any payloads who's secret doesn't match will be ignored. You can find your account's Pilgrim Secret from your Pilgrim Configuration console:

![Screenshot of Webhook configuration](https://cl.ly/0L171i1Q2F39)


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

- Improve documents and reliability.
- Figure out best way to display fields/data (human friendly date fields, display fields in tables, raw data in modal).
- Improve search. Be able to search for multiple data using and (&&), or (||) and "quoted" modifiers.
- Ability to handle multi user data.
- Provide basic visualizations/statistics/graphs to easily show occurance of events.
- Some type of basic authentication.


