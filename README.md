# narita

This is the webapp for analysis of logged data collected during the Child of our Time experiment.

## Dependencies

* Ruby 2.x
* Javascript runtime (nodejs, etc)
* Ruby, libxml development headers
* PostgreSQL database server

## Running

* bundle exec rake db:migrate [RAILS_ENV=production]
* bundle exec unicorn_rails [-E production]


