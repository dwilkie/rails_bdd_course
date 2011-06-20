!SLIDE incremental

# Introduction to BDD in Rails
## David Wilkie
* ### [https://github.com/dwilkie/rails\_bdd\_course](https://github.com/dwilkie/rails_bdd_course)

!SLIDE center incremental

# Exercise
## Learn by doing!

* ![Mockup](/mockups/images/list_products.png)

!SLIDE commandline incremental

# Setup

    $ git clone git://github.com/dwilkie/rails_bdd_course.git
    $ cd rails_bdd_course/
    $ git checkout new_store
    $ cd store/

    Examining /home/dave/work/tmp/rails_bdd_course/store/.rvmrc complete.

    ================================================================
    = Trusting an .rvmrc file means that whenever you cd into the  =
    = directory RVM will execute this .rvmrc script in your shell  =
    =                                                              =
    = Now that you have examined the contents of the file, do you  =
    = wish to trust this .rvmrc from now on?                       =
    ================================================================

    (yes or no) > yes

!SLIDE commandline incremental

    $ bundle install --path vendor

    ...
    Your bundle is complete! It was installed into ./vendor

!SLIDE incremental

# Describing features with Cucumber
## Feature Definition

    # features/list_products.feature

    Feature: List Products
      In order to purchase the right product
      As a customer
      I want to browse products and see the price

!SLIDE incremental

## Scenario

    Scenario: List Products
      Given the following products exist
        | name   | price |
        | Abc    | 2.99  |
        | Angkor | 0.99  |
      When I go to the products page
      Then I should see "Products"
      And I should see "Name"
      And I should see "Price"
      And I should see "Abc" within "#product_1"
      And I should see "$2.99" within "#product_1"
      And I should see "Angkor" within "#product_2"
      And I should see "$0.99" within "#product_2"

!SLIDE commandline incremental

## Generate product model

    $ rails g model product
    invoke  active_record
    create    db/migrate/20110620051418_create_products.rb
    create    app/models/product.rb
    invoke    rspec
    create      spec/models/product_spec.rb

!SLIDE

## Add name and price to Migration

    # db/migration/*_create_products.rb

    def change
      create_table :products do |t|
        t.string  :name
        t.decimal :price

        t.timestamps
      end
    end

!SLIDE commandline incremental

## Migrate the db and clone structure to test db

    $ bundle exec rake db:migrate
    $ bundle exec rake db:test:clone

!SLIDE commandline incremental

## Start the Spork server and run the features

    $ bundle exec spork cuc
    $ bundle exec cucumber features/

!SLIDE

## Add the routes
    # config/routes.rb

    Store::Application.routes.draw do
      resources :products
      ...
    end

