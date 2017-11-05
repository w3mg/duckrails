# DuckRails [![GitHub version](https://badge.fury.io/gh/iridakos%2Fduckrails.png?a=1)](https://badge.fury.io/gh/iridakos%2Fduckrails?a=1) [![Build Status](https://travis-ci.org/iridakos/duckrails.svg?branch=master)](https://travis-ci.org/iridakos/duckrails)

DuckRails is a development tool.

Its main purpose is to allow developers to quickly mock API endpoints that for many possible reasons they can't reach at a specific time.

> If it looks like a duck, walks like a duck and quacks like a duck, then it's a duck

![Home Page](http://i.imgur.com/3hm0Gaj.png)

## How it works

The application allows creating new routes dynamically to which developers can assign static or dynamic responses:

- body
- headers
- content type
- status code

or even cause delays, timeouts etc.

### Guides

You can find DuckRails' guides [here](http://iridakos.com/2016/04/01/duckrails-guide.html).

### Example

Mocks index page

![Mocks index page](http://i.imgur.com/lD1fArF.png)

Changing mocks order

![Change mocks order](http://i.imgur.com/PcaaikA.png)

Setting general mock properties

![General mock properties](http://i.imgur.com/aBPIPUe.png)

Defining the response body

![Defining the response body](http://i.imgur.com/Sa6wern.png)

Setting response headers

![Setting response headers](http://i.imgur.com/ql2UR0f.png)

Setting some advanced configuration (delays, dynamic headers, content type & status)

![Advanced configuration](http://i.imgur.com/wXNVULN.png)

Upon save the route becomes available to the application and you can use the endpoint:

![Request](http://i.imgur.com/NaCIqs9.png)
![Headers](http://i.imgur.com/1jZciKH.png)

## Supported response functionality

You can define static or dynamic responses for a mock.

Currently supported dynamic types are:

- Embedded ruby
- Javascript

### Embedded ruby

When specifying dynamic content of embedded ruby (more options to be added), you can read as local variables:

- `@parameters`: The parameters of the request
- `@request`: The request
- `@response`: The response

### Javascript

When specifying dynamic content of javascript type, you can read as local variables:

- `parameters`: The parameters of the request
- `headers`: The request headers

The script should always return a string (for JSON use `JSON.stringify(your_variable)`)

### Route paths

You can specify routes and access their parts in the *@parameters* variable, for example:

`/authors/:author_id/posts/:post_id`

give you access to the parameters with:

`@parameters[:author_id]`

`@parameters[:post_id]`

## Quick setup (development environment)

* Clone the repository.
* Copy the sample database configuration file (`config/database.yml.sample`) under `config/database.yml` and edit it to reflect your preferred db configuration (defaults to sqlite3). If you change the database adapter, make sure you include the appropriate gem in your `Gemfile` (ex. for mysql `gem 'mysql2'`)
* Execute `bundle install` to install the required gems.
* Execute `rake db:setup` to setup the database.
* Execute `rails server` to start the application on the default port.

## Better setup (production environment)
* Clone the repository.
* Copy the sample database configuration file (`config/database.yml.sample`) under `config/database.yml` and edit it to reflect your preferred db configuration (defaults to sqlite3). If you change the database adapter, make sure you include the appropriate gem in your `Gemfile` (ex. for mysql `gem 'mysql2'`)
* Execute `bundle install` to install the required gems.
* Export an env variable for your [secret key base](http://stackoverflow.com/questions/23726110/missing-production-secret-key-base-in-rails): `export SECRET_KEY_BASE="your_secret_key_base_here"`
* Execute `RAILS_ENV=production rake db:setup` to setup the database.
* Execute `RAILS_ENV=production rake assets:precompile` to generate the assets.
* Execute `bundle exec rails s -e production` to start the application on the default port.

## Database configuration

The application is by default configured to use sqlite3. If you want to use another configuration, update the `config/database.yml` accordingly to match your setup.

## Docker

A docker image is available at docker hub under [iridakos/duckrails](https://hub.docker.com/r/iridakos/duckrails/).

To obtain the image use:

`docker pull iridakos/duckrails`

To start the application and bind it to a port (ex. 4000) use:

`docker run -p 4000:80 iridakos/duckrails:latest`

## Contributing

1. Fork it ( https://github.com/iridakos/duckrails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

This application is open source under the [MIT License](https://opensource.org/licenses/MIT) terms.
