Open Source Job Board
=====================

This repository contains the application we'll be developing during our participation in the [Rails Girls Summer of Code 2013] (http://railsgirlssummerofcode.org/) project.

Description of project
----------------------
The Open Source Job Board is a job board for developers built with the Cuba microframework. The application uses the developer's GitHub information as a substitution for filling out a CV and will simplify the process of applying for job offers.

Usage
------------
Clone this repository, then create a `env.sh` file in the project folder.

*example*:

``` ruby
# cat env.sh
APP_SECRET='your app secret'
OPENREDIS_URL=redis://127.0.0.1:6379/
GITHUB_CLIENT_ID='your GitHub client id'
GITHUB_CLIENT_SECRET='your GitHub client secret'
GITHUB_OAUTH_AUTHORIZE=https://github.com/login/oauth/authorize
GITHUB_OAUTH_ACCESS_TOKEN=https://github.com/login/oauth/access_token
GITHUB_FETCH_USER=https://api.github.com/user
MALONE_URL=smtp://username:password@smtp.gmail.com:587
RESET_URL=http://localhost:9393
```

Tools
-----
- [Cuba:] (http://cuba.is/) Microframework built in Ruby.
- [Mote:] (https://github.com/soveran/mote) Minimum Operational Template.
- [Redis:] (http://www.redis.io) Open source database.
- [Ohm:] (http://soveran.github.io/ohm/) Library that allows to store objects in Redis.
- [Scrivener:] (https://github.com/soveran/scrivener) Validation frontend for models.
- [Shield:] (https://github.com/soveran/shield) Authentication library.
- [Rack-protection:] (https://github.com/rkh/rack-protection) Protects against typical web attacks.
- [Cutest:] (https://github.com/djanowski/cutest) For testing.
- [Requests:] (https://github.com/cyx/requests) for sending HTTP requests.
- [Malone:] (https://github.com/cyx/malone) for mailing.
- [Nobi:] (https://github.com/cyx/nobi) for creating a password reset link.

Disclaimer: If you break the internet by running this application we assume no responsibility!
