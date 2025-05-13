# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
ruby-3.3.3

Use rvm and create a gemset data4he

bundle install

* System dependencies

* Configuration

Delete config/master.key and config/credentials.yml.enc
Generate them with EDITOR="vi --wait" bin/rails credentials:edit

* Database creation
In psql

CREATE ROLE data4he_user WITH CREATEDB PASSWORD 'data4he_password';

Then

bin/rails db:create

* Database initialization

bin/rails db:migrate

For testing:

RAILS_ENV=test bin/rails db:migrate

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
