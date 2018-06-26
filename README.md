# PilgrimLogger

Note: It is still experimental and being developed. Use at own risk, but please feel free to fork and provide updates.


This is a tool that will help provide visibility into Foursquare's Pilgrim activity.

Built using: Ruby 2.3.3, Sinatra, Postgresql, Bootstrap 4, jQuery.


Todos:
======

- Improve documents and reliability.
- Figure out best way to display fields/data (human friendly date fields, display fields in tables, raw data in modal).
- Improve search. Be able to search for multiple data using and (&&), or (||) and "quoted" modifiers.
- Ability to handle multi user data.
- Provide basic visualizations/statistics/graphs to easily show occurance of events.
- Some type of basic authentication.



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



