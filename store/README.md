This is the *fresh version* of the exercise as shown in the [presentation](http://dwilkie.github.com/rails_bdd_course)

## Set up from scratch

### Install the latest Rails

    $ gem install rails --pre
    $ rails new store
    $ cd store

### Update your [Gemfile](https://github.com/dwilkie/rails_bdd_course/blob/new_store/store/Gemfile)

    $ bundle install --path vendor
    $ rails g cucumber:install --spork

### [Make Pickle work with Spork](http://stackoverflow.com/questions/6180461/using-pickle-with-spork)

Add this line to [features/support/env.rb](https://github.com/dwilkie/rails_bdd_course/blob/new_store/store/features/support/env.rb)

    Spork.each_run do
      Dir["#{Rails.root}/app/models/*.rb"].each { |f| load f }

### Install RSpec

    rails g rspec:install
    bundle exec spork rspec --bootstrap

Update [spec/spec_helper.rb](https://github.com/dwilkie/rails_bdd_course/blob/new_store/store/spec/spec_helper.rb) for Spork

### Install Pickle

    rails g pickle --paths (say 'yes' to override file)

### Install Nifty Layout

    rails g nifty:layout --haml

### Fix Nifty Layout for Asset Pipeline

Replace the following in [app/views/layouts/application.html.haml](https://github.com/dwilkie/rails_bdd_course/blob/new_store/store/app/views/layouts/application.html.haml)

    = stylesheet_link_tag "application"
    = javascript_include_tag "application"

### Cleanup

    $ rm app/views/layouts/application.html.erb
    $ mv public/stylesheets/sass/application.sass app/assets/stylesheets/application.sass
    $ rm -rf public/stylesheets/

