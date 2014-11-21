Bookmark-Manager
================

##Week 4: Introduction To Databases

The aim of this project was to build a bookmark manager.  This would build on Capybara Integration testing, introduce Relational Databases via PostgreSQL, deploy DataMapper for Object Relational Mapping, and introduce Security through BCrypt and a discussion on hashes.  We began to learn a little about CSS in this project and the end web-site and production database can be found [hosted on Heroku here](http://lit-meadow-8615.herokuapp.com/).  

###Bookmark Manager

The website maintains a collection of links and allows you to add tags. You can add tags to the webpages you save.  Users can create accounts, log-in, log-out, and retrieve lost passwords.  Passwords are encrypted on the database with a salt, courtesy of BCrypt.

###Technologies
- DataMapper
- Ruby
- RSpec
- Sinatra-Cucumber
- Heroku
- Mailgun API
- HTML/CSS